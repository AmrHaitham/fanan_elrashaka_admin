import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/EditPationt.dart';
import 'package:fanan_elrashaka_admin/screens/MainScreen.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ProfilePic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:intl_phone_field/countries.dart' as c;
class EditDrPationt extends StatefulWidget {
  final id ;
  EditDrPationt({Key? key,required this.id}) : super(key: key);

  @override
  State<EditDrPationt> createState() => _EditDrPationtState();
}

class _EditDrPationtState extends State<EditDrPationt> {
  final Dialogs _dialogs = Dialogs();

  final Patients _patients = Patients();

  final _formKey = GlobalKey<FormState>();

  String? firstName;

  String? height;

  String? TargetWeight;

  String? phoneNumber;

  String? notes;

  String? country_code;

  final ImagePicker _picker = ImagePicker();

  getCountryCode(cCode){
    try{
      var cCodes =c.countries.singleWhere((element) => element.dialCode==cCode.split("+")[1]).code;
      return cCodes;
    }catch(e){
      return "EG";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _patients.getDrPatient(context.read<UserData>().token, widget.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoading());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // error in data
              print(snapshot.error.toString());
              return  Container();
            } else if (snapshot.hasData) {
              print(snapshot.data);
              return EditScreenContainer(
                  name: "EditDoctorPatient".tr(),
                  topLeftAction: BackIcon(),
                  topRightaction: InkWell(
                    onTap: ()async{
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // save data
                        EasyLoading.show(status: "EditDoctorPatient".tr());
                        try{
                          var changeProfileResponse = await _patients.updateDrPatient(
                            context.read<UserData>().token,
                            snapshot.data['pid'].toString(),
                            firstName,
                            phoneNumber,
                            height,
                            TargetWeight,
                            notes
                          );
                          if (await changeProfileResponse.statusCode == 200) {
                            _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){});
                            print(await changeProfileResponse.stream.bytesToString());
                          }else{
                            print(await changeProfileResponse.stream.bytesToString());
                            _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                          }
                          EasyLoading.dismiss();
                          setState(() {});
                        }catch(v){
                          EasyLoading.dismiss();
                          setState(() {});
                        }

                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 25,
                      height: 25,
                      child: Image.asset("assets/Save-512.png"),
                    ),
                  ),
                  topCenterAction: ProfilePic(
                    profile: snapshot.data['image'],
                    uploadImage: () async{
                      EasyLoading.show(status: "EditDoctorPatient".tr());
                      try{
                        var imagePicker;
                        imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                        String imageLocation = imagePicker.path.toString();
                        var picResponse =await _patients.updateDrPatientImage(
                            context.read<UserData>().token,
                            snapshot.data['pid'],
                            snapshot.data['name'],
                            snapshot.data['phone'],
                            snapshot.data['height'],
                            snapshot.data['target_weight'],
                            imageLocation,
                            snapshot.data['note']
                        );
                        if (await picResponse.statusCode == 200) {
                          _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){});
                        }else{
                          print(await picResponse.stream.bytesToString());
                          _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
                        }
                        EasyLoading.dismiss();
                        setState(() {});
                      }catch(v){
                        EasyLoading.dismiss();
                        setState(() {});
                      }
                    },
                  ),
                  child: Expanded(
                    child: Padding(
                      padding:EdgeInsets.only(right: 15,left: 15),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              buildFirstNameFormField(snapshot.data['name']),
                              const SizedBox(height: 20),
                              buildPhoneNumberFormField(snapshot.data['phone']),
                              const SizedBox(height: 20),
                              buildHeightFormField(snapshot.data['height']??""),
                              const SizedBox(height: 20),
                              buildTargetWeightFormField(snapshot.data['target_weight']??""),
                              const SizedBox(height: 20),
                              buildNotesFormField(snapshot.data['note']),
                              const SizedBox(height: 20),
                              const Divider(height: 5,color: Colors.black,thickness: 0.1,),
                              const SizedBox(height: 10),
                              if(snapshot.data["patient_id"]!= null)
                              TextField(
                                decoration: InputDecoration(
                                  suffixIcon: Container(
                                    width: 10,
                                    height: 10,
                                    child:
                                    Icon(Icons.arrow_forward_ios),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                  ),
                                  hintText: "EditPatientData".tr(),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                ),
                                readOnly: true,
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => EditPationt(id: snapshot.data["patient_id"].toString(),refreshOnBack: false,))
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Card(
                                color:const Color(0xffff5d63),
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset("assets/delete.png"),
                                  ),
                                  title: Text("DeletePatientData".tr(),style: TextStyle(
                                      color: Constants.mainColor,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  trailing: SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: Image.asset("assets/right-arrow_gray.png",color: Colors.white,),
                                  ),
                                  onTap: (){
                                    AwesomeDialog(
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.WARNING,
                                        body: Center(child: Text(
                                          "AreYouSureYouWantToDeleteThisPatient".tr(),
                                        ),),
                                        btnOkOnPress: () async{
                                          var response = await _patients.deleteDrPatient(context.read<UserData>().token, snapshot.data['pid'].toString());
                                          if (await response.statusCode == 200) {
                                            print(await response.stream.bytesToString());
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 1,))
                                            );
                                          }
                                        },
                                        btnCancelOnPress: (){},
                                        btnCancelText:"Cancel".tr(),
                                        btnOkText:"Delete".tr()
                                    ).show();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
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


  TextFormField buildFirstNameFormField(name) {
    return TextFormField(
      initialValue: name,
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          firstName = value;
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
        labelText: "Name".tr(),
        // hintText: "Enter_your_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildHeightFormField(initHeight) {
    return TextFormField(
      initialValue: initHeight.toString(),
      onSaved: (newValue) => height = newValue,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (value.isNotEmpty) {
          height = value;
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
        labelText: "Height".tr(),
        // hintText: "Enter_your_Height",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildTargetWeightFormField(initTargetWeight) {
    return TextFormField(
      initialValue: initTargetWeight.toString(),
      keyboardType: TextInputType.number,
      onSaved: (newValue) => TargetWeight = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          TargetWeight = value;
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
        labelText: "TargetWeight".tr(),
        // hintText: "Enter_your_TargetWeight",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildNotesFormField(initnotes) {
    return TextFormField(
      initialValue: initnotes,
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => notes = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          notes = value;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Notes".tr(),
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildPhoneNumberFormField(phone) {
    return TextFormField(
      initialValue: phone,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "PhoneNumber".tr(),
        // hintText:"Enter_your_phone_number",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        phoneNumber = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          phoneNumber = value;
        }
        return null;
      },
      validator: (value) {
        if (value=="") {
          return LocaleKeys.ThisFieldIsRequired.tr();
        }
        return null;
      },
    );
  }
}
