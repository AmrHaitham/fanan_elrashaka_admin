import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class BackIcon extends StatelessWidget {
  final overBack;
  const BackIcon({Key? key, this.overBack}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: (context.locale.toString()=="en")?-1:1,
      child: InkWell(
        onTap: overBack ??(){
          Navigator.pop(context);
        },
        child: Container(
          padding:const EdgeInsets.all(8),
          margin:const EdgeInsets.all(8),
          decoration:  BoxDecoration(
              color: Constants.mainColor,
              borderRadius: BorderRadius.all(Radius.circular(7))
          ),
          width: 35,
          height: 35,
          child: Image.asset("assets/right-arrow.png"),
        ),
      ),
    );
  }
}
