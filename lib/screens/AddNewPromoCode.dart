import 'dart:convert';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/PromoCodes.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import '../providers/UserData.dart';

class AddPromo extends StatefulWidget {
  @override
  _AddPromoState createState() => _AddPromoState();
}

class _AddPromoState extends State<AddPromo> {
  final Dialogs _dialogs = Dialogs();

  final _formKey = GlobalKey<FormState>();

  PromoCodes _promoCodes = PromoCodes();

  String? imageLocation ;

  String? code, fromDate, toDate, clinic_service, max_number, fee_after_code ,clinic;

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return EditScreenContainer(
        name: "Add Promo",
        topLeftAction: BackIcon(),
        topRightaction: InkWell(
          onTap: ()async{
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              EasyLoading.show(status: "Adding Promo");
              //token, code, from_date, to_date, clinic_service, max_number, fee_after_code
              var responseData = await _promoCodes.addPromoCode(
                context.read<UserData>().token,
                code,
                fromDate,
                toDate,
                clinic,
                max_number,
                fee_after_code
              );
              if (await responseData.statusCode == 200) {
                _dialogs.doneDialog(context,"You_are_successfully_added_new_promo_code","ok",(){
                  setState(() {
                    _formKey.currentState!.reset();
                    _controller.clear();
                    _controller2.clear();
                  });
                });
              }else{
                var response = jsonDecode(await responseData.stream.bytesToString());
                print(response);
                _dialogs.errorDialog(context, "Error_while_adding_new_promo_code_please_check_your_internet_connection");
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
          height: MediaQuery.of(context).size.height*0.8,
          padding: const EdgeInsets.only(right: 15,left: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  buildCodeFormField(),
                  const SizedBox(height: 20,),
                  buildMaxFormField(),
                  const SizedBox(height: 20,),
                  buildSelect(),
                  const SizedBox(height: 20,),
                  buildFromDateFormField(context),
                  const SizedBox(height: 20,),
                  buildToDateFormField(context),
                  const SizedBox(height: 20,),
                  buildFeeAfterCodeFormField(),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        )
    );
  }
  TextFormField buildCodeFormField() {
    return TextFormField(
      onSaved: (newValue) => code = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          code = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Code is null";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Code*",
        hintText: "Enter_promo_code",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildMaxFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Max number of users*",
        hintText:"Enter_max_number_of_users",
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
      validator: (value) {
        if (value=="") {
          return "kmax_numberNullError";
        }
        return null;
      },
    );
  }
  SelectFormField buildSelect(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "clinic",
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
          return "kAClinicNullError";
        }
        return null;
      },
    );
  }
  buildFromDateFormField(context){
    return TextFormField(
      controller:_controller ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText:"From Date*",
        label: const Text("From Date*"),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.date(
          // maxDateTime: DateTime.now(),
          title: "From Date",
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
          return "kfromDateNullError" ;
        }
        return null;
      },
    );
  }
  buildToDateFormField(context){
    return TextFormField(
      controller:_controller2 ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText:"To Date*",
        label: const Text("To Date*"),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.date(
          // maxDateTime: DateTime.now(),
          title: "To Date",
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
          return "kToDateNullError" ;
        }
        return null;
      },
    );
  }
  TextFormField buildFeeAfterCodeFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Fee After Code",
        hintText:"Enter_FeeAfterCode",
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
          return "kFeeAfterCodeNullError";
        }
        return null;
      },
    );
  }
  
}
