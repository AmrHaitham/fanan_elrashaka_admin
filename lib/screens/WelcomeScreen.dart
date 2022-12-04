import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/screens/LoginScreen.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
class WelcomeScreen extends StatefulWidget {

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:const AssetImage("assets/pattern.png"),
              colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.03), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: ()async{
                      if(context.locale.toString()=="en"){
                        context.setLocale(Locale("ar"));
                      }else {
                        context.setLocale(Locale("en"));
                      }
                    },
                    child: Container(
                        margin:const EdgeInsets.all(15),
                        width:30,
                        height:30 ,
                        child: Image.asset((context.locale.toString()=="en")?"assets/Egypt_flag_300.png":"assets/united-kingdom.png")
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin:const EdgeInsets.only(right: 8,top: 35),
                    width:130,
                    height:130,
                    child: Image.asset("assets/logo.png")
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin:const EdgeInsets.only(right: 8,top: 35),
                    width:MediaQuery.of(context).size.width,
                    height:MediaQuery.of(context).size.height*0.6,
                    child: Image.asset("assets/splash_screen.png")
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.06),
                  width: MediaQuery.of(context).size.width*0.8,
                  height: 60,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      primary: Colors.white,
                      backgroundColor: Constants.secondColor,
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    },
                    child: Text(
                      LocaleKeys.Login.tr(),
                      style:Constants.headingText
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
