import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Packages.dart';
import 'package:fanan_elrashaka_admin/screens/ListAllPackages.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/AddProfilePhoto.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';

import '../providers/UserData.dart';
class AddPackage extends StatefulWidget {
  @override
  _AddPackageState createState() => _AddPackageState();
}

class _AddPackageState extends State<AddPackage> {
  final Dialogs _dialogs = Dialogs();

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  Packages _packages = Packages();

  String? imageLocation ;

  String? name_ar, name_en, fee, order, old_fee, package_amount, package_unit;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>ListAllPackages())
        );
        return false;
      },
      child: EditScreenContainer(
          name: "AddPackage".tr(),
          topLeftAction: BackIcon(
            overBack: (){
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>ListAllPackages())
              );
            },
          ),
          topRightaction: InkWell(
            onTap: ()async{
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                EasyLoading.show(status: "AddPackage".tr());
                var responseData = await _packages.addPackage(
                    context.read<UserData>().token,
                    name_ar,
                    name_en,
                    fee,
                    order,
                    old_fee,
                    package_amount,
                    package_unit,
                    imageLocation??"",
                );
                if (await responseData.statusCode == 200) {
                  _dialogs.doneDialog(context,"You_are_successfully_added_new_package".tr(),"Ok".tr(),(){
                    setState(() {
                      _formKey.currentState!.reset();
                      imageLocation = null;
                    });
                  });
                }else{
                  var response = jsonDecode(await responseData.stream.bytesToString());
                  print(response);
                  _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
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
            demoPhoto: "assets/package_avatar.png",
            getImage: () async{
              var imagePicker;
              imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
              imageLocation = imagePicker.path.toString();
              setState(() {});
            },
          ),
          child: Expanded(
            child: Padding(
              padding:EdgeInsets.only(right: 15,left: 15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    buildName_enFormField(),
                    const SizedBox(height: 20),
                    buildName_arFormField(),
                    const SizedBox(height: 20),
                    buildOld_feeFormField(),
                    const SizedBox(height: 20),
                    buildFeeFormField(),
                    const SizedBox(height: 20),
                    buildTypeFormField(),
                    const SizedBox(height: 20),
                    buildPackageAmountFormField(),
                    const SizedBox(height: 20),
                    buildOrderField(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
  TextFormField buildName_enFormField() {
    return TextFormField(
      onSaved: (newValue) => name_en = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          name_en = value;
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
        labelText: "EnglishName".tr(),
        // hintText: "Enter_English_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildName_arFormField() {
    return TextFormField(
      onSaved: (newValue) => name_ar = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          name_ar = value;
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
        labelText: "ArabicName".tr(),
        // hintText: "Enter_Arabic_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildOld_feeFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "OldFee".tr(),
        // hintText:"Enter_your_phone_number",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        old_fee = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          old_fee = value;
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

  TextFormField buildFeeFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Fee".tr(),
        // hintText:"Enter_Fee*",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        fee = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          fee = value;
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

  SelectFormField buildTypeFormField(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "PackageType".tr(),
      items:  [
        {
          'value': '1',
          'label': "Days".tr(),
        },
        {
          'value': '2',
          'label': "Quantity".tr(),
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
        label: Text("PackageType".tr()) ,
        hintText: "PackageType".tr(),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) => package_unit = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          package_unit = value;
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

  TextFormField buildPackageAmountFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "PackageAmount".tr(),
        // hintText:"Enter_Package_Amount",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        package_amount = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          package_amount = value;
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
  TextFormField buildOrderField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Order".tr(),
        // hintText:"Enter_Order_number",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        order = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          order = value;
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
