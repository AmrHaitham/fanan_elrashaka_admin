import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/Patients.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AddPationt.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:fanan_elrashaka_admin/widgets/SelectPatientCard.dart';
import 'package:fanan_elrashaka_admin/widgets/UserCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SelectPatient extends StatefulWidget {
  final patient_id;

  const SelectPatient({Key? key, this.patient_id = null}) : super(key: key);
  @override
  _SelectPatientState createState() => _SelectPatientState();
}

class _SelectPatientState extends State<SelectPatient> {
  final Patients _patients = Patients();
  String _searchValue = "";
  final TextEditingController search = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      name: "SelectPatient".tr(),
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
                print(snapshot.data);
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,index){
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:SelectPatientCard(
                              snapshot: snapshot,
                              index: index,
                              patient_id: widget.patient_id,
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
