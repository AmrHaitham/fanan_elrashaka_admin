import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Packages.dart';
import 'package:fanan_elrashaka_admin/screens/ListAllPackages.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/AddProfilePhoto.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ProfilePic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';

import '../providers/UserData.dart';
class EditPackage extends StatefulWidget {
  final id;

  const EditPackage({Key? key,required this.id}) : super(key: key);
  @override
  _EditPackageState createState() => _EditPackageState();
}

class _EditPackageState extends State<EditPackage> {
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
      child: FutureBuilder(
          future:  _packages.getPackage(context.read<UserData>().token,widget.id),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Scaffold(body: Center(child: CustomLoading()));
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // error in data
                print(snapshot.error.toString());
                return  Container();
              } else if (snapshot.hasData) {
                print(snapshot.data);
                return EditScreenContainer(
                    name: "EditPackage".tr(),
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
                          EasyLoading.show(status: "EditPackage".tr());
                          var responseData = await _packages.addPackageCopy(
                            context.read<UserData>().token,
                            snapshot.data[0]['id'],
                            name_ar,
                            name_en,
                            fee,
                            order,
                            old_fee??"",
                            package_amount,
                            package_unit,
                            imageLocation??"",
                          );
                          if (await responseData.statusCode == 200) {
                            _dialogs.doneDialog(context,"You_are_successfully_edit_this_package".tr(),"Ok".tr(),(){
                              setState(() {
                                _formKey.currentState!.reset();
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
                    topCenterAction: ProfilePic(
                      profile: snapshot.data[0]['image'],
                      demoImage: "assets/package_avatar.png",
                      uploadImage: () async{
                        EasyLoading.show(status: "UpdatingPackageImage".tr());
                        try{
                          var imagePicker;
                          imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                          String imageLocation = imagePicker.path.toString();
                          print("$imageLocation");
                          var picResponse =await _packages.updatePackageImage(
                            context.read<UserData>().token,
                            snapshot.data[0]["id"],
                            snapshot.data[0]["name_ar"],
                            snapshot.data[0]["name_en"],
                            snapshot.data[0]["fee"],
                            snapshot.data[0]["order"],
                            snapshot.data[0]["old_fee"],
                            snapshot.data[0]["package_amount"],
                            snapshot.data[0]["package_unit"],
                            imageLocation,
                          );
                          if (await picResponse.statusCode == 200) {
                            print(picResponse.stream.bytesToString());
                            _dialogs.doneDialog(context,"You_are_successfully_updated_information".tr(),"Ok".tr(),(){});
                          }else{
                            print(await picResponse.stream.bytesToString());
                            _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
                          }
                          EasyLoading.dismiss();
                          setState(() {});
                        }catch(v){
                          print("error :- $v");
                          EasyLoading.dismiss();
                          setState(() {});
                        }
                      },
                    ),
                    child: Expanded(
                      child: Padding(
                        padding:EdgeInsets.only(right: 15,left: 15,),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              const SizedBox(height: 5),
                              buildName_enFormField(snapshot.data[0]["name_en"].toString()),
                              const SizedBox(height: 20),
                              buildName_arFormField(snapshot.data[0]["name_ar"].toString()),
                              const SizedBox(height: 20),
                              buildOld_feeFormField((snapshot.data[0]["old_fee"] == null)?"":snapshot.data[0]["old_fee"].toString()),
                              const SizedBox(height: 20),
                              buildFeeFormField(snapshot.data[0]["fee"].toString()),
                              const SizedBox(height: 20),
                              buildTypeFormField(snapshot.data[0]["package_unit"].toString()),
                              const SizedBox(height: 20),
                              buildPackageAmountFormField(snapshot.data[0]["package_amount"].toString()),
                              const SizedBox(height: 20),
                              buildOrderField(snapshot.data[0]["order"].toString()),
                              const SizedBox(height: 20),
                              const Divider(height: 5,color: Colors.grey,thickness: 0.8,),
                              const SizedBox(height: 10),
                              Card(
                                color:const Color(0xffff5d63),
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset("assets/delete.png"),
                                  ),
                                  title: Text("DeletePackage".tr(),style: TextStyle(
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
                                          "Are_you_sure_you_want_to_delete_this_package".tr(),
                                        ),),
                                        btnOkOnPress: () async{
                                          var response = await _packages.deletePackage(context.read<UserData>().token, snapshot.data[0]['id']);
                                          if (await response.statusCode == 200) {
                                            print(await response.stream.bytesToString());
                                            Navigator.pop(context);
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder: (context) =>ListAllPackages())
                                            );
                                          }
                                        },
                                        btnCancelOnPress: (){},
                                        btnCancelText:"Cancel".tr(),
                                        btnOkText:"Delete".tr()
                                    ).show();
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
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
  TextFormField buildName_enFormField(initdata) {
    return TextFormField(
      initialValue: initdata,
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
  TextFormField buildName_arFormField(initdata) {
    return TextFormField(
      initialValue: initdata,
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

  TextFormField buildOld_feeFormField(initdata) {
    return TextFormField(
      initialValue: initdata,
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
    );
  }

  TextFormField buildFeeFormField(initdata) {
    return TextFormField(
      initialValue: initdata,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "${"Fee".tr()}*",
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

  SelectFormField buildTypeFormField(initdata){
    return SelectFormField(
      initialValue: initdata,
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
        suffixIcon: Transform.scale(
          scaleX: (context.locale.toString()=="en")?1:-1,
          child: Container(
              padding: EdgeInsets.all(18),
              width: 10,
              height: 10,
              child: Image.asset(
                  "assets/dropdown_arrow.png")),
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        label:Text("PackageType".tr()) ,
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

  TextFormField buildPackageAmountFormField(initdata) {
    return TextFormField(
      initialValue: initdata,
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
  TextFormField buildOrderField(initdata) {
    return TextFormField(
      initialValue: initdata,
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
