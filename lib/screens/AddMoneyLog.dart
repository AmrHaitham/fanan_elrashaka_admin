import 'dart:convert';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/MoneyLog.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/screens/Finance.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import '../providers/UserData.dart';
class AddMoneyLog extends StatefulWidget {
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
    return EditScreenContainer(
        name: "Add Money Log",
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
                EasyLoading.show(status: "Add Money Log");
                var responseData = await _moneyLog.addMoneyLog(
                    context.read<UserData>().token,
                    name, category_id, amount, log_type, notes, clinic_id
                );
                if (await responseData.statusCode == 200) {
                  _dialogs.doneDialog(context,"You_are_successfully_Add_Money_Log","ok",(){
                    setState(() {
                      _formKey.currentState!.reset();
                    });
                  });
                }else{
                  var response = jsonDecode(await responseData.stream.bytesToString());
                  print(response);
                  _dialogs.errorDialog(context, "Error_adding_money_log_please_check_your_internet_connection");
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
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.83,
          padding: const EdgeInsets.only(right: 15,left: 15,top: 25),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
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
    );
  }

  SelectFormField buildLogTypeField(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Log Type*",
      items: const [
        {
          'value': '1',
          'label': "Expense",
        },
        {
          'value': '2',
          'label': "Income",
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
        label:const Text("Log Type*") ,
        hintText: "Log Type",
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
          return "kLogTypeeUnitNullError";
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
          return "kNamelNullError";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Name*",
        hintText: "Enter_name",
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
      labelText: "Clinic*",
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
        label:const Text("clinic") ,
        hintText: "clinic",
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
          return "kAClinicNullError";
        }
        return null;
      },
    );
  }
  SelectFormField buildCategorySelect(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Category*",
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
        label:const Text("Category*") ,
        hintText: "Category",
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
          return "kACategoryNullError";
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
        labelText: "Amount*",
        hintText:"Enter_Amount",
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
          return "kFeeAfterCodeNullError";
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
        labelText: "Notes",
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
