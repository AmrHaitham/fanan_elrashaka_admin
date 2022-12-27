import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/MoneyLog.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/screens/Finance.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import '../providers/UserData.dart';
class EditMoneyLog extends StatefulWidget {
  final id ;
  final date;
  const EditMoneyLog({Key? key,required this.id,required this.date}) : super(key: key);
  @override
  State<EditMoneyLog> createState() => _EditMoneyLogState();
}

class _EditMoneyLogState extends State<EditMoneyLog> {
  final Dialogs _dialogs = Dialogs();

  final _formKey = GlobalKey<FormState>();

  String? name, category_id, amount, log_type, notes, clinic_id;

  MoneyLog _moneyLog = MoneyLog();

  getClinic(){
    List<Map<String,dynamic>> _clinics = [];
    context.read<ClinisData>().clinicsService.forEach((element) {
      _clinics.add({
        'value':element.id.toString(),
        'label':element.name.toString(),
      });
    });
    _clinics.add({
      'value':" ",
      'label':"Not Specified",
    });
    return _clinics;
  }
  getCategory(){
    List<Map<String,dynamic>> _clinics = [];
    context.read<ClinisData>().categoriesModel.forEach((element) {
      _clinics.add({
        'value':element.id.toString(),
        'label':element.name.toString(),
      });
    });
    return _clinics;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>Finance(token: context.read<UserData>().token,))
        );
        return false;
      },
      child: EditScreenContainer(
          name: "EditMoneyLog".tr(),
          topLeftAction: BackIcon(
            overBack: (){
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>Finance(token: context.read<UserData>().token,))
              );
            },
          ),
          topRightaction: InkWell(
            onTap: ()async{
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                EasyLoading.show(status: "EditMoneyLog".tr());
                //token,date,id, name, category_id, amount, log_type, notes, clinic_id
                print("${context.read<UserData>().token},${widget.id.toString()}, $name, $category_id, $amount, $log_type, $notes, $clinic_id");
                var responseData = await _moneyLog.editMoneyLog(
                    context.read<UserData>().token,
                    widget.id.toString(), name, category_id, amount, log_type, notes, clinic_id,widget.date.toString()
                );
                if (await responseData.statusCode == 200) {
                  _dialogs.doneDialog(context,"You_are_successfully_Edit_Money_Log".tr(),"Ok".tr(),(){
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
          child: FutureBuilder(
              future: _moneyLog.getMoneyLog(context.read<UserData>().token,widget.id),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Center(child: CustomLoading()),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // error in data
                    print(snapshot.error.toString());
                    return  Container();
                  } else if (snapshot.hasData) {
                    return Expanded(
                      child: Padding(
                        padding:EdgeInsets.only(top: 30,right: 15,left: 15,),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              const SizedBox(height: 10,),
                              buildLogTypeField(snapshot.data['log_type']),
                              const SizedBox(height: 20,),
                              buildNameFormField(snapshot.data['name']),
                              const SizedBox(height: 20,),
                              buildClinicSelect(snapshot.data['clinic_id'].toString()),
                              const SizedBox(height: 20,),
                              buildCategorySelect(snapshot.data['category_id'].toString()),
                              const SizedBox(height: 20,),
                              buildAmountFormField(snapshot.data['amount'].toString()),
                              const SizedBox(height: 20,),
                              buildNoteFormField(snapshot.data['notes']),
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
                                  title: Text("DeleteMoneyLog".tr(),style: TextStyle(
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
                                          "AreYouSureYouWantToDeleteThisMoneyLog".tr(),
                                        ),),
                                        btnOkOnPress: () async{
                                          var response = await _moneyLog.deleteMoneyLog(context.read<UserData>().token, widget.id);
                                          if (await response.statusCode == 200) {
                                            print(await response.stream.bytesToString());
                                            Navigator.pop(context);
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder: (context) =>Finance(token: context.read<UserData>().token,))
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
      ),
    );
  }

  SelectFormField buildLogTypeField(initData){
    return SelectFormField(
      initialValue: initData,
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "LogType".tr(),
      items:  [
        {
          'value': '1',
          'label': "Expense".tr(),
        },
        {
          'value': '2',
          'label': "Income".tr(),
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
        label: Text("LogType".tr()) ,
        hintText: "LogType".tr(),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) => log_type = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          log_type = value;
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

  TextFormField buildNameFormField(initData) {
    return TextFormField(
      initialValue: initData,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          name = value;
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
        labelText: "${"Name".tr()}*",
        // hintText: "Enter_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  SelectFormField buildClinicSelect(initData){
    return SelectFormField(
      initialValue: initData,
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
        clinic_id= newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          clinic_id = value;
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
  SelectFormField buildCategorySelect(initData){
    return SelectFormField(
      initialValue: initData,
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Category".tr(),
      items: getCategory(),
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
        label: Text("Category".tr()) ,
        hintText:"Category".tr(),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue){
        category_id= newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          category_id = value;
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
  TextFormField buildAmountFormField(initData) {
    return TextFormField(
      initialValue: initData,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Amount".tr(),
        // hintText:"Enter_Amount",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        amount = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          amount = value;
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
  TextFormField buildNoteFormField(initData) {
    return TextFormField(
      initialValue: initData,
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
}
