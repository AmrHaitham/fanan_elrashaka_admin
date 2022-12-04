import 'dart:async';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/MainScreen.dart';
import 'package:fanan_elrashaka_admin/screens/WelcomeScreen.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('logedIn') ?? false;
    print("log in status is :- ${status}");
    print("user email is :- ${prefs.getString("email")}");
    print("user token is :- ${prefs.getString("token")}");
    if (status) {
      context.read<UserData>().setUserEmail(prefs.getString("email").toString());
      context.read<UserData>().setUserToken(prefs.getString("token").toString());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen())
      );
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomeScreen())
      );

    }
  }

  void startTimer() {
    Timer(const Duration(milliseconds: 1500), () {
      navigateUser();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: double.infinity,
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
                  alignment: Alignment.topCenter,
                  child: Container(
                      margin:const EdgeInsets.only(top: 35),
                      width:130,
                      height:130,
                      child: Image.asset("assets/logo.png")
                  ),
                ),
                 Align(
                  alignment: Alignment.center,
                  child: CustomLoading()
                ),
              ],
            )
        ),
      ),
    );
  }
}
