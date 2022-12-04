import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Packages.dart';
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
    return FutureBuilder(
        future:  _packages.getSearchAllPackages(context.read<UserData>().token,widget.id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CustomLoading());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // error in data
              print(snapshot.error.toString());
              return  Container();
            } else if (snapshot.hasData) {
              return EditScreenContainer(
                  name: "Edit Package",
                  topLeftAction: BackIcon(),
                  topRightaction: InkWell(
                    onTap: ()async{
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        EasyLoading.show(status: "Edit Package");
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
                          _dialogs.doneDialog(context,"You_are_successfully_added_new_package","ok",(){
                            setState(() {
                              _formKey.currentState!.reset();
                            });
                          });
                        }else{
                          var response = jsonDecode(await responseData.stream.bytesToString());
                          print(response);
                          _dialogs.errorDialog(context, "Error_while_adding_new_package_please_check_your_internet_connection");
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
                    // demoPhoto: "assets/package_avatar.png",
                    uploadImage: () async{
                      EasyLoading.show(status: "Updating Doctor Patient Image");
                      try{
                        var imagePicker;
                        imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                        String imageLocation = imagePicker.path.toString();
                        var picResponse =await _packages.addPackageCopy(
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
                          _dialogs.doneDialog(context,"You_are_successfully_update_package_picture","ok",(){});
                        }else{
                          print(await picResponse.stream.bytesToString());
                          _dialogs.errorDialog(context,"Error_while_updating_package_picture_data_check_your_interne_connection");
                        }
                        EasyLoading.dismiss();
                        setState(() {});
                      }catch(v){
                        EasyLoading.dismiss();
                        setState(() {});
                      }
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
                            const Divider(height: 5,color: Colors.black,thickness: 0.8,),
                            const SizedBox(height: 10),
                            Card(
                              color:const Color(0xffff5d63),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset("assets/delete.png"),
                                ),
                                title: Text("Delete Package",style: TextStyle(
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
                                      body:const Center(child: Text(
                                        "Are you sure you want to delete this package",
                                      ),),
                                      btnOkOnPress: () async{
                                        var response = await _packages.deletePackage(context.read<UserData>().token, snapshot.data[0]['id']);
                                        if (await response.statusCode == 200) {
                                          print(await response.stream.bytesToString());
                                          Navigator.pop(context);
                                        }
                                      },
                                      btnCancelOnPress: (){},
                                      btnCancelText:"Cancel",
                                      btnOkText:"Delete"
                                  ).show();
                                },
                              ),
                            )
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
          return "kNamelNullError";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "English Name*",
        hintText: "Enter_English_name",
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
          return "kNamelNullError";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Arabic Name*",
        hintText: "Enter_Arabic_name",
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
        labelText: "Old Fee",
        hintText:"Enter_your_phone_number",
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
        labelText: "Fee*",
        hintText:"Enter_your_phone_number",
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
          return "kFeeNullError";
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
      labelText: "Package Type*",
      items: const [
        {
          'value': '1',
          'label': "Days",
        },
        {
          'value': '2',
          'label': "Quantity",
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
        label:const Text("Package Type*") ,
        hintText: "Package Type",
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
          return "kPackageUnitNullError";
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
        labelText: "Package_Amount",
        hintText:"Enter_Package_Amount",
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
          return "kPackageAmountNullError";
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
        labelText: "Order*",
        hintText:"Enter_Order_number",
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
          return "kOrderNullError";
        }
        return null;
      },
    );
  }
}
