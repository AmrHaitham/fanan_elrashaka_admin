import 'dart:convert';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/AddProfilePhoto.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
class AddPationt extends StatefulWidget {
  @override
  State<AddPationt> createState() => _AddPationtState();
}

class _AddPationtState extends State<AddPationt> {
  final Dialogs _dialogs = Dialogs();

  final Patients _patients = Patients();

  final _formKey = GlobalKey<FormState>();

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

  String? imageLocation ;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return EditScreenContainer(
        name: "Add Pationt",
        topLeftAction: BackIcon(),
        topRightaction: InkWell(
          onTap: ()async{
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              EasyLoading.show(status: "Adding Patient");
              var changeProfileResponse = await _patients.addPatient(
                context.read<UserData>().token,
                email,
                firstName,
                lastName,
                password,
                country_code,
                phoneNumber,
                gender,
                birthday,
                address??"",
                imageLocation??""
              );
              if (await changeProfileResponse.statusCode == 200) {
                _dialogs.doneDialog(context,"You_are_successfully_added_new_pationt","ok",(){
                  setState(() {
                    _formKey.currentState!.reset();
                    email = null;
                    firstName= null;
                    lastName= null;
                    password= null;
                    country_code= null;
                    phoneNumber= null;
                    gender= null;
                    birthday= null;
                    address= null;
                    imageLocation= null;
                  });
                });
              }else{
                var response = jsonDecode(await changeProfileResponse.stream.bytesToString());
                print(response);
                if(response["error"] == "702"){
                  _dialogs.errorDialog(context, "user already exists");
                }else if(response["error"] == "715"){
                  _dialogs.errorDialog(context, "phone number already exists");
                }else{
                  _dialogs.errorDialog(context, "Error_while_adding_patient_please_check_your_internet_connection");
                }
              }
              EasyLoading.dismiss();
            }
          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            width: 25,
            height: 25,
            child: Image.asset("assets/Save-512.png"),
          ),
        ),
        topCenterAction: AddProfilePhoto(
          profile: imageLocation,
          getImage: () async{
            var imagePicker;
            imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
            imageLocation = imagePicker.path.toString();
            setState(() {});
          },
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.715,
          padding: const EdgeInsets.only(right: 15,left: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildEmailFormField(),
                  const SizedBox(height: 20),
                  buildFirstNameFormField(),
                  const SizedBox(height: 20),
                  buildLastNameFormField(),
                  const SizedBox(height: 20),
                  buildPasswordFormField(),
                  const SizedBox(height: 20),
                  buildConformPassFormField(),
                  const SizedBox(height: 20),
                  buildPhoneNumberFormField(),
                  const SizedBox(height: 20),
                  buildGenderFormField(),
                  const SizedBox(height: 20),
                  buildBirthdayFormField(),
                  const SizedBox(height: 20),
                  buildAddressFormField(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        )
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
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
        labelText: "Email",
        hintText: "Enter_your_email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          firstName = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "kNamelNullError";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Name",
        hintText: "Enter_your_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          lastName = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "kLastNamelNullError";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText:"Last_name",
        hintText:"Please_Enter_your_lastname",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
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
      //     return "kAddressNullError";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Address",
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildBirthdayFormField(){
    return TextFormField(
        keyboardType: TextInputType.phone,
        inputFormatters: [MaskTextInputFormatter(mask: "##/##/####")],
        decoration: InputDecoration(
          hintText: "day/month/year",
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(5.0),
          ),
          labelText:"Birthday",
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
            return "wrong_date";
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
          return "wrong_date";
        }
    );
  }

  IntlPhoneField buildPhoneNumberFormField() {
    return IntlPhoneField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Phone_Number",
        hintText:"Enter_your_phone_number",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      initialCountryCode: "EG",
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
          return "kPhoneNumberNullError";
        }
        return null;
      },
    );
  }

  SelectFormField buildGenderFormField(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Gender",
      items: const [
        {
          'value': 'M',
          'label': "Male",
        },
        {
          'value': 'F',
          'label': "Female",
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
        label:const Text("Gender") ,
        hintText: "Gender",
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
          return "kAGenderNullError";
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
        labelText: "New_Password",
        hintText: "Enter_your_password",
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
        labelText: "Confirm_New_Password",
        hintText: "Re_enter_your_password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }


}
