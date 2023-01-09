import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/screens/MainScreen.dart';
import 'package:fanan_elrashaka_admin/screens/NewBookingInfo.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/NewBooking.dart';
import 'package:fanan_elrashaka_admin/screens/PationtProfile.dart';
import 'package:fanan_elrashaka_admin/screens/PayPackage.dart';
import 'package:fanan_elrashaka_admin/screens/PurchasesScreen.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:fanan_elrashaka_admin/widgets/SelectDrPatientCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class ConnectDrPatient extends StatefulWidget {
  final String paitent_id;
  final bool isProfile;
  final selected_day;
  final clinic_id;

  const ConnectDrPatient({Key? key,required this.paitent_id,required this.isProfile,required this.selected_day,required this.clinic_id}) : super(key: key);
  @override
  _ConnectDrPatientState createState() => _ConnectDrPatientState();
}

class _ConnectDrPatientState extends State<ConnectDrPatient> {
  final Patients _patients = Patients();
  String _searchValue = "";
  final TextEditingController search = new TextEditingController();
  PatientDetails _patientDetails = PatientDetails();
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      name: "SelectDoctorPatient".tr(),
      topLeftAction: BackIcon(),
      topCenterAction: SearchList(
        control: search,
        onSubmitted: (value){
          setState(() {
            _searchValue = value;
          });
        },
        onSearchClick: (value){
          setState(() {
            _searchValue = value;
          });
        },
      ),
      child: FutureBuilder(
          future:(_searchValue == "")? _patients.getDrPatients(context.read<UserData>().token): _patients.getSearchDrPatients(context.read<UserData>().token,_searchValue),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                  padding:const EdgeInsets.only(top: 100),
                  child: CustomLoading()
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // error in data
                print(snapshot.error.toString());
                return  Container();
              } else if (snapshot.hasData) {
                print(snapshot.data);
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,index){
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:InkWell(
                              child: SelectDrPatientCard(
                                snapshot: snapshot,
                                index: index,
                              ),
                              onTap: ()async{
                                //token,patient_id,pid
                                EasyLoading.show(status: "ConnectingPatient".tr());
                                var response = await _patientDetails.connectUnKnownPatient(
                                    context.read<UserData>().token,
                                    widget.paitent_id.toString(),
                                    snapshot.data[index]['pid'].toString()
                                );

                                if (await response.statusCode == 200) {
                                  EasyLoading.showSuccess("DoneConnectingPatient".tr());
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 2,clinic_id:widget.clinic_id ,selected_day:widget.selected_day ,))
                                  );
                                  var new_data = jsonDecode(await response.stream.bytesToString());
                                  if(widget.isProfile){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => PationtProfile(pid: new_data['pid'].toString(),))
                                    );
                                  }else{
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => PurchasesScreen(pid:  new_data['pid'].toString(),))
                                    );
                                  }
                                }else{
                                  print(response);
                                  // if(response["error"] == "702"){
                                  // _dialogs.errorDialog(context, "user already exists");}
                                }
                                EasyLoading.dismiss();
                              },
                            )
                        );
                      }
                  ),
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
    );
  }
}
