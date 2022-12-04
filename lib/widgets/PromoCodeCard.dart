import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/screens/EditPackage.dart';
import 'package:fanan_elrashaka_admin/screens/EditPromoCode.dart';
import 'package:flutter/material.dart';
class PromoCodeCard extends StatelessWidget {
  final snapshot;
  final index;
  const PromoCodeCard({Key? key,required this.snapshot,required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(snapshot.data[index]);
      return ListTile(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>EditPromoCode(promoCode: snapshot.data[index]['code'].toString() ))
          );
        },
        title: Text(
          "${snapshot.data[index]['code']} | ${snapshot.data[index]['clinic_service_name_en']} (${snapshot.data[index]['clinic_name_en']})",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Constants.textColor
          ),
        ),
        subtitle: Text(
          "${DateFormat('dd/MM/yyyy').format(DateTime.parse(snapshot.data[index]['from_date'].toString()))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(snapshot.data[index]['to_date'].toString()))}  |  ${double.parse(snapshot.data[index]['fee_after_code'].toString()).toInt()} EGP",
          style: const TextStyle(
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
