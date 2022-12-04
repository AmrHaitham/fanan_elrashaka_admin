import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class EditScreenContainer extends StatelessWidget {
  final  topRightaction;
  final  topCenterAction;
  final  topLeftAction;
  final String name;
  final Widget child;
  const EditScreenContainer({Key? key, this.topRightaction, this.topCenterAction, this.topLeftAction,required this.name,required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width:double.infinity,
          height: 160,
          decoration: BoxDecoration(
              color: Constants.secondColor,
              borderRadius:const BorderRadius.only(bottomRight:Radius.circular(60) ,bottomLeft: Radius.circular(60))
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 55,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: topLeftAction==null?MainAxisAlignment.end:MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: topLeftAction??Container(),
                    ),
                    Expanded(child: Container()),
                    Text(name,style: TextStyle(
                      fontSize: 22,
                      color: Constants.mainColor,
                      fontFamily: "Segoe UI Bold Italic",
                    ),),
                    Expanded(child: Container()),
                    Align(
                      alignment: Alignment.centerRight,
                      child: topRightaction??Container(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.center,
                child: topCenterAction??Container(),
              ),
              const SizedBox(height: 20,),
              child
            ],
          ),
        ),
      ],
    );
  }
}
