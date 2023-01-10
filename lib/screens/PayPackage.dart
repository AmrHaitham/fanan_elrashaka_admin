import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/networks/Packages.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/MainScreen.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
class PayPackage extends StatefulWidget {
  final String patient_name , patient_id;
  final bool backToBookings ;

  PayPackage({Key? key,required this.patient_name,required this.patient_id, this.backToBookings = true}) : super(key: key);

  @override
  State<PayPackage> createState() => _PayPackageState();
}

class _PayPackageState extends State<PayPackage> {
  final Dialogs _dialogs = Dialogs();

  // final _formKey1 = GlobalKey<FormState>();

  Packages _packages = Packages();

  String? package_unit , paidAmount ,payment_type , description;

  @override
  Widget build(BuildContext context) {
    print("patient id is ${widget.patient_id}");
    return FutureBuilder(
        future: _packages.getAllPackages(context.read<UserData>().token),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoading());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // error in data
              print(snapshot.error.toString());
              return  Container();
            } else if (snapshot.hasData) {
              List<Map<String,dynamic>> items = [];
              for(var data in snapshot.data){
                items.add({
                  'value': data['id'].toString(),
                  'label': (context.locale.toString()=="en")?data['name_en']:data['name_ar'],
                });
              }
              return EditScreenContainer(
                name: "PackagePurchase".tr(),
                topLeftAction: BackIcon(),
                topRightaction: InkWell(
                  onTap: ()async{
                    // if (_formKey1.currentState!.validate()) {
                    //   _formKey1.currentState!.save();
                    //
                    // }
                    if(package_unit != null && paidAmount != null){
                      EasyLoading.show(status: "PackagePurchase".tr());
                      var responseData = await _packages.buy_new_package(
                          context.read<UserData>().token,
                          widget.patient_id,
                          package_unit,
                          paidAmount,
                          description??""
                      );
                      if (await responseData.statusCode == 200) {
                        print(await responseData.stream.bytesToString());
                        _dialogs.doneDialog(context,"You_are_successfully_Buy_package".tr(),"Ok".tr(),(){
                          if(widget.backToBookings){
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 2,))
                            );
                          }else{
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }

                        });
                      }else{
                        var response = jsonDecode(await responseData.stream.bytesToString());
                        print(response);
                        _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                      }
                      EasyLoading.dismiss();
                    }else{
                      print("Input all fields");
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 25,
                    height: 25,
                    child: Image.asset("assets/Save-512.png"),
                  ),
                ),
                  child: Expanded(
                    child: Padding(
                      // width: double.infinity,
                      // height: MediaQuery.of(context).size.height*0.715,
                      padding: const EdgeInsets.only(right: 15,left: 15),
                      child: ListView(
                          children: [
                            const SizedBox(height: 40),
                            buildNameFormField(widget.patient_name),
                            const SizedBox(height: 20),
                            buildPackageFormField(items),
                            const SizedBox(height: 20),
                            // const SizedBox(height: 20),
                            buildFeeFormField(),
                            const SizedBox(height: 20),
                            buildDescriptionFormField()
                          ],
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

  TextFormField buildNameFormField(initData) {
    return TextFormField(
      readOnly: true,
      initialValue: initData,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "PatientName".tr(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  SelectFormField buildPackageFormField(items){
    return SelectFormField(
      // key: _formKey1,
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Package".tr(),
      items: items,
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
        label: Text("Package".tr()) ,
        hintText: "Package".tr(),
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

  TextFormField buildFeeFormField() {
    return TextFormField(
      // key: _formKey1,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "PaidAmount".tr(),
        // hintText:"Enter_your_Paid Amount",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        paidAmount = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          paidAmount = value;
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

  // SelectFormField buildPayment_typeFormField(){
  TextFormField buildDescriptionFormField() {
    return TextFormField(
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          description = value;
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
        labelText: "Description".tr(),
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
