import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/Clinics.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AddClinicSchedule.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/ClinicScahedualCard.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ListAllSchedule extends StatefulWidget {
  @override
  _ListAllScheduleState createState() => _ListAllScheduleState();
}

class _ListAllScheduleState extends State<ListAllSchedule> {
  final Clinics _clinics = Clinics();
  String _searchValue = "";
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      onRefresh: (){
        setState(() {});
      },
      name: "ClinicSchedule".tr(),
      topRightaction: InkWell(
        onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddClinicSchedual())
          );
        },
        child: Container(
          padding:const EdgeInsets.all(8),
          margin:const EdgeInsets.all(8),
          decoration:  BoxDecoration(
              color: Constants.mainColor,
              borderRadius:const BorderRadius.all(Radius.circular(7))
          ),
          width: 35,
          height: 35,
          child: Image.asset("assets/add-event.png"),
        ),
      ),
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
          future:(_searchValue == "")? _clinics.getAllClinicsSchedule(context.read<UserData>().token): _clinics.getSearchClinicSchedule(context.read<UserData>().token,_searchValue),
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
                            child:ClinicCard(
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
