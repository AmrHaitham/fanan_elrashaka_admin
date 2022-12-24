import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/networks/Packages.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/DateSlotGrid.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
class NewBooking extends StatefulWidget {
  final String  patient_id , clinic , payment_type, paidAmount;

  NewBooking({Key? key,required this.patient_id,required this.clinic,required this.payment_type,required this.paidAmount}) : super(key: key);

  @override
  State<NewBooking> createState() => _NewBookingState();
}

class _NewBookingState extends State<NewBooking> {
  final Dialogs _dialogs = Dialogs();

  // final _formKey1 = GlobalKey<FormState>();

  Bookings _bookings = Bookings();

  String? booking_time;
  TextEditingController _controller = TextEditingController();

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
  Widget build(BuildContext context) {
    return EditScreenContainer(
        name: "NewBooking".tr(),
        topLeftAction: BackIcon(),
        // topRightaction: InkWell(
        //   onTap: ()async{
        //     if( booking_time != null){
        //       EasyLoading.show(status: "Buy Package");
        //       //token,clinic_time,clinic_service,booking_time,doctor_patient,payment_method,paid_amount
        //       var responseData = await _bookings.newBooking(
        //           context.read<UserData>().token,
        //           "?",
        //           widget.clinic,
        //           booking_time,
        //           widget.patient_id,
        //           widget.payment_type,
        //           widget.paidAmount
        //       );
        //       if (await responseData.statusCode == 200) {
        //         _dialogs.doneDialog(context,"You_are_successfully_Buy_package","ok",(){
        //         });
        //       }else{
        //         var response = jsonDecode(await responseData.stream.bytesToString());
        //         print(response);
        //         _dialogs.errorDialog(context, "Error_while_Buying_package_please_check_your_internet_connection");
        //       }
        //       EasyLoading.dismiss();
        //     }else{
        //       print("Input all fields");
        //     }
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(right: 10),
        //     width: 25,
        //     height: 25,
        //     child: Image.asset("assets/Save-512.png"),
        //   ),
        // ),
        child: FutureBuilder(
            future: _bookings.get_clinic_calendar(context.read<UserData>().token,widget.clinic),
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
                  // print(snapshot.data);
                  List values = [];
                  List keys = [];
                  for(var row in snapshot.data){
                    print(row);
                    keys.add(row['id'].toString());
                    values.add(row['date'].toString());
                  }
                  return Expanded(
                    // width: double.infinity,
                    // height: MediaQuery.of(context).size.height*0.715,
                    // padding: const EdgeInsets.only(right: 15,left: 15),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,right: 15,left: 15),
                      child: ListView(
                        children: [
                          const SizedBox(height: 20),
                          DateSlotsGrid(
                            keys: keys,
                            values: values,
                            clinic: widget.clinic,
                            payment_type: widget.payment_type,
                            paidAmount: widget.paidAmount,
                            patient_id: widget.patient_id,
                          ),
                        ],
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

    );
  }


}
