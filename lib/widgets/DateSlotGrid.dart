import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/TimeSlotItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class DateSlotsGrid extends StatefulWidget {
  final List keys,values;
  final String clinic;
  final String patient_id,payment_type,paidAmount;
  const DateSlotsGrid({Key? key,required this.keys,required this.values,required this.clinic,required this.patient_id,required this.payment_type,required this.paidAmount}) : super(key: key);
  @override
  _DateSlotsGridState createState() => _DateSlotsGridState();
}

class _DateSlotsGridState extends State<DateSlotsGrid> {
  int? selectedIndex;
  void onChange(int index){
    setState(() => selectedIndex = index);
    // context.read<ClinisData>().timeId;
    // context.read<ClinisData>().set_timeId(widget.keys[selectedIndex!].toString());
    // print(context.read<ClinisData>().timeId);
  }
  final Dialogs _dialogs = Dialogs();

  // final _formKey1 = GlobalKey<FormState>();

  Bookings _bookings = Bookings();

  TextEditingController _controller = TextEditingController();
  String? booking_time;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          child:
              Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for(int i=0;i<widget.keys.length;i++)
                        Container(
                          margin: const EdgeInsets.only(top: 20.0,bottom: 20,right: 5),
                          padding: EdgeInsets.all(5),
                          child: TimeSlotItem(Value: widget.values[i].toString(),onChange: ()=> onChange(i), isSelected: selectedIndex == i,),
                        )
                    ],
                  )
              ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width*0.53,
                child: TextFormField(
                  readOnly: true,
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    labelText: "BookingTime".tr(),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width*0.35,
                child: DefaultButton(
                  text: "GetTime".tr(),
                  press: ()async{
                    if( selectedIndex != null) {
                      EasyLoading.show(status: "GetTime".tr());
                      //token,clinic_time,clinic_service,booking_time,doctor_patient,payment_method,paid_amount
                      print("${context
                          .read<UserData>()
                          .token},${context
                          .read<ClinisData>().timeId},${widget.clinic}");
                      var responseData = await _bookings
                          .get_next_available_time(
                        context
                            .read<UserData>()
                            .token,
                        widget.keys[selectedIndex!].toString(),
                        widget.clinic,
                      );
                      if (await responseData.statusCode == 200) {
                        var response = jsonDecode(await responseData.stream
                            .bytesToString());
                        print(response);
                        setState(() {
                          _controller.text = DateFormat("h:mm a",context.locale.toString()).format(
                              DateTime.parse("2020-01-02 ${response['time']
                                  .toString()}.000")).toString();
                          booking_time = response['time'].toString();
                        });
                      } else {
                        var response = jsonDecode(await responseData.stream
                            .bytesToString());
                        print(response);
                        _dialogs.errorDialog(
                            context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                      }
                      EasyLoading.dismiss();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        DefaultButton(
            text: "BookClinic".tr(),
            press: ()async{
              try{
                if( booking_time != null){

                  EasyLoading.show(status: "BookClinic".tr());
                  //token,clinic_time,clinic_service,booking_time,doctor_patient,payment_method,paid_amount
                  var response = await _bookings.newBooking(
                      context.read<UserData>().token,
                      widget.keys[selectedIndex!].toString(),
                      widget.clinic,
                      booking_time,
                      widget.patient_id,
                      widget.payment_type,
                      widget.paidAmount
                  );
                  // print(await response.stream.bytesToString());
                  if (await response.statusCode == 200) {
                    print(await response.body);
                    _dialogs.doneDialog(context,"You_are_successfully_Book".tr(),"Ok".tr(),(){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }else{
                    // var response1 = jsonDecode(await response.stream.bytesToString());
                    print(await response.body);
                    _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                  }
                  EasyLoading.dismiss();
                }else{
                  print("Input all fields");
                }
              }catch(v){
                print(v);
                // EasyLoading.showError("error while booking");
                EasyLoading.dismiss();
              }
            },
        )
      ],
    );
  }
}
