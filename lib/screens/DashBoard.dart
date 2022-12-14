import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AddDrPationt.dart';
import 'package:fanan_elrashaka_admin/screens/AddPationt.dart';
import 'package:fanan_elrashaka_admin/screens/LandingPage.dart';
import 'package:fanan_elrashaka_admin/screens/SelectDoctorPatient.dart';
import 'package:fanan_elrashaka_admin/screens/SelectPatient.dart';
import 'package:fanan_elrashaka_admin/widgets/ActoinButton.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/StatisticsCard.dart';
import 'package:fanan_elrashaka_admin/widgets/pieChartState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fanan_elrashaka_admin/networks/DashBoard.dart' as dash;
class DashBoard extends StatelessWidget {
  final dash.DashBoard _dashBoard = dash.DashBoard();
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: ()async{
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LandingPage())
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:const AssetImage("assets/pattern.png"),
              colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.03), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${"Hi".tr()} ${context.read<UserData>().name}",style: TextStyle(
                          fontSize: 22.0,
                          color: Constants.secondColor,
                          fontWeight: FontWeight.normal,
                        ),),
                        Text("HaveANiceDay".tr(),style: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xffacacac),
                            fontWeight: FontWeight.normal
                        ),)
                      ],
                    ),
                    Container(
                        // margin:const EdgeInsets.only(top: 10),
                        width:80,
                        height:80,
                        child: Image.asset("assets/logo.png")
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("QuickActions".tr(),style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xff6a6a6c),
                        fontWeight: FontWeight.bold
                    ),),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionButton(
                              text: "AddPatient".tr(),
                              image: "assets/quick_add_patient.png",
                              onClick: (){
                                _bottomSheetWidget.showBottomSheetButtons(
                                    context,
                                    180.0,
                                    Text("AddNewPatient".tr(),style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    [
                                      ListTile(
                                        onTap: (){
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) =>AddDrPationt())
                                          );
                                        },
                                        dense: true,
                                        leading: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset("assets/add_new_patient.png"),
                                        ),
                                        title:Text("NewPatient".tr(),style: TextStyle(
                                            color: Constants.secondTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                        ),),
                                      ),
                                      const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                                      ListTile(
                                        onTap: (){
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) =>SelectPatient())
                                          );
                                        },
                                        dense: true,
                                        leading: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset("assets/add_existing_patinet.png"),
                                        ),
                                        title:Text("ExistingPatient".tr(),style: TextStyle(
                                            color: Constants.secondTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                        ),),
                                      ),
                                    ]
                                );
                              }
                          ),
                          Expanded(child: Container()),
                          ActionButton(
                              text: "AddPayment".tr(),
                              image: "assets/quick_payment.png",
                              onClick: (){
                              _bottomSheetWidget.showBottomSheetButtons(
                                  context,
                                  180.0,
                                   Text("MakeNewPayment".tr(),style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  [
                                    ListTile(
                                      onTap: (){
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) =>SelectDrPatient(is_new_booking: true,))
                                        );
                                      },
                                      dense: true,
                                      leading: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset("assets/bookings_active.png"),
                                      ),
                                      title:Text("NewBooking".tr(),style: TextStyle(
                                          color: Constants.secondTextColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                                    ListTile(
                                      onTap: (){
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) =>SelectDrPatient(is_new_booking: false,))
                                        );
                                      },
                                      dense: true,
                                      leading: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset("assets/package.png"),
                                      ),
                                      title:Text("PackagePurchase".tr(),style: TextStyle(
                                          color: Constants.secondTextColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                  ]
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                Text("Statistics".tr(),style: TextStyle(
                    fontSize: 22.0,
                    color:Color(0xff6a6a6c),
                    fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 10,),
                FutureBuilder(
                    future: _dashBoard.getDashboardData(context.read<UserData>().token),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CustomLoading());
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          // error in data
                          print(snapshot.error);
                          return  Container();
                        } else if (snapshot.hasData) {
                          print(snapshot.data);
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  StatisticsCard(
                                    color: Constants.statisticsColors[0],
                                    name: "TotalPatients".tr(),
                                    image: "assets/total_patients.png",
                                    value: snapshot.data["total_patients"].toString(),
                                  ),
                                  StatisticsCard(
                                    color: Constants.statisticsColors[1],
                                    name: "MonthPatients".tr(),
                                    image: "assets/total_patients.png",
                                    value: snapshot.data["this_month_patients"].toString(),
                                  ),
                                  StatisticsCard(
                                    color: Constants.statisticsColors[2],
                                    name: "TodayPatients".tr(),
                                    image: "assets/week_patients.png",
                                    value: snapshot.data["today_patients"].toString(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  StatisticsCard(
                                    color: Constants.statisticsColors[3],
                                    name: "TotalBookings".tr(),
                                    image: "assets/booking_monthly.png",
                                    value: snapshot.data["total_bookings"].toString(),
                                  ),
                                  StatisticsCard(
                                    color: Constants.statisticsColors[4],
                                    name: "MonthBookings".tr(),
                                    image: "assets/booking_week.png",
                                    value: snapshot.data["this_month_bookings"].toString(),
                                  ),
                                  StatisticsCard(
                                    color: Constants.statisticsColors[5],
                                    name: "TodayBookings".tr(),
                                    image: "assets/booking_day.png",
                                    value: snapshot.data["today_bookings"].toString(),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: PieChartSample2(
                                  value1: double.parse(snapshot.data["gender_data"][0]['count'].toString()),
                                  value2: double.parse(snapshot.data["gender_data"][1]['count'].toString()),
                                ),
                              )
                            ],
                          );
                        }else{
                          //no data
                          return Container();
                        }
                      }else{
                        //error in connection
                        return Container();
                      }
                    }
                ),

              ],
            ),
          )
        ),
      ),
    );
  }
}
