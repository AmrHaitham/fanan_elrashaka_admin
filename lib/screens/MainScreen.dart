import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
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
  final int selectedIndex ;
  final clinic_id;
  final selected_day;

  const MainScreen({Key? key, this.selectedIndex =0, this.clinic_id, this.selected_day}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedScreenIndex  = 0;
  List _screens = [];
  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
      _screens = [
        DashBoard(),
        ListDrPatients(),
        BookingsScreen(),
        MoreScreen()
      ];
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedScreenIndex =widget.selectedIndex;
    _screens = [
      DashBoard(),
      ListDrPatients(),
      BookingsScreen(day: widget.selected_day, initClinic: widget.clinic_id,),
      MoreScreen()
    ];
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
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/dashboard.png",color:(_selectedScreenIndex==0)?Constants.secondColor:Colors.black,)), label: "Dashboard".tr()),
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/patient.png",color:(_selectedScreenIndex==1)?Constants.secondColor:Colors.black,)), label: "Patients".tr()),
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/bookings.png",color:(_selectedScreenIndex==2)?Constants.secondColor:Colors.black,)), label: "Bookings".tr()),
              BottomNavigationBarItem(icon: SizedBox(width:30,height:40,child: Image.asset("assets/more.png",color:(_selectedScreenIndex==3)?Constants.secondColor:Colors.black,)), label: "More".tr())
            ]
          ),
      ),
    );
  }
}
