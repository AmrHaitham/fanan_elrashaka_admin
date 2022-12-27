import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/screens/EditMoneyLog.dart';
import 'package:flutter/material.dart';
class FinanceCard extends StatelessWidget {
  final snapshot;
  final date;
  const FinanceCard({Key? key, this.snapshot,required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(snapshot);
    return ExpansionTileCard(
      initiallyExpanded: true,
      baseColor: Colors.white,
      shadowColor: Colors.grey,
      leading: Container(
        width: 50,
        height: 50,
        padding:const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (snapshot['log_type'].toString()=='1')
              ?const Color(0xffffddde)
              :const Color(0xffb0ffac),
          borderRadius: BorderRadius.circular(15)
        ),
        child:(snapshot['log_type'].toString()=='1')
              ? Image.asset("assets/expense.png")
              : Transform.rotate(
              angle: 3,
              child: Image.asset("assets/expense.png",color: Colors.green,)
        ),
      ),
      title: Text(snapshot['name'],style:
      const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20
      ),
        ),
      subtitle: Text(snapshot['category_name'],style: TextStyle(
            color: Constants.secondTextColor
          ),
      ),
      trailing: Text(DateFormat("h:mm a",context.locale.toString()).format(DateTime.parse(snapshot['timestamp'])).toString(),
        style: TextStyle(
            color: Constants.secondTextColor,
            fontSize: 17,
            fontWeight: FontWeight.bold
        ),
      ),
      children: [
        const Divider(
          height: 4,
          color: Colors.grey,
          thickness: 0.2,
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 19.0),
          child: Row(
            children: [
               Text("${"ClinicName".tr()}:   ",style: TextStyle(
                  color: Color(0xff6a6a6c),
                  fontWeight: FontWeight.bold
              ),),
              Text((context.locale.toString()=='en')?snapshot['clinic_name_en'].toString():snapshot['clinic_name_ar'].toString())
            ],
          ),
        ),
        const SizedBox(height: 3,),
        if(snapshot['notes'].toString()!="")
        Padding(
          padding: const EdgeInsets.only(left: 19.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("${"Notes".tr()}:   ",style: TextStyle(
                  color: Color(0xff6a6a6c),
                  fontWeight: FontWeight.bold
              ),),
              Expanded(child: Text(snapshot['notes'].toString()))
            ],
          ),
        ),
        const Padding(
          padding:  EdgeInsets.only(top: 15.0,bottom: 10),
          child:  Divider(
            height: 4,
            color: Colors.grey,
            thickness: 0.2,
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditMoneyLog(id: snapshot['id'].toString(),date: date,))
                );
              },
              child: Container(
                margin:const EdgeInsets.only(left: 10,right: 10),
                width: 30,
                height: 30,
                child: Image.asset("assets/more_bookings.png"),
              ),
            ),
            Text("${snapshot['amount'].toString().split('.').first} EGP   ",style: TextStyle(
              fontSize: 20,
              color: Constants.secondColor,
              fontWeight: FontWeight.bold
            ),)
          ],
        )
      ],
    );
  }
}
