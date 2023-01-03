import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AllPationts.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ProfilePic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:intl_phone_field/countries.dart' as c;
class EditPationt extends StatefulWidget {
  final id ;
  final bool refreshOnBack;
  EditPationt({Key? key,required this.id,required this.refreshOnBack}) : super(key: key);

  @override
  State<EditPationt> createState() => _EditPationtState();
}

class _EditPationtState extends State<EditPationt> {
  final Dialogs _dialogs = Dialogs();

  final Patients _patients = Patients();

  final _formKey = GlobalKey<FormState>();

  final _passwordFormKey = GlobalKey<FormState>();

  String? email;

  String? password;

  String? oldPassword;

  String? conform_password;

  String? firstName;

  String? lastName;

  String? phoneNumber;

  String? gender;

  String? birthday;

  String? address;

  String? country_code;

  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  formatedDate(date){
    final components = date!.split("-");
    birthday = "${components[2]}/${components[1]}/${components[0]}";
    return birthday;
  }
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
    return WillPopScope(
      onWillPop: ()async{
        if(widget.refreshOnBack == true){
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>ListAllPatients())
          );
          return false;
        }
        else{
          return true;
        }
      },
      child: FutureBuilder(
          future: _patients.getPatient(context.read<UserData>().token, widget.id),
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
                    name: "EditPatient".tr(),
                    topLeftAction: BackIcon(
                      overBack: (){
                        if(widget.refreshOnBack == true){
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) =>ListAllPatients())
                          );
                        }else{
                          Navigator.pop(context);
                        }
                      },
                    ),
                    topRightaction: InkWell(
                      onTap: ()async{
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // save data
                          EasyLoading.show(status: "EditPatient".tr());
                          var changeProfileResponse = await _patients.updatePatient(
                              context.read<UserData>().token,
                              email,
                              firstName,
                              lastName,
                              country_code,
                              phoneNumber,
                              gender,
                              birthday,
                              address,
                          );
                          if (await changeProfileResponse.statusCode == 200) {
                            _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){});
                          }else{
                            var error = jsonDecode(await changeProfileResponse.stream.bytesToString());
                            if( error['error']=="715" ){
                              print(error);
                              _dialogs.errorDialog(context, "PhoneNumberAlreadyExists".tr());
                            }else{
                              print(error);
                              _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                            }

                          }
                          EasyLoading.dismiss();
                          setState(() {});
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
                        var imagePicker;
                        imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                        String imageLocation = imagePicker.path.toString();
                        EasyLoading.show(status: "UpdatingPatientImage".tr());
                        var picResponse =await _patients.updatePatientImage(
                          context.read<UserData>().token,
                            snapshot.data['email'],
                            snapshot.data['first_name'],
                            snapshot.data['last_name'],
                            snapshot.data['phone_country_code'],
                            snapshot.data['phone'],
                            snapshot.data['gender'],
                            snapshot.data['birthday'],
                            snapshot.data['address'],
                          imageLocation
                        );
                        if (await picResponse.statusCode == 200) {
                          _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){});
                        }else{
                          print(await picResponse.stream.bytesToString());
                          _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
                        }
                        EasyLoading.dismiss();
                        setState(() {
                        });
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
                                buildEmailFormField(snapshot.data['email']),
                                const SizedBox(height: 20),
                                buildFirstNameFormField(snapshot.data['first_name']),
                                const SizedBox(height: 20),
                                buildLastNameFormField(snapshot.data['last_name']),
                                const SizedBox(height: 20),
                                buildPhoneNumberFormField(snapshot.data['phone'],getCountryCode(snapshot.data['phone_country_code'].toString())),
                                const SizedBox(height: 20),
                                buildGenderFormField(snapshot.data['gender']),
                                const SizedBox(height: 20),
                                buildBirthdayFormField(snapshot.data['birthday']),
                                const SizedBox(height: 20),
                                buildAddressFormField(snapshot.data['address']),
                                const SizedBox(height: 20),
                                const Divider(height: 5,color: Colors.grey,thickness: 0.8,),
                                const SizedBox(height: 20),
                                changePassword(context,snapshot.data['email']),
                                const SizedBox(height: 20),
                                Card(
                                  color:const Color(0xffff5d63),
                                  child: ListTile(
                                    leading: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Image.asset("assets/delete.png"),
                                    ),
                                    title: Text("DeleteAccount".tr(),style: TextStyle(
                                        color: Constants.mainColor,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    trailing: Transform.scale(
                                      scaleX: (context.locale.toString()=="en")?1:-1,
                                      child: SizedBox(
                                        width: 10,
                                        height: 10,
                                        child: Image.asset("assets/right-arrow_gray.png",color: Colors.white,),
                                      ),
                                    ),
                                    onTap: (){
                                      AwesomeDialog(
                                          context: context,
                                          animType: AnimType.SCALE,
                                          dialogType: DialogType.WARNING,
                                          body: Center(child: Text(
                                            "DeleteAccount".tr(),
                                          ),),
                                          btnOkOnPress: () async{
                                            var response = await _patients.deletePatient(context.read<UserData>().token, snapshot.data['email']);
                                            if (await response.statusCode == 200) {
                                              print(await response.stream.bytesToString());
                                              Navigator.pop(context);
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(builder: (context) =>ListAllPatients())
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
      ),
    );
  }

  TextFormField buildEmailFormField(initemail) {
    return TextFormField(
      enabled: false,
      initialValue: initemail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          email = value;
        } else if (Constants.emailValidatorRegExp.hasMatch(value)) {
          email = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kEmailNullError;
        } else if (!Constants.emailValidatorRegExp.hasMatch(value)) {
          return Constants.kInvalidEmailError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Email".tr(),
        // hintText: "Enter_your_email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
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
        labelText: "${"FirstName".tr()}*",
        // hintText: "Enter_your_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildLastNameFormField(lastname) {
    return TextFormField(
      initialValue: lastname,
      onSaved: (newValue) => lastName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          lastName = value;
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
        labelText:"${"LastName".tr()}*",
        // hintText:"Please_Enter_your_lastname",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildAddressFormField(initaddress) {
    return TextFormField(
      initialValue: initaddress,
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          address = value;
        }
        return null;
      },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return LocaleKeys.ThisFieldIsRequired.tr();
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "${"Address".tr()}",
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildBirthdayFormField(initBirthday){
    return TextFormField(
        initialValue: formatedDate(initBirthday),
        keyboardType: TextInputType.phone,
        inputFormatters: [MaskTextInputFormatter(mask: "##/##/####")],
        decoration: InputDecoration(
          hintText: "day/month/year",
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(5.0),
          ),
          labelText:"${"Birthday".tr()}",
          floatingLabelBehavior:
          FloatingLabelBehavior.auto,
        ),
        onSaved: (newValue) {
          final components = newValue!.split("/");
          birthday = "${components[2]}-${components[1]}-${components[0]}";
        } ,
        onChanged: (value) {
          if (value.isNotEmpty) {
            final components = value.split("/");
            if (components.length == 3) {
              final day = int.tryParse(components[0]);
              final month = int.tryParse(components[1]);
              final year = int.tryParse(components[2]);
              if (day != null && month != null && year != null) {
                final date = DateTime(year, month, day);
                if (date.year == year && date.month == month && date.day == day) {
                  final components = value.split("/");
                  birthday = "${components[2]}-${components[1]}-${components[0]}";
                }
              }
            }
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "wrong_date".tr();
          }
          final components = value.split("/");
          if (components.length == 3) {
            final day = int.tryParse(components[0]);
            final month = int.tryParse(components[1]);
            final year = int.tryParse(components[2]);
            if (day != null && month != null && year != null) {
              final date = DateTime(year, month, day);
              if (date.year == year && date.month == month && date.day == day) {
                return null;
              }
            }
          }
          return "wrong_date".tr();
        }
    );
  }

  IntlPhoneField buildPhoneNumberFormField(phone,cCode) {
    return IntlPhoneField(
      initialValue: phone,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        // labelText: "Phone_Number",
        // hintText:"Enter_your_phone_number",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      initialCountryCode: cCode,
      onSaved: (newValue) {
        phoneNumber = newValue!.number;
        country_code = newValue.countryCode;
      } ,
      onChanged: (value) {
        if (value.completeNumber != "") {
          phoneNumber = value.number;
          country_code = value.countryCode;
        }
        return null;
      },
      validator: (value) {
        if (value?.completeNumber=="") {
          return LocaleKeys.ThisFieldIsRequired.tr();
        }
        return null;
      },
    );
  }

  SelectFormField buildGenderFormField(initGender){
    return SelectFormField(
      initialValue: initGender,
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Gender".tr(),
      items:  [
        {
          'value': 'M',
          'label': "Male".tr(),
        },
        {
          'value': 'F',
          'label': "Female".tr().split("*")[0],
        },
      ],
      decoration: InputDecoration(
        suffixIcon: Container(
            padding: EdgeInsets.all(18),
            width: 10,
            height: 10,
            child: Image.asset(
                "assets/dropdown_arrow.png")),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        label: Text("Gender".tr()) ,
        // hintText: "Gender",
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) => gender = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          gender = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return LocaleKeys.ThisFieldIsRequired.tr();
        }
        return null;
      },
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          password = value;
        } else if (value.length >= 8) {
          password = value;
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if (value.length < 8) {
          return Constants.kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "${"NewPassword".tr()}*",
        // hintText: "Enter_your_password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          conform_password = value;
        } else if (value.isNotEmpty && password == conform_password) {
          conform_password = value;
        }
        conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if ((password != value)) {
          return Constants.kMatchPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: "${"ConfirmNewPassword".tr()}*",
        // hintText: "Re_enter_your_password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextField changePassword(context,account){
    return TextField(
      decoration: InputDecoration(
        suffixIcon:const SizedBox(
          width: 10,
          height: 10,
          child: Icon(Icons.arrow_forward_ios),
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText: "ChangePassword".tr(),
        hintStyle: TextStyle(
          color: Colors.black
        ),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor:
            Colors.transparent,
            builder:
                (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(
                        context)
                        .viewInsets
                        .bottom),
                child:
                SingleChildScrollView(
                  child: Form(
                    key: _passwordFormKey,
                    child: Container(
                      padding:
                      const EdgeInsets
                          .all(20),
                      height: MediaQuery.of(
                          context)
                          .size
                          .height *
                          0.4,
                      decoration: const BoxDecoration(
                          color:
                          Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius
                                  .circular(
                                  15),
                              topRight: Radius
                                  .circular(
                                  15))),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                // buildOldPasswordFormField(),
                                // const SizedBox(height: 20),
                                buildPasswordFormField(),
                                const SizedBox(height: 20),
                                buildConformPassFormField(),
                              ],
                            ),
                          ),
                          DefaultButton(
                            loading: _isLoading,
                            text: "Change".tr(),
                            press: () async{
                              if (_passwordFormKey.currentState!.validate()) {
                                _passwordFormKey.currentState!.save();
                                setState(() {
                                  _isLoading = true;
                                });
                                var changeResponse = await _patients.updatePatientPassword(
                                    context.read<UserData>().token,
                                    account,
                                    password
                                );
                                if (await changeResponse.statusCode == 200) {
                                  print(await changeResponse.stream.bytesToString());
                                  _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){
                                    Navigator.pop(context);
                                  });
                                }else{
                                  print(await changeResponse.stream.bytesToString());
                                  _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
