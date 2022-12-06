import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/models/agenda.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
class AgendaContainer extends StatelessWidget {
  final Agenda agenda;
  AgendaContainer({Key? key,required this.agenda}) : super(key: key);
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTileCard(
        subtitle: Text(DateFormat('jm').format(DateTime.parse(agenda.time!)),),
        baseColor: Colors.white,
        borderRadius: BorderRadius.zero,
        title: Text(
          (agenda.type==1)?"${agenda.name}"
              :(agenda.type==2)?"Water log | ${agenda.amount} L"
              :(agenda.type==3)?"Walking log | ${agenda.amount} Min":""
          ,style: Constants.regularTextNormal,),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(
              (agenda.type==1)?'assets/breakfast.png'
                  :(agenda.type==2)?'assets/water.png'
                  :(agenda.type==3)?'assets/walking (2).png':'assets/walking (2).png'
          ),
        ),
        children: [
          Divider(
            height: 1,
            color: Colors.black,
            thickness: 0.2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0,top: 10,bottom: 10),
            child: Column(
              children: [
                if(agenda.type==1)
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20.0),
                        child: Text("Meal:",
                          // style: Constants.smallTextNormal,
                        ),
                      ),
                      Expanded(child: Text(
                        agenda.mealData!,
                        // style: Constants.smallTextBookScreen,
                      ))
                    ],
                  ),
                if(agenda.type==1)
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20.0),
                        child: Text("Butter:",
                          // style: Constants.smallTextNormal,
                        ),
                      ),
                      Expanded(child: Text("${agenda.amount} gm",
                        // style: Constants.smallTextBookScreen,
                      ))
                    ],
                  ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      child: Text("Note:"
                        // ,style: Constants.smallTextNormal,
                      ),
                    ),
                    Expanded(child: Text("${agenda.note}",
                      // style: Constants.smallTextBookScreen,
                    ))
                  ],
                ),
              ],
            ),
          )
        ],

      ),
    );
  }
}