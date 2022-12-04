import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../Constants.dart';
class MainContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool backIcon;
  final Color patternColor;
  final smallTitle;
  const MainContainer({Key? key,required this.title,required this.child,required this.backIcon,required this.patternColor, this.smallTitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool _smallTitle = smallTitle?? false;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:const AssetImage("assets/pattern.png"),
              colorFilter: ColorFilter.mode(Constants.oldColor.withOpacity(0.97), BlendMode.exclusion),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: backIcon,
                          child: BackIcon()
                        ),
                        Container(
                            margin:(context.locale.toString()=="en")?const EdgeInsets.only(left: 30,top: 20):const EdgeInsets.only(right: 30,top: 20),
                            height:35,
                            child: Text("${title}",style:(_smallTitle)? Constants.smallText:Constants.headingText,)
                        )
                      ],
                    ),
                    Container(
                          margin:(context.locale.toString()=="en")?const EdgeInsets.only(right: 8,top: 5):const EdgeInsets.only(left: 8,top: 5),
                          width:80,
                          height:80,
                          child: Image.asset("assets/logo.png")
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:const BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                    image: DecorationImage(
                      image:const AssetImage("assets/pattern.png"),
                      colorFilter: ColorFilter.mode(patternColor.withOpacity(0.03), BlendMode.dstATop),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
