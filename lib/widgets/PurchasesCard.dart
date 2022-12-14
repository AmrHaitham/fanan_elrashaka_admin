import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class PurchasesCard extends StatelessWidget {
  final String title;
  final String price;
  final String date;
  final String package_unit;
  final String used_amount;
  final String package_amount;
  final String remaining_amount;
  const PurchasesCard({Key? key,required this.title,required this.price,required this.date,required this.package_unit,required this.used_amount,required this.package_amount,required this.remaining_amount}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(10),
      margin:const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:const Color(0xfffaf9ff),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        border: Border.all(color: Colors.grey,width: 0.09)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff000000)
              )),
              Text("${double.parse(price).toInt()} ${"EGP".tr()}",style: Constants.PriceSmallText,),
            ],
          ),
          SizedBox(height: 15,),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("PurchaseDate".tr(),style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff6a6a6c)
                    ),),
                    SizedBox(height: 6,),
                    Text("${DateFormat("EEEE dd/MM/yyyy",context.locale.toString()).format(DateTime.parse(date))}",style: Constants.secondSmallText,)
                  ],
                ),
                VerticalDivider(color: Colors.black,thickness: 0.8,),
                if(package_unit == "1")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("EndDate".tr(),style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6a6a6c)
                      ),),
                      SizedBox(height: 6,),
                      if(used_amount!="null")
                      Text("${DateFormat("EEEE dd/MM/yyyy",context.locale.toString()).format(DateTime.parse(used_amount))}",style: Constants.secondSmallText,)
                    ],
                  ),
                if(package_unit == "2")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("UsedAmount".tr(),style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6a6a6c)
                      )),
                      SizedBox(height: 6,),
                      Text("${used_amount}/${package_amount} [${int.parse(package_amount)-int.parse(used_amount)} ${"Remaining".tr()}]",style: Constants.secondSmallText,)
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
