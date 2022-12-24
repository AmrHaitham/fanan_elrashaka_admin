import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class VisitationNoteScreen extends StatefulWidget {
  final pid;

  const VisitationNoteScreen({Key? key, this.pid}) : super(key: key);
  @override
  _VisitationNoteScreenState createState() => _VisitationNoteScreenState();
}

class _VisitationNoteScreenState extends State<VisitationNoteScreen> {
  PatientDetails _patientDetails = PatientDetails();
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  String? note;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _patientDetails.getAllVisitation_notes(context.read<UserData>().token, widget.pid),
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
                  backgroundColor: Constants.secondColor,
                  child:const Icon(Icons.add),
                  onPressed: (){
                    _bottomSheetWidget.showBottomSheetButtons(
                        context,
                        300.0,
                        const Text(""),
                        [
                          buildNoteFormField(),
                          const SizedBox(height: 20,),
                          DefaultButton(
                            text: "AddVisitationNote".tr(),
                            press: ()async{
                              if(note!=null){
                                EasyLoading.show(status: "AddVisitationNote".tr());
                                var response = await _patientDetails.addVisitation_note(
                                    context.read<UserData>().token,
                                    widget.pid,
                                    note
                                );
                                var data = jsonDecode(await response.stream.bytesToString());
                                if (await response.statusCode == 200) {
                                  print(data);
                                  EasyLoading.showSuccess("DoneAddingVisitationNote".tr());
                                  note = null;
                                  Navigator.pop(context);
                                  setState(() {});
                                }else{
                                  print(data);
                                }
                                EasyLoading.dismiss();
                              }
                            },
                          )
                        ]
                    );
                  },
                ),
                body: ScreenContainer(
                    topLeftAction:const BackIcon(),
                    name: LocaleKeys.VisitationNotes.tr(),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height*0.78,
                      margin:const EdgeInsets.only(top: 25),
                      padding:const EdgeInsets.all(5),
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            return InkWell(
                              child: Container(
                                  padding:const EdgeInsets.all(18),
                                  margin:const EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.1,color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0),
                                      color:const Color(0xfffbf8fd)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index]['note'],
                                        style:const TextStyle(
                                            color: Color(0xff0c1852),
                                            fontSize: 15
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        DateFormat('dd/MM/yyyy - hh:mm a',context.locale.toString()).format(DateTime.parse(snapshot.data[index]['datetime'])).toString(),
                                        style: TextStyle(
                                            color: Constants.secondTextColor,
                                            fontSize: 13
                                        ),
                                      ),
                                    ],
                                  ),
                              ),
                              onTap: (){
                                _bottomSheetWidget.showBottomSheetButtons(
                                    context,
                                    200.0,
                                    const Text(""),
                                    [
                                      ListTile(
                                        leading: Icon(Icons.edit,color: Constants.secondColor,),
                                        title: Text("EditVisitationNote".tr()),
                                        onTap: (){
                                          note = snapshot.data[index]['note'];
                                          _bottomSheetWidget.showBottomSheetButtons(
                                              context,
                                              300.0,
                                              const Text(""),
                                              [
                                                buildEditNoteFormField(snapshot.data[index]['note']),
                                                const SizedBox(height: 20,),
                                                DefaultButton(
                                                  text:"EditVisitationNote".tr(),
                                                  press: ()async{
                                                    print(context.read<UserData>().token+
                                                        " id -${widget.pid} -"+ note!);
                                                    if(note!=null){
                                                      EasyLoading.show(status: "EditVisitationNote".tr());
                                                      var response = await _patientDetails.updateVisitation_note(
                                                          context.read<UserData>().token,
                                                          snapshot.data[index]['id'].toString(),
                                                          note
                                                      );
                                                      var data = jsonDecode(await response.stream.bytesToString());
                                                      if (await response.statusCode == 200) {
                                                        print(data);
                                                        EasyLoading.showSuccess(LocaleKeys.You_are_successfully_updated_information.tr());
                                                        note = null;
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      }else{
                                                        print(data);
                                                      }
                                                      EasyLoading.dismiss();
                                                    }
                                                  },
                                                )
                                              ]
                                          );
                                        },
                                      ),
                                      const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                                      ListTile(
                                        leading: const Icon(Icons.delete,color: Colors.red,),
                                        title:  Text("DeleteVisitationNote".tr()),
                                        onTap: () async{
                                          EasyLoading.show(status: "DeleteVisitationNote".tr());
                                          var response = await _patientDetails.deleteVisitation_note(
                                              context.read<UserData>().token,
                                              snapshot.data[index]['id'].toString(),
                                          );
                                          var data = jsonDecode(await response.stream.bytesToString());
                                          if (await response.statusCode == 200) {
                                            print(data);
                                            EasyLoading.showSuccess("DoneDeletingVisitationNote".tr());
                                            Navigator.pop(context);
                                            setState(() {});
                                          }else{
                                            print(data);
                                          }
                                          EasyLoading.dismiss();
                                        },
                                      )
                                    ]
                                );
                              },
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
  TextFormField buildNoteFormField() {
    return TextFormField(
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => note = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          note = value;
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
        labelText: "Note".tr(),
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildEditNoteFormField(initData) {
    return TextFormField(
      initialValue: initData,
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => note = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          note = value;
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
        labelText: "Note".tr(),
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
