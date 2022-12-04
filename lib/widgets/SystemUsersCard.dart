import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/screens/EditSystemUser.dart';
import 'package:flutter/material.dart';
class SystemUserCard extends StatelessWidget {
  final snapshot;
  final index;
  const SystemUserCard({Key? key,required this.snapshot,required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditUser(
              id :snapshot.data[index]['email'].toString()
            ))
        );
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
        "${snapshot.data[index]['name']}",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Constants.textColor
        ),
      ),
      subtitle: Text(
        " ${snapshot.data[index]['email']} | ${(snapshot.data[index]['phone']==null)?"":snapshot.data[index]['phone']}",
        style:const TextStyle(
            fontSize: 12,
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
