import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/Packages.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AddPackage.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/PackagesCard.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ListAllPackages extends StatefulWidget {
  @override
  _ListAllPackagesState createState() => _ListAllPackagesState();
}

class _ListAllPackagesState extends State<ListAllPackages> {
  final Packages _packages = Packages();
  String _searchValue = "";
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      name: "Packages",
      topRightaction: InkWell(
        onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddPackage())
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
          child: Image.asset("assets/add_package.png"),
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
          future:(_searchValue == "")? _packages.getAllPackages(context.read<UserData>().token): _packages.getSearchAllPackages(context.read<UserData>().token,_searchValue),
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
                            child:PackagesCard(
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
