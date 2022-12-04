import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/Users.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AddSystemUser.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:fanan_elrashaka_admin/widgets/SystemUsersCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ListAllUsers extends StatefulWidget {
  @override
  _ListAllUsersState createState() => _ListAllUsersState();
}

class _ListAllUsersState extends State<ListAllUsers> {
  final Users _users = Users();
  String _searchValue = "";
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      name: "All Users",
      topLeftAction: BackIcon(),
      topRightaction: InkWell(
        onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>AddUser())
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
          future:(_searchValue == "")? _users.getAllUsers(context.read<UserData>().token): _users.getSearchAllUsers(context.read<UserData>().token,_searchValue),
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
                            child:SystemUserCard(
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
