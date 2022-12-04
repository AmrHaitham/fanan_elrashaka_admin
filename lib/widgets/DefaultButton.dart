import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press, this.color, this.loading,
  }) : super(key: key);
  final String? text;
  final Function? press;
  final Color? color;
  final bool?  loading;

  @override
  Widget build(BuildContext context) {
    bool _loading = loading?? false;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: (_loading)?Center(child: CustomLoading(),) :TextButton(
        style: TextButton.styleFrom(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          primary: Colors.white,
          backgroundColor: color??Constants.secondColor,
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style:const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
