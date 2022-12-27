import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/PromoCodes.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/ListAllPromoCodes.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
class EditPromoCode extends StatefulWidget {
  final promoCode;

  const EditPromoCode({Key? key, this.promoCode}) : super(key: key);
  @override
  _EditPromoCodeState createState() => _EditPromoCodeState();
}

class _EditPromoCodeState extends State<EditPromoCode> {
  PromoCodes _promoCodes = PromoCodes();

  final Dialogs _dialogs = Dialogs();

  final _formKey = GlobalKey<FormState>();

  String? code , fromDate, toDate, clinic, max_number, fee_after_code;

  DateTime? fromDateI, toDateI ;

  TextEditingController _controller = TextEditingController();

  TextEditingController _controller2 = TextEditingController();

  getClinic(){
    List<Map<String,dynamic>> _clinics = [];
    context.read<ClinisData>().clinicsService.forEach((element) {
      _clinics.add({
        'value':element.id.toString(),
        'label':element.name.toString(),
      });
    });
    return _clinics;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _controller2.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>ListAllPromoCodes())
        );
        return false;
      },
      child: FutureBuilder(
          future: _promoCodes.getPromoCode(context.read<UserData>().token, widget.promoCode),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CustomLoading()));
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // error in data
                print(snapshot.error.toString());
                return  Container();
              } else if (snapshot.hasData) {
                return EditScreenContainer(
                    name: "EditPromoCode".tr(),
                    topLeftAction: BackIcon(
                      overBack: (){
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) =>ListAllPromoCodes())
                        );
                      },
                    ),
                    topRightaction: InkWell(
                      onTap: ()async{
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          EasyLoading.show(status: "EditPromoCode".tr());
                          var responseData = await _promoCodes.updatePromoCode(
                            context.read<UserData>().token,
                            snapshot.data['code'],
                              fromDate,
                              toDate,
                              clinic,
                              max_number??"-1",
                              fee_after_code
                          );
                          if (await responseData.statusCode == 200) {
                            _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){
                              setState(() {
                                _formKey.currentState!.reset();
                                _controller.clear();
                                _controller2.clear();
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
                    child: Expanded(
                      child: Padding(
                        padding:EdgeInsets.only(top: 35,right: 15,left: 15,),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              const SizedBox(height: 10,),
                              buildCodeFormField(snapshot.data['code']),
                              const SizedBox(height: 20,),
                              buildMaxFormField(snapshot.data['max_number']),
                              const SizedBox(height: 20,),
                              buildSelect(snapshot.data['clinic_service_id']),
                              const SizedBox(height: 20,),
                              buildFromDateFormField(context,snapshot.data['from_date']),
                              const SizedBox(height: 20,),
                              buildToDateFormField(context,snapshot.data['to_date']),
                              const SizedBox(height: 20,),
                              buildFeeAfterCodeFormField(snapshot.data['fee_after_code']),
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
                                  title: Text("DeletePromoCode".tr(),style: TextStyle(
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
                                          "AreYouSureYouWantToDeleteThisPromoCode".tr(),
                                        ),),
                                        btnOkOnPress: () async{
                                          var response = await _promoCodes.deletePromoCode(context.read<UserData>().token, snapshot.data['code']);
                                          if (await response.statusCode == 200) {
                                            print(await response.stream.bytesToString());
                                            Navigator.pop(context);
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder: (context) =>ListAllPromoCodes())
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
  TextFormField buildCodeFormField(initData) {
    return TextFormField(
      readOnly: true,
      initialValue: initData,
      onSaved: (newValue) => code = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          code = value;
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
        labelText: "Code".tr(),
        // hintText: "Enter_promo_code",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildMaxFormField(initData) {
    return TextFormField(
      initialValue: initData.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "MaxNumberOfUsers".tr(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        max_number = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          max_number = value;
        }
        return null;
      },
      // validator: (value) {
      //   if (value=="") {
      //     return LocaleKeys.ThisFieldIsRequired.tr();
      //   }
      //   return null;
      // },
    );
  }
  SelectFormField buildSelect(initData){
    return SelectFormField(
      initialValue:initData ,
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Clinic".tr(),
      items: getClinic(),
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
        label: Text("Clinic".tr()) ,
        hintText: "Clinic".tr(),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue){
        clinic= newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          clinic = value;
          print(clinic);
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
  buildFromDateFormField(context,initData){
    if(_controller.text == ""){
      _controller.text = initData;
    }
    return TextFormField(
      // initialValue:initData,
      controller:_controller ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText:"FromDate".tr(),
        label:  Text("FromDate".tr()),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.date(
          // maxDateTime: DateTime.now(),
          title: "FromDate".tr(),
          initialDateTime: fromDateI??DateTime.now(),
          dateOrder: DatePickerDateOrder.dmy,
          pickerTextStyle:const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          titleStyle:const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.blue,
          ),
          onChange: (index) {
            // print(index);
          },
          onSubmit: (index) {
            fromDateI = index;
            fromDate = index!.toString().split(" ")[0];
            _controller.text = fromDate!;
          },
          bottomPickerTheme: BottomPickerTheme.blue,
        ).show(context);
      },
      onSaved: (newValue) => fromDate = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          return null;
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
  buildToDateFormField(context,initData){
    if(_controller2.text == ""){
      _controller2.text = initData;
    }
    return TextFormField(
      controller:_controller2 ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText:"ToDate".tr(),
        label: Text("ToDate".tr()),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.date(
          // maxDateTime: DateTime.now(),
          title: "ToDate".tr(),
          initialDateTime: toDateI??DateTime.now(),
          dateOrder: DatePickerDateOrder.dmy,
          pickerTextStyle:const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          titleStyle:const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.blue,
          ),
          onChange: (index) {
            // print(index);
          },
          onSubmit: (index) {
            toDateI = index;
            toDate = index!.toString().split(" ")[0];
            _controller2.text = toDate!;
          },
          bottomPickerTheme: BottomPickerTheme.blue,
        ).show(context);
      },
      onSaved: (newValue) => toDate = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          return null;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return LocaleKeys.ThisFieldIsRequired.tr() ;
        }
        return null;
      },
    );
  }
  TextFormField buildFeeAfterCodeFormField(initData) {
    return TextFormField(
      initialValue: initData.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "FeeAfterCode".tr(),
        // hintText:"Enter_FeeAfterCode",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        fee_after_code = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          fee_after_code = value;
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
