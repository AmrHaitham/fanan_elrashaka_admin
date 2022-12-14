import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/actions.dart';
import 'package:fanan_elrashaka_admin/models/CategoriesModel.dart';
import 'package:fanan_elrashaka_admin/models/Clinic.dart';
import 'package:fanan_elrashaka_admin/networks/UserProfile.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/MainScreen.dart';
import 'package:fanan_elrashaka_admin/screens/WelcomeScreen.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/Dialogs.dart';
import '../networks/Categories.dart';
import '../networks/Services.dart';
class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool errorFlag = false;

  final UserProfile _userProfile = UserProfile();
  Services _clinics = Services();
  Categories _categories = Categories();
  Dialogs _dialog = Dialogs();
  getClinicsData()async{
    try{
      var responseClinics = await _clinics.getAllServices(context.read<UserData>().token);
      var respnseCat = await _categories.getAllCategories(context.read<UserData>().token);
      List data = jsonDecode(utf8.decode(responseClinics.bodyBytes));
      List<Clinic> clinicsName = [];
      List<Clinic> clinicsService = [];
      List<CategoriesModel> categoriesModel = [];
      for(var clinic in data){
        Clinic clinicS =Clinic();
        clinicS.id=clinic["id"].toString();
        clinicS.name=(context.locale.toString()=="en")?"${clinic["clinic_en"]} | ${clinic['service_en']}":"${clinic["clinic_ar"]} | ${clinic['service_ar']}";
        clinicsService.add(clinicS);

        if(clinic['service_en']=="New Patient"){
          Clinic clinicModel =Clinic();
          clinicModel.id=clinic["clinic_id"].toString();
          clinicModel.name=(context.locale.toString()=="en")?clinic["clinic_en"]:clinic["clinic_ar"];
          clinicsName.add(clinicModel);
        }
      }
      context.read<ClinisData>().setClinicsName(clinicsName);
      context.read<ClinisData>().setClinicsService(clinicsService);
      data =  respnseCat;
      for(var cat in data){
        CategoriesModel _categoriesModel = CategoriesModel();
        _categoriesModel.id=cat["id"].toString();
        _categoriesModel.name="${cat["name"]}";
        categoriesModel.add(_categoriesModel);
      }
      context.read<ClinisData>().setCategories(categoriesModel);
    }catch(v){
      //context.read<ClinisData>().clinicsName
      print(v);
      // _dialog.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
    }

  }
  saveUserInfo()async{
    try{
      var response =await _userProfile.getUserProfileData(
          context.read<UserData>().email,
          context.read<UserData>().token);
      if(response!=null ){
        print("saveUserInfo response:- ${response}");
        if(response["detail"]=="Invalid token."||response["detail"]=="Not found."){
          _dialog.warningDialog(context, "Pleace_login_again".tr(),(){
            AdminActions.logout(context);
          },
              "Logout".tr()
          );
        }else{
          context.read<UserData>().setUserPhone(response['phone']);
          context.read<UserData>().setUserName(response['name']);
          context.read<UserData>().setUserType(response['groups'][0]);
          context.read<UserData>().setUserName(response['name']);
          context.read<UserData>().setPackage(response['packages']);
          print("name is :- ${context.read<UserData>().name}");
          print("phone is :- ${context.read<UserData>().phone}");
          print("type is :- ${context.read<UserData>().userType}");
        }
      }else{
        // _dialog.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
      }
      errorFlag = false;
    }catch(error){
      errorFlag = true;
      print("network errorss");
    }
  }

  void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('logedIn') ?? false;
    print("log in status is :- ${status}");
    print("user email is :- ${prefs.getString("email")}");
    print("user token is :- ${prefs.getString("token")}");
    if (status) {
      context.read<UserData>().setUserEmail(prefs.getString("email").toString());
      context.read<UserData>().setUserToken(prefs.getString("token").toString());
      try{
        await saveUserInfo();
        await getClinicsData();
        if(!errorFlag){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen())
          );
        }else{
          _dialog.errorReDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr(),
                  (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LandingPage())
                );
                    print("reboot");
              });
        }
      }catch(v){
          print("error network :- ${v}");
          // _dialog.errorReDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr(),
          //         (){
          //       Navigator.of(context).pushReplacement(
          //           MaterialPageRoute(builder: (context) => LandingPage())
          //       );
          //     });
      }
      // finally{
      //
      // }
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => MainScreen())
      // );
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomeScreen())
      );

    }
  }

  // void startTimer() {
  //   Timer(const Duration(milliseconds: 1500), () {
  //     navigateUser();
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // startTimer();
    navigateUser();
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
