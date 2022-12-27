import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:fanan_elrashaka_admin/screens/EditDrPationt.dart';
import 'package:fanan_elrashaka_admin/screens/EditPationt.dart';
import 'package:fanan_elrashaka_admin/screens/PationtProfile.dart';
import 'package:flutter/material.dart';
class UserCard extends StatelessWidget {
  final snapshot;
  final index;
  final isDrPatient;
  const UserCard({Key? key,required this.snapshot,required this.index,required this.isDrPatient}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(snapshot.data[index]);
    return  ListTile(
      onTap: (){
        if(isDrPatient){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PationtProfile(pid: snapshot.data[index]["pid"].toString(),))
          );
        }else{
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditPationt(id: snapshot.data[index]["id"].toString(),refreshOnBack: true,))
          );
        }
      },
      leading: SizedBox(
        width: 50,
        height: 50,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: (snapshot.data[index]['image']==null)
                ? const CircleAvatar(backgroundImage: AssetImage("assets/user_avatar_male.png"),)
                : SizedBox(
              width: 50,
              height: 70,
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage("${Apis.api}${snapshot.data[index]['image']}")
              ),)
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
        "${(isDrPatient)?snapshot.data[index]['pid']:snapshot.data[index]['id']}  |  ${(snapshot.data[index]['phone']=="NoneNone")?"":"${!isDrPatient?(snapshot.data[index]['phone_country_code']==null)?"":snapshot.data[index]['phone_country_code']:""}${(snapshot.data[index]['phone']==null)?"":snapshot.data[index]['phone']}"+","} ${(snapshot.data[index]['gender']=="M")?"Male":"Female"}",
        style:const TextStyle(
            fontWeight: FontWeight.bold
        ),
      ),
      trailing: Transform.scale(
        scaleX: (context.locale.toString() == "en")?1:-1,
        child: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset("assets/right-arrow_gray.png"),
        ),
      ),
    );
  }
}
