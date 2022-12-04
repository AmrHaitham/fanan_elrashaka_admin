import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/NewBooking.dart';
import 'package:fanan_elrashaka_admin/screens/PayPackage.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:fanan_elrashaka_admin/widgets/SelectDrPatientCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SelectDrPatient extends StatefulWidget {
  final bool is_new_booking;

  const SelectDrPatient({Key? key,required this.is_new_booking}) : super(key: key);
  @override
  _SelectDrPatientState createState() => _SelectDrPatientState();
}

class _SelectDrPatientState extends State<SelectDrPatient> {
  final Patients _patients = Patients();
  String _searchValue = "";
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      name: "Select Doctor Patient",
      topLeftAction: BackIcon(),
      topCenterAction: SearchList(
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
                              onTap: (){
                                print("select");
                                if(widget.is_new_booking){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>NewBooking(
                                          patient_name: "${snapshot.data[index]['first_name']} ${snapshot.data[index]['last_name']}",
                                          patient_id: snapshot.data[index]['pid'].toString()
                                      ))
                                  );
                                }else{
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>PayPackage(
                                          patient_name: "${snapshot.data[index]['first_name']} ${snapshot.data[index]['last_name']}",
                                          patient_id: snapshot.data[index]['pid'].toString()
                                      ))
                                  );
                                }
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
