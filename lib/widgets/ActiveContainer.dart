import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ActiveContainer extends StatefulWidget {
  final initValue ;
  final onChange;
  const ActiveContainer({Key? key,required this.initValue,required this.onChange}) : super(key: key);
  @override
  _ActiveContainerState createState() => _ActiveContainerState();
}

class _ActiveContainerState extends State<ActiveContainer> {
  bool? _switchValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding:  EdgeInsets.all(8.0),
          child:  Text("Is User Active:",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        CupertinoSwitch(
          trackColor: Colors.grey,
          activeColor: Constants.secondColor,
          value: _switchValue??widget.initValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
            widget.onChange(value);
          },
        ),
      ],
    );
  }
}
