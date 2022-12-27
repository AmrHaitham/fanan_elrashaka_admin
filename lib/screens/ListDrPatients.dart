import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AddDrPationt.dart';
import 'package:fanan_elrashaka_admin/screens/SelectPatient.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:fanan_elrashaka_admin/widgets/UserCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ListDrPatients extends StatefulWidget {
  @override
  _ListDrPatientsState createState() => _ListDrPatientsState();
}

class _ListDrPatientsState extends State<ListDrPatients> {
  final Patients _patients = Patients();
  String _searchValue = "";
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  final TextEditingController search = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      onRefresh: (){
        setState(() {});
      },
        name: "DoctorPatients".tr(),
        topRightaction: InkWell(
          onTap: (){
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
                        fontSize: 17,
                        fontWeight: FontWeight.normal
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
                        fontSize: 17,
                        fontWeight: FontWeight.normal
                    ),),
                  ),
                ]
            );
          },
          child: Container(
            padding:const EdgeInsets.all(8),
            margin:const EdgeInsets.all(8),
            decoration:  BoxDecoration(
              color: Constants.mainColor,
              borderRadius: BorderRadius.all(Radius.circular(7))
            ),
            width: 35,
            height: 35,
            child: Image.asset("assets/add_patient.png"),
          ),
        ),
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
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:UserCard(
                              isDrPatient: true,
                              snapshot: snapshot,
                              index: index,
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
