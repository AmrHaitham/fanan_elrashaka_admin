import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/PationtProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SelectPatientCard extends StatelessWidget {
  final snapshot;
  final index;
  final patient_id;
  const SelectPatientCard({Key? key,required this.snapshot,required this.index, this.patient_id = null}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(snapshot.data[index]);
    return  ListTile(
      onTap: ()async{
        var response;
        var data;
        if(patient_id==null){
          Patients _patients = Patients();
          response = await _patients.connectPatient(context.read<UserData>().token, snapshot.data[index]['id'].toString());
          data = jsonDecode(response.body);
        }else{
          print("Connect unknown patient");
          PatientDetails _patientDetails = PatientDetails();
          response = await _patientDetails.connectUnKnownPatient(context.read<UserData>().token, snapshot.data[index]['id'].toString(),patient_id.toString());
          data = jsonDecode(await response.stream.bytesToString());
          print(data);
        }
        if( response.statusCode == 200){
          if(patient_id!=null){
            Navigator.pop(context);
          }
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PationtProfile(pid: data["pid"].toString()))
          );
        }
      },
      leading: SizedBox(
        width: 50,
        height: 50,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.asset("assets/patient_image.png")
        ),
      ),
      title: Text(
        "${snapshot.data[index]['first_name']} ${snapshot.data[index]['last_name']}",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Constants.textColor
        ),
      ),
      subtitle: Text(
        "${snapshot.data[index]['id']}  |  ${(snapshot.data[index]['phone']==null)?"":"${snapshot.data[index]['phone_country_code']}${snapshot.data[index]['phone']}"+","} ${(snapshot.data[index]['gender']=="M")?"Male".tr():"Female".tr().split("*")[0]}",
        style:const TextStyle(
            fontWeight: FontWeight.bold
        ),
      ),
      trailing: Transform.scale(
        scaleX: (context.locale.toString()=="en")?1:-1,
        child: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset("assets/right-arrow_gray.png"),
        ),
      ),
    );
  }
}
