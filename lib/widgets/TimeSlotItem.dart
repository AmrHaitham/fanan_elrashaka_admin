import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class TimeSlotItem extends StatelessWidget {
  final String Value;
  final void Function() onChange;
  final bool isSelected;
  const TimeSlotItem({Key? key,required this.Value,required this.onChange,required this.isSelected,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChange,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:(isSelected)?const Color(0xffe9dfff) : const Color(0xffeef1f7),
          border: Border.all(width: 0.08),
        ),
        child: Center(
          child: Text(
              Value,
              style: TextStyle(
                color: (isSelected)?Constants.secondColor :  Colors.black,
                fontWeight: FontWeight.bold
              ),
          ),
        ),
      ),
    );
  }
}
