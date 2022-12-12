import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/screens/EditMoneyLog.dart';
import 'package:flutter/material.dart';
class FinanceCard extends StatelessWidget {
  final snapshot;
  const FinanceCard({Key? key, this.snapshot}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(snapshot);
    return ExpansionTileCard(
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
              fontSize: 20
          ),
        ),
      subtitle: Text(snapshot['category_name'],style: TextStyle(
            color: Constants.secondTextColor
          ),
      ),
      trailing: Text(DateFormat("h:mm a").format(DateTime.parse(snapshot['timestamp'])).toString(),
        style: TextStyle(
            color: Constants.secondTextColor,
            fontSize: 17
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Clinic:   "),
              Text(snapshot['clinic_name_en'].toString())
            ],
          ),
        ),
        if(snapshot['notes'].toString()!="")
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Notes:   "),
              Expanded(child: Text(snapshot['notes'].toString()))
            ],
          ),
        ),
        const Padding(
          padding:  EdgeInsets.only(top: 15.0,bottom: 10),
          child:  Divider(
            height: 4,
            color: Colors.black,
            thickness: 0.2,
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditMoneyLog(id: snapshot['id'].toString()))
                );
              },
              child: Container(
                margin:const EdgeInsets.only(left: 10,right: 10),
                width: 30,
                height: 30,
                child: Image.asset("assets/more_bookings.png"),
              ),
            ),
            Text("${snapshot['amount'].toString().split('.').first} EGP",style: TextStyle(
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
