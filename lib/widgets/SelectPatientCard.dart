import 'dart:convert';

import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/PationtProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SelectPatientCard extends StatelessWidget {
  final snapshot;
  final index;
  const SelectPatientCard({Key? key,required this.snapshot,required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      onTap: ()async{
        Patients _patients = Patients();
        var response = await _patients.connectPatient(context.read<UserData>().token, snapshot.data[index]['id'].toString());
        var data = jsonDecode(response.body);
        if( response.statusCode == 200){
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
        "${(snapshot.data[index]['phone']==null)?"":snapshot.data[index]['phone']+","} ${(snapshot.data[index]['gender']=="M")?"Male":"Female"}",
        style:const TextStyle(
            fontWeight: FontWeight.bold
        ),
      ),
      trailing: SizedBox(
        width: 20,
        height: 20,
        child: Image.asset("assets/right-arrow_gray.png"),
      ),
    );
  }
}
