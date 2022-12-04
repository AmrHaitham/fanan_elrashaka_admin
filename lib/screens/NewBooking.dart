import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/networks/Packages.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
class NewBooking extends StatefulWidget {
  final String patient_name , patient_id;

  NewBooking({Key? key,required this.patient_name,required this.patient_id}) : super(key: key);

  @override
  State<NewBooking> createState() => _NewBookingState();
}

class _NewBookingState extends State<NewBooking> {
  final Dialogs _dialogs = Dialogs();

  // final _formKey1 = GlobalKey<FormState>();

  Bookings _bookings = Bookings();

  String?paidAmount ,payment_type , clinic , booking_time;
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
        name: "New Booking",
        topLeftAction: BackIcon(),
        topRightaction: InkWell(
          onTap: ()async{
            if(paidAmount != null && payment_type != null && clinic != null && booking_time != null){
              EasyLoading.show(status: "Buy Package");
              //token,clinic_time,clinic_service,booking_time,doctor_patient,payment_method,paid_amount
              var responseData = await _bookings.newBooking(
                  context.read<UserData>().token,
                  "?",
                  clinic,
                  booking_time,
                  widget.patient_id,
                  payment_type,
                  paidAmount
              );
              if (await responseData.statusCode == 200) {
                _dialogs.doneDialog(context,"You_are_successfully_Buy_package","ok",(){
                });
              }else{
                var response = jsonDecode(await responseData.stream.bytesToString());
                print(response);
                _dialogs.errorDialog(context, "Error_while_Buying_package_please_check_your_internet_connection");
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
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.715,
          padding: const EdgeInsets.only(right: 15,left: 15),
          child: Column(
              children: [
                const SizedBox(height: 40),
                buildNameFormField(widget.patient_name),
                const SizedBox(height: 20),
                buildSelect(),
                const SizedBox(height: 20),
                buildPaymentType(),
                const SizedBox(height: 20),
                buildFeeFormField(),
                const SizedBox(height: 20),
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
                            labelText: "booking Time",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.35,
                        child: DefaultButton(
                          text: "Get Time",
                          press: ()async{
                            EasyLoading.show(status: "Getting Time");
                            //token,clinic_time,clinic_service,booking_time,doctor_patient,payment_method,paid_amount
                            var responseData = await _bookings.get_next_available_time(
                                context.read<UserData>().token,
                                "?",
                                clinic,
                            );
                            if (await responseData.statusCode == 200) {
                              var response = jsonDecode(await responseData.stream.bytesToString());
                              setState(() {
                                _controller.text = DateFormat("h:mm a").format(DateTime.parse("2020-01-02 ${response['time'].toString()}.000")).toString();
                                booking_time = response['time'].toString();
                              });
                            }else{
                              var response = jsonDecode(await responseData.stream.bytesToString());
                            print(response);
                            _dialogs.errorDialog(context, "Error_while_getting_next_available_time");
                            }
                            EasyLoading.dismiss();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
    );
  }

  TextFormField buildNameFormField(initData) {
    return TextFormField(
      initialValue: initData,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Patient Name*",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  SelectFormField buildSelect(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Clinic Services",
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
        label:const Text("Clinic Services") ,
        hintText: "Clinic Services",
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
  SelectFormField buildPaymentType(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "Payment Type",
      items:const [
        {
          'value':"1",
          'label':"Cash",
        }
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
        label:const Text("Payment Type") ,
        hintText: "Payment Type",
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue){
        payment_type= newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          payment_type = value;
          print(payment_type);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "kAPayment_typeNullError";
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
        labelText: "Paid Amount*",
        hintText:"Enter_your_Paid Amount",
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
          return "kPaidAmountNullError";
        }
        return null;
      },
    );
  }

}
