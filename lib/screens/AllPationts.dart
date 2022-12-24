import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AddPationt.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:fanan_elrashaka_admin/widgets/UserCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ListAllPatients extends StatefulWidget {
  @override
  _ListAllPatientsState createState() => _ListAllPatientsState();
}

class _ListAllPatientsState extends State<ListAllPatients> {
  final Patients _patients = Patients();
  String _searchValue = "";
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      onRefresh: (){
        setState(() {});
      },
      name: "AllPatients".tr(),
      topLeftAction: BackIcon(),
      topRightaction: InkWell(
        onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddPationt())
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
          future:(_searchValue == "")? _patients.getAllPatients(context.read<UserData>().token): _patients.getSearchAllPatients(context.read<UserData>().token,_searchValue),
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
                              isDrPatient: false,
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
