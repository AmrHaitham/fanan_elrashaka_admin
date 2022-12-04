import 'dart:convert';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Services.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class ListAllServices extends StatefulWidget {
  @override
  _ListAllServicesState createState() => _ListAllServicesState();
}

class _ListAllServicesState extends State<ListAllServices> {
  final Services _services = Services();
  String _searchValue = "";
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  String? new_fee;
  final _formKey = GlobalKey<FormState>();
  final Dialogs _dialogs = Dialogs();
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      name: "Services",
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
          future:(_searchValue == "")? _services.getAllServicesScreen(context.read<UserData>().token): _services.getServicesSearch(context.read<UserData>().token,_searchValue),
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
                var data = snapshot.data;
                print(data);
                return Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context,index){
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:ListTile(
                              trailing: SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset("assets/right-arrow_gray.png"),
                              ),
                              title: Text(data[index]['clinic_en'],style:const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              subtitle: Text("${data[index]['service_en']}  |  ${data[index]['fee'].toString()} EGP"),
                              onTap: (){
                                _bottomSheetWidget.showBottomSheetButtons(
                                    context,
                                    180.0,
                                    const SizedBox(),
                                [
                                  Form(
                                    key: _formKey,
                                    child: buildFeeFormField(data[index]['fee'].toString()),
                                  ),
                                  const SizedBox(height: 20,),
                                  DefaultButton(
                                    text: "Apply",
                                    press: ()async{
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        EasyLoading.show(status: "Update Service Fee");
                                        var responseData = await _services.updateService(
                                          context.read<UserData>().token,data[index]['id'],new_fee
                                        );
                                        if (await responseData.statusCode == 200) {
                                          _dialogs.doneDialog(context,"You_are_successfully_update_service_fee","ok",(){
                                            setState(() {
                                              _formKey.currentState!.reset();
                                            });
                                            Navigator.pop(context);
                                            setState(() {});
                                          });
                                        }else{
                                          var response = jsonDecode(await responseData.stream.bytesToString());
                                      print(response);
                                      _dialogs.errorDialog(context, "Error_while_updating_service_fee_please_check_your_internet_connection");
                                      }
                                      EasyLoading.dismiss();
                                    }
                                    },
                                  )
                                ]
                                );
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
  TextFormField buildFeeFormField(initValue) {
    return TextFormField(
      initialValue: initValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Fee",
        hintText:"Enter_Fee",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        new_fee = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          new_fee = value;
        }
        return null;
      },
      validator: (value) {
        if (value=="") {
          return "kFeeNullError";
        }
        return null;
      },
    );
  }
}
