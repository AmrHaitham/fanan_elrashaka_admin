import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Services.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
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
  final TextEditingController search = new TextEditingController();
  final Services _services = Services();
  String _searchValue = "";
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  String? new_fee;
  final _formKey = GlobalKey<FormState>();
  final Dialogs _dialogs = Dialogs();
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      onRefresh: (){
        setState(() {});
      },
      name: "Services".tr(),
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
        }, control: search,
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
                                child: Transform.scale(
                                    scaleX: (context.locale.toString()=='en')?1:-1,
                                    child: Image.asset("assets/right-arrow_gray.png")
                                ),
                              ),
                              title: Text(
                                (context.locale.toString()=='en')?data[index]['clinic_en']:data[index]['clinic_ar'],
                                style:const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              subtitle: Text("${(context.locale.toString()=='en')?data[index]['service_en']:data[index]['service_ar']}  |  ${data[index]['fee'].toString()} EGP"),
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
                                    text: "Apply".tr(),
                                    press: ()async{
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        EasyLoading.show(status: "UpdateServiceFee".tr());
                                        var responseData = await _services.updateService(
                                          context.read<UserData>().token,data[index]['id'],new_fee
                                        );
                                        if (await responseData.statusCode == 200) {
                                          _dialogs.doneDialog(context,"You_are_successfully_update_service_fee".tr(),"Ok".tr(),(){
                                            setState(() {
                                              _formKey.currentState!.reset();
                                            });
                                            Navigator.pop(context);
                                            setState(() {});
                                          });
                                        }else{
                                          var response = jsonDecode(await responseData.stream.bytesToString());
                                      print(response);
                                      _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
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
        labelText: "Fee".tr(),
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
          return LocaleKeys.ThisFieldIsRequired.tr();
        }
        return null;
      },
    );
  }
}
