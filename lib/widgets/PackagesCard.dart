import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/screens/EditPackage.dart';
import 'package:flutter/material.dart';
class PackagesCard extends StatelessWidget {
  final snapshot;
  final index;
  const PackagesCard({Key? key,required this.snapshot,required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(snapshot.data[index]['id'].toString() != "8") {
      return ListTile(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>EditPackage(id: snapshot.data[index]['id'].toString() ))
          );
        },
        leading: SizedBox(
          width: 50,
          height: 50,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset("assets/package_avatar.png")
          ),
        ),
        title: Text(
          "${(context.locale.toString()=='en')?snapshot.data[index]['name_en']:snapshot.data[index]['name_ar']}",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Constants.textColor
          ),
        ),
        subtitle: Row(
          children: [
            if(snapshot.data[index]['old_fee'] != null)
              Text(
                "${snapshot.data[index]['old_fee']}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough
                ),
              ),
            Text(
              "  ${snapshot.data[index]['fee']}",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 20,
          height: 20,
          child: Transform.scale(
              scaleX: (context.locale.toString()=="en")?1:-1,
              child: Image.asset("assets/right-arrow_gray.png")
          ),
        ),
      );
    }else{
      return Container();
    }
  }
}
