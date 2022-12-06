import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class MeasurementsScreen extends StatefulWidget {
  final pid;

  const MeasurementsScreen({Key? key, this.pid}) : super(key: key);
  @override
  _MeasurementsScreenState createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  PatientDetails _patientDetails = PatientDetails();
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  final _formKey = GlobalKey<FormState>();
  List<String?> data = ["","","","","","","",""];
  Dialogs _dialogs = Dialogs();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _patientDetails.getAllMeasurements(context.read<UserData>().token, widget.pid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoading());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // error in data
              print(snapshot.error.toString());
              return  Container();
            } else if (snapshot.hasData) {
              print(snapshot.data);
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child:const Icon(Icons.add),
                  backgroundColor: Constants.secondColor,
                  onPressed: (){
                    _bottomSheetWidget.showBottomSheetForm(
                      context,
                        750.0,
                      _formKey,
                      Text("Add New Measurement"),
                      [
                        buildTextFormField(0,'Weight'),
                        const SizedBox(height: 10,),
                        buildTextFormField(1,'Arms'),
                        const SizedBox(height: 10,),
                        buildTextFormField(2,'Chest'),
                        const SizedBox(height: 10,),
                        buildTextFormField(3,'Waist'),
                        const SizedBox(height: 10,),
                        buildTextFormField(4,'High Hip'),
                        const SizedBox(height: 10,),
                        buildTextFormField(5,'Calves'),
                        const SizedBox(height: 10,),
                        buildTextFormField(6,'Thigh'),
                        const SizedBox(height: 10,),
                        buildNoteFormField(7)
                      ],
                      DefaultButton(
                        text: "Add Measurement",
                        press: ()async{
                          if (_formKey.currentState!.validate()){
                            _formKey.currentState!.save();
                            EasyLoading.show(status: "Adding Measurement");
                            var changeProfileResponse = await _patientDetails.addMeasurement(
                                context.read<UserData>().token,
                                widget.pid.toString(),
                                data
                            );
                            if (await changeProfileResponse.statusCode == 200) {
                              _dialogs.doneDialog(context,"You_are_successfully_added_new_Measurement","ok",(){
                                setState(() {
                                  _formKey.currentState!.reset();
                                });
                              });
                            }else{
                              var response = jsonDecode(await changeProfileResponse.stream.bytesToString());
                              print(response);
                              _dialogs.errorDialog(context, "Error_while_adding_Measurement_please_check_your_internet_connection");
                            }
                          EasyLoading.dismiss();
                          }
                        },
                      )
                    );
                  },
                ),
                body: ScreenContainer(
                    topLeftAction:const BackIcon(),
                    name: "Measurements",
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height*0.79,
                      margin:const EdgeInsets.only(top: 25),
                      padding:const EdgeInsets.all(5),
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpansionTileCard(
                                baseColor:const Color(0xfff8f4ff),
                                leading: (snapshot.data[index]['image']==null)
                                    ? const CircleAvatar(backgroundImage: AssetImage("assets/user_avatar_male.png"),)
                                    : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage("${Apis.api}${snapshot.data[index]['image']}"
                                  ),
                                ),
                                title: Text(
                                    DateFormat('dd/MM/yyyy - hh:mm a').format(DateTime.parse(snapshot.data[index]['datetime'])).toString()
                                    ,style:
                                   const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0c1852),
                                    // fontSize: 20
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("Weight:   ",style: TextStyle(color: Constants.secondColor),),
                                        (snapshot.data[index]['weight'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['weight'].toString().split('.')[0]} kg",style:const TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("Arms:   ",style: TextStyle(color: Constants.secondColor),),
                                        (snapshot.data[index]['arms'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['arms'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("Chest:   ",style: TextStyle(color: Constants.secondColor),),
                                        (snapshot.data[index]['chest'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['chest'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("Waist:   ",style: TextStyle(color: Constants.secondColor),),
                                        (snapshot.data[index]['waist'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['waist'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("High Hip:   ",style: TextStyle(color: Constants.secondColor),),
                                        (snapshot.data[index]['high_hip'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['high_hip'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("Calves:   ",style: TextStyle(color: Constants.secondColor),),
                                        (snapshot.data[index]['calves'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['calves'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("Thigh:   ",style: TextStyle(color: Constants.secondColor),),
                                        (snapshot.data[index]['thigh'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['thigh'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("BMI:   ",style: TextStyle(color: Constants.secondColor),),
                                        (snapshot.data[index]['bmi'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['bmi'].toString().split('.')[0]}",style:const TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("Notes:   ",style: TextStyle(color: Constants.secondColor),),
                                        (snapshot.data[index]['note'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['note'].toString().split('.')[0]}",style:const TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding:  EdgeInsets.only(top: 15.0,bottom: 10),
                                    child:  Divider(
                                      height: 4,
                                      color: Colors.black,
                                      thickness: 0.2,
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:  MaterialStateProperty.all(Constants.secondColor)
                                          ),
                                          onPressed: (){
                                            _bottomSheetWidget.showBottomSheetForm(
                                                context,
                                                750.0,
                                                _formKey,
                                                Text("Edit Measurement"),
                                                [
                                                  buildinitTextFormField(0,'Weight',snapshot.data[index]['weight']),
                                                  const SizedBox(height: 10,),
                                                  buildinitTextFormField(1,'Arms',snapshot.data[index]['arms']),
                                                  const SizedBox(height: 10,),
                                                  buildinitTextFormField(2,'Chest',snapshot.data[index]['chest']),
                                                  const SizedBox(height: 10,),
                                                  buildinitTextFormField(3,'Waist',snapshot.data[index]['waist']),
                                                  const SizedBox(height: 10,),
                                                  buildinitTextFormField(4,'High Hip',snapshot.data[index]['high_hip']),
                                                  const SizedBox(height: 10,),
                                                  buildinitTextFormField(5,'Calves',snapshot.data[index]['calves']),
                                                  const SizedBox(height: 10,),
                                                  buildinitTextFormField(6,'Thigh',snapshot.data[index]['thigh']),
                                                  const SizedBox(height: 10,),
                                                  buildinitNoteFormField(7,snapshot.data[index]['note'])
                                                ],
                                                DefaultButton(
                                                  text: "Update Measurement",
                                                  press: ()async{
                                                    if (_formKey.currentState!.validate()){
                                                      _formKey.currentState!.save();
                                                      EasyLoading.show(status: "Update Measurement");
                                                      print(data);
                                                      try{
                                                        var changeProfileResponse = await _patientDetails.updateMeasurement(
                                                            context.read<UserData>().token,
                                                            widget.pid.toString(),
                                                            data
                                                        );
                                                        if (await changeProfileResponse.statusCode == 200) {
                                                          _dialogs.doneDialog(context,"You_are_successfully_updated_new_Measurement","ok",(){
                                                            setState(() {
                                                              _formKey.currentState!.reset();
                                                            });
                                                          });
                                                        }else{
                                                          var response = jsonDecode(await changeProfileResponse.stream.bytesToString());
                                                          print(response);
                                                          _dialogs.errorDialog(context, "Error_while_updating_Measurement_please_check_your_internet_connection");
                                                        }
                                                        EasyLoading.dismiss();
                                                      }catch(v){
                                                        print(v);
                                                        _dialogs.errorDialog(context, "Error_while_updating_Measurement_please_check_your_internet_connection");
                                                      }
                                                    }
                                                  },
                                                )
                                            );
                                          }, icon: Icon(Icons.edit), label: Text("Edit")
                                      ),
                                      ElevatedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:  MaterialStateProperty.all(Colors.red)
                                            ),
                                          onPressed: ()async{
                                            EasyLoading.show(status: "Delete Measurement");
                                            var response = await _patientDetails.deleteMeasurement(
                                              context.read<UserData>().token,
                                              widget.pid,
                                            );
                                            var data = jsonDecode(await response.stream.bytesToString());
                                            if (await response.statusCode == 200) {
                                              print(data);
                                              EasyLoading.showSuccess("Done Deleting Measurement");
                                              Navigator.pop(context);
                                              setState(() {});
                                            }else{
                                              print(data);
                                            }
                                            EasyLoading.dismiss();
                                          }, icon: Icon(Icons.delete_forever,), label: Text("Delete")
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                      ),
                    )
                ),
              );
            }else{
              //no data
              return Container();
            }
          }else{
            //error in connection
            return Container();
          }
        }
    );
  }
  TextFormField buildTextFormField(int dataIndex , String name) {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => data[dataIndex] = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          data[dataIndex] = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "you_need_to_fill_this_text_field";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: name,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildNoteFormField(int dataIndex) {
    return TextFormField(
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => data[dataIndex] = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          data[dataIndex] = value;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Note",
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildinitTextFormField(int dataIndex , String name,initdata) {
    return TextFormField(
      initialValue: initdata.toString(),
      keyboardType: TextInputType.number,
      onSaved: (newValue) => data[dataIndex] = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          data[dataIndex] = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "you_need_to_fill_this_text_field";
        }else{
          data[dataIndex] = value;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: name,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildinitNoteFormField(int dataIndex,initdata) {
    return TextFormField(
      initialValue: initdata,
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => data[dataIndex] = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          data[dataIndex] = value;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Note",
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
