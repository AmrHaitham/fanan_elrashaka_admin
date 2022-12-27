import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class StatisticsCard extends StatelessWidget {
  final name;
  final value;
  final image;
  final color;
  const StatisticsCard({Key? key, this.name, this.value, this.image, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        width: 100,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: color,
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(name,style: TextStyle(
                color: Constants.mainColor,
                fontSize: 13,
                  fontWeight: FontWeight.bold
              ),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(value,style: TextStyle(
                  color: Constants.mainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 50,
                height: 50,
                child: Image.asset(image,color: Constants.mainColor,)
            ),
          ),
        ],
      ),
    );
  }
}
