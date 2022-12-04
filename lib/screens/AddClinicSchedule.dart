import 'dart:convert';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Clinics.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:provider/provider.dart';
class AddClinicSchedual extends StatefulWidget {

  @override
  State<AddClinicSchedual> createState() => _AddClinicSchedualState();
}

class _AddClinicSchedualState extends State<AddClinicSchedual> {
  final Dialogs _dialogs = Dialogs();

  final _formKey = GlobalKey<FormState>();

  final Clinics _clinics = Clinics();

  String? clinic , day , fromHour , toHour , fromDate, toDate , finalfromHoure, finaltoHoure;

  TextEditingController _controller = TextEditingController();

  TextEditingController _controller2 = TextEditingController();

  TextEditingController _controller3 = TextEditingController();

  TextEditingController _controller4 = TextEditingController();

  getClinicList(data){
    List<Map<String, dynamic>> items =[];
    data.forEach((element) {
      items.add(
        {
            'value': element.id,
            'label': element.name,
        }
      );
    });
    return items;
  }

  List roundList = [0,5,10,15,20,25,30,35,40,45,50,55,60];

  @override
  Widget build(BuildContext context) {
    return EditScreenContainer(
        name: "Add Clinic Schedule",
        topLeftAction: BackIcon(),
        topRightaction: InkWell(
          onTap: ()async{
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              try{


              EasyLoading.show(status: "Add Clinic Schedule");
              //token,clinic,from_hour,to_hour,repeat_from_date,repeat_to_date,day
              var responseData = await _clinics.addClinicSchedule(
                context.read<UserData>().token,
                clinic,
                finalfromHoure,
                finaltoHoure,
                fromDate,
                toDate,
                day,
              );
              if (await responseData.statusCode == 200) {
                _dialogs.doneDialog(context,"You_are_successfully_added_Clinic_Schedule","ok",(){
                  setState(() {
                    _formKey.currentState!.reset();
                    _controller.clear();
                    _controller2.clear();
                    _controller3.clear();
                    _controller4.clear();
                    clinic  = day  = fromHour  = toHour  = fromDate = toDate = finalfromHoure = finaltoHoure =  fromHour = toHour = null;
                  });
                });
              }else{
                var response = jsonDecode(await responseData.stream.bytesToString());
                print(response);
                _dialogs.errorDialog(context, "Error_while_adding_Clinic_Schedule_please_check_your_internet_connection");
              }
              // print("$clinic, $finalfromHoure, $finaltoHoure, $fromDate , $toDate , $day");
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
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.81,
          padding: const EdgeInsets.only(right: 15,left: 15,top: 40),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildClinicFormField(context.read<ClinisData>().clinicsName),
                  const SizedBox(height: 20),
                  buildDayFormField(),
                  const SizedBox(height: 20),
                  buildFromHoureFormField(),
                  const SizedBox(height: 20),
                  buildToHoureFormField(),
                  const SizedBox(height: 20),
                  buildFromDateFormField(context),
                  const SizedBox(height: 20),
                  buildToDateFormField(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        )
    );
  }

  SelectFormField buildClinicFormField(data){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Clinic*",
      items: getClinicList(data),
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
        label:const Text("Clinic*") ,
        hintText: "Clinic",
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) => clinic = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          clinic = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "kClinicNullError";
        }
        return null;
      },
    );
  }
  SelectFormField buildDayFormField(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Day*",
      items: const [
        {
          'value': 'Sat',
          'label': "Saturday",
        },
        {
          'value': 'Sun',
          'label': "Sunday",
        },
        {
          'value': 'Mon',
          'label': "Monday",
        },
        {
          'value': 'Tue',
          'label': "Tuesday",
        },
        {
          'value': 'Wed',
          'label': "Wednesday",
        },
        {
          'value': 'Thu',
          'label': "Thursday",
        },
        {
          'value': 'Fri',
          'label': "Friday",
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
        label:const Text("Day*") ,
        hintText: "Day",
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) => day = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          day = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "kDayNullError";
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
         hintText:"Repeated From Date*",
         label: const Text("Repeated From Date*"),
         floatingLabelBehavior:
         FloatingLabelBehavior.auto,
       ),
       readOnly: true,
       onTap: () {
         BottomPicker.date(
           // maxDateTime: DateTime.now(),
           title: "Repeated From Date",
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
        hintText:"Repeated To Date*",
        label: const Text("Repeated To Date*"),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.date(
          // maxDateTime: DateTime.now(),
          title: "Repeated To Date",
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
  buildFromHoureFormField(){
    return TextFormField(
      controller:_controller3 ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText:"From Hour*",
        label:const Text("From Hour*"),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.time(
            title:  "From Hour",
            titleStyle: const TextStyle(
                fontWeight:  FontWeight.bold,
                fontSize:  15,
                color:  Colors.blue
            ),
            onSubmit: (index) {
              DateTime rondedtime = DateTime(
                  index.year,index.month,index.day,index.hour,
                  roundList[(index.minute / 5).round()]
              );
              fromHour = DateFormat('jm').format(rondedtime).toString();
              finalfromHoure = DateFormat('Hm').format(rondedtime).toString();
              _controller3.text = fromHour!;
            },
            onClose: () {
              print("Picker closed");
            },
            bottomPickerTheme:  BottomPickerTheme.blue,
            use24hFormat:  false
        ).show(context);
      },
      onSaved: (newValue) => fromHour = newValue,
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
  buildToHoureFormField(){
    return TextFormField(
      controller:_controller4 ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText:"To Hour*",
        label: const Text("To Hour*"),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.time(
            title:  "To Hour",
            titleStyle:const  TextStyle(
                fontWeight:  FontWeight.bold,
                fontSize:  15,
                color:  Colors.blue
            ),
            onSubmit: (index) {
              DateTime rondedtime = DateTime(
                  index.year,index.month,index.day,index.hour,
                  roundList[(index.minute / 5).round()]
              );
              toHour = DateFormat('jm').format(rondedtime).toString();
              finaltoHoure = DateFormat('Hm').format(rondedtime).toString();
              _controller4.text = toHour!;
            },
            onClose: () {
              print("Picker closed");
            },
            bottomPickerTheme:  BottomPickerTheme.blue,
            use24hFormat:  false
        ).show(context);
      },
      onSaved: (newValue) => toHour = newValue,
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
}
