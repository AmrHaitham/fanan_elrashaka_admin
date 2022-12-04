import 'dart:convert';

import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../networks/ApisEndPoint.dart';
class PatientProfileCard extends StatefulWidget {
  final snapshot;
  PatientProfileCard({Key? key, this.snapshot}) : super(key: key);

  @override
  State<PatientProfileCard> createState() => _PatientProfileCardState();
}

class _PatientProfileCardState extends State<PatientProfileCard> {
  PatientDetails _patientDetails = PatientDetails();

  Dialogs _dialogs = Dialogs();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: (widget.snapshot.data['patient_image']==null)
          ? const CircleAvatar(backgroundImage: AssetImage("assets/user_avatar_male.png"),)
          : SizedBox(
        width: 50,
        height: 100,
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage("${Apis.api}${widget.snapshot.data['patient_image']}")
        ),
      ),
      title: Text('${widget.snapshot.data['name']}',style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.snapshot.data['phone']}",style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Constants.secondTextColor
          ),),
          Text(
            "${widget.snapshot.data['pid']}  |  ${
                (int.parse(DateTime.now().toString().split('-').first) - int.parse(widget.snapshot.data['birthday'].toString().split('-')[0])).toString()
            } Years  |  ${(widget.snapshot.data['gender'].toString()=="M")?"Male":"Female"}",style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Constants.secondTextColor
          ),),
        ],
      ),
      trailing: InkWell(
        onTap: ()async{
          EasyLoading.show(status: "Changing connect status");
          var response = await _patientDetails.updateConnetcStatus(
              context.read<UserData>().token,
              widget.snapshot.data['pid'].toString(),
              widget.snapshot.data['is_connected']?'0':'1'
          );

          if (await response.statusCode == 200) {
            EasyLoading.showSuccess("Done Changing connect status");
            setState(() {});
          }else{
            print(response);
          // if(response["error"] == "702"){
          // _dialogs.errorDialog(context, "user already exists");}
        }
          EasyLoading.dismiss();
        },
        child: Container(
          width: 35,
          height: 35,
          decoration:  BoxDecoration(
              color: (widget.snapshot.data['is_connected']==true)?const Color(0xffe9dfff):const Color(0xffd2d2d2),
              borderRadius:const BorderRadius.all(Radius.circular(7))
          ),
          child: Icon(Icons.link,color: (widget.snapshot.data['is_connected']==true)?Constants.secondColor :const Color(0xffd2d2d2),size: 30,),
        ),
      ),
    );
  }
}
