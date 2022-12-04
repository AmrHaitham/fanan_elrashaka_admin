import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class MoreCard extends StatelessWidget {
  final title , image , onTap;

  const MoreCard({Key? key,required this.title,required this.image,required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(image,color: Constants.secondColor,)
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Constants.textColor
              ),
            ),
            trailing: SizedBox(
              width: 20,
              height: 20,
              child: Image.asset("assets/right-arrow_gray.png",color: Constants.secondColor,),
            ),
          ),
          const Divider(thickness: 0.6,indent: 10,endIndent: 10,)
        ],
      ),
    );
  }
}
