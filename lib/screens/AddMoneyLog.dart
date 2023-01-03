import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/MoneyLog.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/screens/Finance.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import '../providers/UserData.dart';
class AddMoneyLog extends StatefulWidget {
  final date;

  const AddMoneyLog({Key? key,required this.date}) : super(key: key);
  @override
  State<AddMoneyLog> createState() => _AddMoneyLogState();
}

class _AddMoneyLogState extends State<AddMoneyLog> {
  final Dialogs _dialogs = Dialogs();

  final _formKey = GlobalKey<FormState>();

  String? name, category_id, amount, log_type, notes, clinic_id;

  MoneyLog _moneyLog = MoneyLog();

  getClinic(){
    List<Map<String,dynamic>> _clinics = [];
    context.read<ClinisData>().clinicsName.forEach((element) {
      _clinics.add({
        'value':element.id.toString(),
        'label':element.name.toString(),
      });
    });
    _clinics.add({
      'value':"NotSpecified",
      'label':"NotSpecified".tr(),
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
    print(widget.date);
    return WillPopScope(
        onWillPop: ()async{
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>Finance(token: context.read<UserData>().token,))
          );
          return false;
        },
      child: EditScreenContainer(
          name: "AddMoneyLog".tr(),
          topLeftAction: BackIcon(
            overBack: (){
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Finance(token: context.read<UserData>().token))
              );
            },
          ),
          topRightaction: InkWell(
            onTap: ()async{
              if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  try{
                    EasyLoading.show(status: "AddMoneyLog".tr());
                    var responseData = await _moneyLog.addMoneyLog(
                        context.read<UserData>().token,
                        name, category_id, amount, log_type, notes, clinic_id,widget.date
                    );
                    print(await responseData.stream.bytesToString());
                    if (await responseData.statusCode == 200) {
                      _dialogs.doneDialog(context,"You_are_successfully_Add_Money_Log".tr(),"Ok".tr(),(){
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
                  }catch(v){
                    print(v);
                    EasyLoading.dismiss();
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
          child: Expanded(
            child: Padding(
              padding:EdgeInsets.only(top:25,right: 15,left: 15,),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 10,),
                    buildLogTypeField(),
                    const SizedBox(height: 20,),
                    buildNameFormField(),
                    const SizedBox(height: 20,),
                    buildClinicSelect(),
                    const SizedBox(height: 20,),
                    buildCategorySelect(),
                    const SizedBox(height: 20,),
                    buildAmountFormField(),
                    const SizedBox(height: 20,),
                    buildNoteFormField()
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

  SelectFormField buildLogTypeField(){
    return SelectFormField(
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
        /*hintText: "LogType".tr(),*/
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

  TextFormField buildNameFormField() {
    return TextFormField(
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
        labelText: "Name".tr(),
        // hintText: "Enter_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  SelectFormField buildClinicSelect(){
    return SelectFormField(
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
  SelectFormField buildCategorySelect(){
    return SelectFormField(
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
        hintText: "Category".tr(),
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
  TextFormField buildAmountFormField() {
    return TextFormField(
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
  TextFormField buildNoteFormField() {
    return TextFormField(
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => notes = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          notes = value;
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
        labelText: "Notes".tr(),
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
