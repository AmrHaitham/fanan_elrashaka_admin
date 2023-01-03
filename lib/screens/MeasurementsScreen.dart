import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/ImageViwer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
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
  String? imageLocation ;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    print("pid is :- ${widget.pid}");
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
                      Text("AddNewMeasurement".tr()),
                      [
                        buildTextFormField(0,'Weight'.tr()),
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
                        buildNoteFormField(7),
                        const SizedBox(height: 10,),
                        DefaultButton(
                          text: "TakeMeasurementPicture".tr(),
                          color: Colors.brown,
                          press: ()async{
                            var imagePicker;
                            imagePicker = await _picker.pickImage(source: ImageSource.camera,imageQuality: 20);
                            imageLocation = imagePicker.path.toString();
                          },
                        ),
                      ],
                      DefaultButton(
                        text: "AddNewMeasurement".tr(),
                        press: ()async{
                          if (_formKey.currentState!.validate()){
                            _formKey.currentState!.save();
                            EasyLoading.show(status: "AddNewMeasurement".tr());
                            var changeProfileResponse = await _patientDetails.addMeasurement(
                                context.read<UserData>().token,
                                widget.pid.toString(),
                                data,
                                imageLocation
                            );
                            if (await changeProfileResponse.statusCode == 200) {
                              _dialogs.doneDialog(context,"You_are_successfully_added_new_Measurement".tr(),"Ok".tr(),(){
                                setState(() {
                                  _formKey.currentState!.reset();
                                  imageLocation = null;
                                });
                              });
                            }else{
                              var response = jsonDecode(await changeProfileResponse.stream.bytesToString());
                              print(response);
                              _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                            }
                          EasyLoading.dismiss();
                          }
                        },
                      )
                    );
                  },
                ),
                body: ScreenContainer(
                    onRefresh: (){
                      setState(() {});
                    },
                    topLeftAction:const BackIcon(),
                    name: "Measurements".tr(),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height*0.78,
                      margin:const EdgeInsets.only(top: 25),
                      padding:const EdgeInsets.all(5),
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpansionTileCard(
                                baseColor:Colors.white,
                                leading: (snapshot.data[index]['image']==null)
                                    ?  SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.asset("assets/user_avatar_male.png",)
                                    )
                                    : SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.network("${Apis.api}${snapshot.data[index]['image']}"
                                      ),
                                    ),
                                title: Text(
                                    DateFormat('dd/MM/yyyy - hh:mm a',context.locale.toString()).format(DateTime.parse(snapshot.data[index]['datetime'])).toString()
                                    ,style:
                                   const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0c1852),
                                    // fontSize: 20
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("${"Weight"}:         ",style: TextStyle(color: Constants.secondColor),),
                                              (snapshot.data[index]['weight'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['weight'].toString().split('.')[0]} kg",style:const TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Arms:             ",style: TextStyle(color: Constants.secondColor),),
                                              (snapshot.data[index]['arms'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['arms'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Chest:            ",style: TextStyle(color: Constants.secondColor),),
                                              (snapshot.data[index]['chest'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['chest'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Waist:            ",style: TextStyle(color: Constants.secondColor),),
                                              (snapshot.data[index]['waist'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['waist'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("High Hip:       ",style: TextStyle(color: Constants.secondColor),),
                                              (snapshot.data[index]['high_hip'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['high_hip'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Calves:           ",style: TextStyle(color: Constants.secondColor),),
                                              (snapshot.data[index]['calves'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['calves'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Thigh:             ",style: TextStyle(color: Constants.secondColor),),
                                              (snapshot.data[index]['thigh'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['thigh'].toString().split('.')[0]} cm",style:const TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("BMI:                ",style: TextStyle(color: Constants.secondColor),),
                                              (snapshot.data[index]['bmi'].toString() == "null")?Text("---"):Text("${snapshot.data[index]['bmi'].toString().split('.')[0]}",style:const TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${"Notes"}:             ",style: TextStyle(color: Constants.secondColor),),
                                              (snapshot.data[index]['note'].toString() == "null")?Text("---"):
                                              Expanded(
                                                  child: Text("${snapshot.data[index]['note'].toString().split('.')[0]}",
                                                    style:const TextStyle(fontWeight: FontWeight.bold,),))
                                            ],
                                          ),
                                        ),
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
                                                Text("EditMeasurement".tr()),
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
                                                  buildinitNoteFormField(7,snapshot.data[index]['note']),
                                                  const SizedBox(height: 10,),
                                                  DefaultButton(
                                                    text: "SelectMeasurementPicture".tr(),
                                                    color: Colors.brown,
                                                    press: ()async{
                                                      var imagePicker;
                                                      imagePicker = await _picker.pickImage(source: ImageSource.camera,imageQuality: 20);
                                                      imageLocation = imagePicker.path.toString();
                                                    },
                                                  ),
                                                ],
                                                DefaultButton(
                                                  text: "UpdateMeasurement".tr(),
                                                  press: ()async{
                                                    if (_formKey.currentState!.validate()){
                                                      _formKey.currentState!.save();
                                                      EasyLoading.show(status: "UpdateMeasurement".tr());
                                                      print(data);
                                                      try{
                                                        var changeProfileResponse = await _patientDetails.updateMeasurement(
                                                            context.read<UserData>().token,
                                                            snapshot.data[index]['id'].toString(),
                                                            data,
                                                            imageLocation
                                                        );
                                                        if (await changeProfileResponse.statusCode == 200) {
                                                          _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"ok",(){
                                                            Navigator.pop(context);
                                                            imageLocation = null;
                                                            setState(() {});
                                                          });
                                                        }else{
                                                          var response = jsonDecode(await changeProfileResponse.stream.bytesToString());
                                                          print(response);
                                                          _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                                                        }
                                                        EasyLoading.dismiss();
                                                      }catch(v){
                                                        print(v);
                                                        _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                                                      }
                                                    }
                                                  },
                                                )
                                            );
                                          }, icon: Icon(Icons.edit), label: Text("Edit".tr())
                                      ),
                                      if(snapshot.data[index]['image']!=null)
                                        ElevatedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:  MaterialStateProperty.all(Colors.brown),
                                          ),
                                          icon: Icon(Icons.image,), label: Text("Picture".tr()),
                                          onPressed: (){
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) =>ImageViwer(imageUrl: snapshot.data[index]['image']))
                                            );
                                          },
                                        ),
                                      ElevatedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:  MaterialStateProperty.all(Colors.red)
                                            ),
                                          onPressed: ()async{
                                            EasyLoading.show(status: "DeleteMeasurement".tr());
                                            var response = await _patientDetails.deleteMeasurement(
                                              context.read<UserData>().token,
                                              snapshot.data[index]['id'].toString(),
                                            );
                                            var data = jsonDecode(await response.stream.bytesToString());
                                            if (await response.statusCode == 200) {
                                              print(data);
                                              EasyLoading.showSuccess("DoneDeletingMeasurement".tr());
                                              setState(() {});
                                            }else{
                                              print(data);
                                            }
                                            EasyLoading.dismiss();
                                          }, icon: Icon(Icons.delete_forever,), label: Text("Delete".tr())
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
          return LocaleKeys.ThisFieldIsRequired.tr();
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
        labelText: "Note".tr(),
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
          return LocaleKeys.ThisFieldIsRequired.tr();
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
        labelText: "Note".tr(),
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
