import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class ScreenContainer extends StatelessWidget {
  final  topRightaction;
  final  topCenterAction;
  final  topLeftAction;
  final String name;
  final Widget child;
  final onRefresh;
  const ScreenContainer({Key? key, this.topRightaction, this.topCenterAction, this.topLeftAction,required this.name,required this.child, this.onRefresh}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          onRefresh();
        },
        child: Stack(
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: topRightaction??Container(),
                        ),
                      ],
                    ),
                  ),
                  Text(name,style: TextStyle(
                    fontSize: 22,
                    color: Constants.mainColor,
                    fontFamily: "Segoe UI Bold Italic",
                  ),),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.center,
                    child: topCenterAction??Container(),
                  ),
                  child
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
