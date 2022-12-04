import 'dart:convert';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/models/Clinic.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/networks/Users.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/AddProfilePhoto.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
class AddUser extends StatefulWidget {
  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final Dialogs _dialogs = Dialogs();

  final Users _users = Users();

  final _formKey = GlobalKey<FormState>();

  String? email;

  String? password;

  String? conform_password;

  String? fullName;

  String? phoneNumber;

  String? imageLocation ;

  String? clinics;

  final ImagePicker _picker = ImagePicker();

  static List<Clinic> _clinics = [];

  List<MultiSelectItem<Object?>> _items = [];
  List<dynamic?> _selectedClinics = [];

  bool _switchValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _clinics = context.read<ClinisData>().clinicsName;
    _items = _clinics
        .map((clinic) => MultiSelectItem<Clinic>(clinic, clinic.name!))
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return EditScreenContainer(
        name: "Add User",
        topLeftAction: BackIcon(),
        topRightaction: InkWell(
          onTap: ()async{
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              EasyLoading.show(status: "Adding System User");
              var responseData = await _users.addSystemUser(
                  context.read<UserData>().token,
                  email,
                  fullName,
                  password,
                  phoneNumber,
                  imageLocation??"",
                  clinics??"",
              );
              if (await responseData.statusCode == 200) {
                _dialogs.doneDialog(context,"You_are_successfully_added_new_user","ok",(){
                  setState(() {
                    _formKey.currentState!.reset();
                  });
                });
              }else{
                var response = jsonDecode(await responseData.stream.bytesToString());
                print(response);
                if(response["error"] == "702"){
                  _dialogs.errorDialog(context, "user already exists");
                }else{
                  print(response);
                  _dialogs.errorDialog(context, "Error_while_adding_user_please_check_your_internet_connection");
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
                  buildFirstNameFormField(),
                  const SizedBox(height: 20),
                  buildEmailFormField(),
                  const SizedBox(height: 20),
                  buildPhoneNumberFormField(),
                  const SizedBox(height: 20),
                  buildPasswordFormField(),
                  const SizedBox(height: 20),
                  buildConformPassFormField(),
                  const SizedBox(height: 20),
                  buildMultiSelect(),
                  const SizedBox(height: 10),
                  // buildIsUserActive(),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        )
    );
  }
  buildIsUserActive(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      const Padding(
        padding:  EdgeInsets.all(8.0),
        child:  Text("Is User Active:",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 17,
                fontWeight: FontWeight.bold
           )
        ),
      ),
      CupertinoSwitch(
          trackColor: Colors.grey,
          activeColor: Constants.secondColor,
          value: _switchValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
          },
        ),
      ],
    );
  }
  buildMultiSelect(){
    return MultiSelectBottomSheetField(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      initialChildSize: 0.4,
      listType: MultiSelectListType.CHIP,
      searchable: true,
      buttonText: const Text("Active Clinics",),
      title:const Text("Clinics",style: TextStyle(
          fontSize: 30
      ),),
      items: _items,
      onConfirm: (values){
        _selectedClinics = values;
        String holder = "";
        _selectedClinics.forEach((element) {
          holder +=  element.id;
        });
        clinics = holder.split("").join(",");
        print(clinics);
      },
      selectedItemsTextStyle:const TextStyle(
        color:  Color(0xfff8755ea)
      ),
      cancelText:const Text("Cancel"),
      confirmText:const Text("Select"),
      selectedColor:const Color(0xfffe9dfff) ,
      chipDisplay: MultiSelectChipDisplay(
        chipColor:const Color(0xfffe9dfff),
        textStyle:const TextStyle(
            color: Color(0xfff8755ea)
        ),
        icon:const Icon(Icons.cancel_outlined,color: Color(0xfff8755ea),),
        onTap: (value) {
          setState(() {
            _selectedClinics.remove(value);
            String holder = "";
            _selectedClinics.forEach((element) {
              holder +=  element.id;
            });
            clinics = holder.split("").join(",");
            print(clinics);
          });
        },
      ),
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
      onSaved: (newValue) => fullName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          fullName = value;
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
        labelText: "Full Name*",
        hintText: "Enter_your_full_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Phone_Number",
        hintText:"Enter_your_phone_number",
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
          return "kPhoneNumberNullError";
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