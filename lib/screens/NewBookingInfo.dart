import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/networks/Packages.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/NewBooking.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
class NewBookingInfo extends StatefulWidget {
  final String patient_name , patient_id;

  NewBookingInfo({Key? key,required this.patient_name,required this.patient_id}) : super(key: key);

  @override
  State<NewBookingInfo> createState() => _NewBookingInfoState();
}

class _NewBookingInfoState extends State<NewBookingInfo> {

  String? paidAmount ,payment_type , clinic ;
  bool paidAmountFlag = true;

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
    return ScreenContainer(
      name: "NewBooking".tr(),
      topLeftAction: BackIcon(),
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
            Visibility(
                visible: paidAmountFlag,
                child: SizedBox(height: 20)
            ),
            Visibility(
                visible: paidAmountFlag,
                child: buildFeeFormField()
            ),
            const SizedBox(height: 20),
            DefaultButton(
              text: "ChooseDayAndTime".tr(),
              press: (){
                if(clinic != null && payment_type != null && payment_type !=null){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>NewBooking(
                        patient_id: widget.patient_id,
                        clinic: clinic.toString(),
                        paidAmount: paidAmount.toString(),
                        payment_type: payment_type.toString(),
                      ))
                  );
                }
              },
            )
          ],
        ),
      ),
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

  SelectFormField buildSelect(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "ClinicServices".tr(),
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
        label: Text("ClinicServices".tr()) ,
        hintText: "ClinicServices".tr(),
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
  SelectFormField buildPaymentType(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      labelText: "PaymentType".tr(),
      items: [
        {
          'value':"1",
          'label':"CreditCard".tr(),
        },
        {
          'value':"2",
          'label':"Cash".tr(),
        },
        {
          'value':"4",
          'label':"SmartWallet".tr(),
        },
        {
          'value':"5",
          'label':"PaidBefore".tr(),
        },
        {
          'value':"6",
          'label':"BankInstallment".tr(),
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
        label: Text("PaymentType".tr()) ,
        hintText: "PaymentType".tr(),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue){
        setState(() {
          payment_type = newValue;
          if(payment_type == "5"){
            paidAmountFlag = false;
          }else{
            paidAmountFlag = true;
          }
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            payment_type = value;
            if(payment_type == "5"){
              paidAmountFlag = false;
            }else{
              paidAmountFlag = true;
            }
          });
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

}
