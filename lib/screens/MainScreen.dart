import 'dart:convert';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/actions.dart';
import 'package:fanan_elrashaka_admin/models/CategoriesModel.dart';
import 'package:fanan_elrashaka_admin/models/Clinic.dart';
import 'package:fanan_elrashaka_admin/networks/Categories.dart';
import 'package:fanan_elrashaka_admin/networks/Services.dart';
import 'package:fanan_elrashaka_admin/networks/UserProfile.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/BookingsScreen.dart';
import 'package:fanan_elrashaka_admin/screens/DashBoard.dart';
import 'package:fanan_elrashaka_admin/screens/ListDrPatients.dart';
import 'package:fanan_elrashaka_admin/screens/MoreScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/Dialogs.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedScreenIndex = 0;
  //
  // UserProfile _userProfile = UserProfile();
  // Services _clinics = Services();
  // Categories _categories = Categories();
  // Dialogs _dialog = Dialogs();
  // getClinicsData()async{
  //   try{
  //     var responseClinics = await _clinics.getAllServices(context.read<UserData>().token);
  //     var respnseCat = await _categories.getAllCategories(context.read<UserData>().token);
  //     List data = jsonDecode(utf8.decode(responseClinics.bodyBytes));
  //     List<Clinic> clinicsName = [];
  //     List<Clinic> clinicsService = [];
  //     List<CategoriesModel> categoriesModel = [];
  //     for(var clinic in data){
  //       Clinic clinicS =Clinic();
  //       clinicS.id=clinic["id"].toString();
  //       clinicS.name="${clinic["clinic_en"]} | ${clinic['service_en']}";
  //       clinicsService.add(clinicS);
  //
  //       if(clinic['service_en']=="New Patient"){
  //         Clinic clinicModel =Clinic();
  //         clinicModel.id=clinic["clinic_id"].toString();
  //         clinicModel.name=clinic["clinic_en"];
  //         clinicsName.add(clinicModel);
  //       }
  //     }
  //     context.read<ClinisData>().setClinicsName(clinicsName);
  //     context.read<ClinisData>().setClinicsService(clinicsService);
  //     data =  respnseCat;
  //     for(var cat in data){
  //       CategoriesModel _categoriesModel = CategoriesModel();
  //       _categoriesModel.id=cat["id"].toString();
  //       _categoriesModel.name="${cat["name"]}";
  //       categoriesModel.add(_categoriesModel);
  //     }
  //     context.read<ClinisData>().setCategories(categoriesModel);
  //   }catch(v){
  //     //context.read<ClinisData>().clinicsName
  //     print(v);
  //     _dialog.errorDialog(context, "error while getting data please reload the app or check your internet");
  //   }
  //
  // }
  // saveUserInfo()async{
  //   try{
  //     var response =await _userProfile.getUserProfileData(
  //         context.read<UserData>().email,
  //         context.read<UserData>().token);
  //     if(response!=null ){
  //       if(response["detail"]=="Invalid token."||response["detail"]=="Not found."){
  //         _dialog.warningDialog(context, "Pleace_login_again",(){
  //           AdminActions.logout(context);
  //         },
  //           "Log out"
  //         );
  //       }else{
  //         context.read<UserData>().setUserPhone(response['phone']);
  //         context.read<UserData>().setUserName(response['name']);
  //         print("name is :- ${context.read<UserData>().name}");
  //         print("phone is :- ${context.read<UserData>().phone}");
  //       }
  //     }else{
  //       _dialog.errorDialog(context, "check_our_internet_connection null");
  //     }
  //   }catch(error){
  //     _dialog.errorDialog(context, "check_our_internet_connection");
  //   }
  // }

  final List _screens = [
    DashBoard(),
    ListDrPatients(),
    const BookingsScreen(),
    MoreScreen()
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // saveUserInfo();
    // getClinicsData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        body: _screens[_selectedScreenIndex],
        bottomNavigationBar: BottomNavigationBar(
            enableFeedback: true,
            showUnselectedLabels: false,
            currentIndex: _selectedScreenIndex,
            onTap: _selectScreen,
            selectedItemColor: Constants.secondColor,
            unselectedItemColor: Constants.secondTextColor,
            items: [
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/dashboard.png",color:(_selectedScreenIndex==0)?Constants.secondColor:Colors.black,)), label: "Dashboard"),
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/patient.png",color:(_selectedScreenIndex==1)?Constants.secondColor:Colors.black,)), label: "Patients"),
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/bookings.png",color:(_selectedScreenIndex==2)?Constants.secondColor:Colors.black,)), label: "Bookings"),
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/more.png",color:(_selectedScreenIndex==3)?Constants.secondColor:Colors.black,)), label: "More")
            ],
          ),
      ),
    );
  }
}
