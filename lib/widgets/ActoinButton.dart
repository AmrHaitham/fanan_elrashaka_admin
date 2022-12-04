import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class ActionButton extends StatelessWidget {
  final text;
  final image;
  final onClick;
  const ActionButton({Key? key,required this.text,required this.image,required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Constants.mainColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                width: 35,
                height: 35,
                child: Image.asset(image)
            ),
            Text(text,style: TextStyle(
              fontSize: 15.0,
              color: Constants.secondColor,
              fontWeight: FontWeight.bold,
            ),)
          ],
        ),
      ),
    );
  }
}
