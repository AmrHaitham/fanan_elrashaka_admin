import 'dart:convert';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/PurchasesCard.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class PurchasesScreen extends StatefulWidget {
  final pid;

  const PurchasesScreen({Key? key,required this.pid}) : super(key: key);
  @override
  _PurchasesScreenState createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  String? date ;
  String? usedAmount;
  TextEditingController? _controller;
  PatientDetails _patientDetails = PatientDetails();
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  Dialogs _dialogs = Dialogs();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _patientDetails.getAllPatientPurchases(context.read<UserData>().token, widget.pid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoading());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // error in data
              print(snapshot.error);
              return  Container();
            } else if (snapshot.hasData) {
              print(snapshot.data);
              return ScreenContainer(
                  name: "Purchases".tr(),
                  topLeftAction:const BackIcon(),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.78,
                    margin:const EdgeInsets.only(top: 25),
                    padding: EdgeInsets.all(5),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return InkWell(
                            child: PurchasesCard(
                              title: (context.locale.toString()=="en")?snapshot.data[index]['name_en'].toString():snapshot.data[index]['name_ar'].toString(),
                              used_amount: snapshot.data[index]['used_amount'].toString(),
                              remaining_amount: snapshot.data[index]['remaining_amount'].toString(),
                              package_unit: snapshot.data[index]['package_unit'].toString(),
                              package_amount: snapshot.data[index]['package_amount'].toString(),
                              date: snapshot.data[index]['purchase_time'].toString(),
                              price: snapshot.data[index]['paid_amount'].toString(),
                            ),
                            onTap: (){
                                if(snapshot.data[index]['package_unit'].toString() == "1"){
                                  print("update end date");
                                  if(snapshot.data[index]['used_amount'].toString() !="null"){
                                    _controller = TextEditingController(text: "${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapshot.data[index]['used_amount']))}");
                                  }else{
                                    _controller = TextEditingController(text: "");
                                  }
                                  _bottomSheetWidget.showBottomSheetButtons(
                                      context, 200.0, const Text(""),
                                      [
                                        buildDateFormField(),
                                        const SizedBox(height: 20,),
                                        DefaultButton(
                                          text: "UpdatePackageEndDate".tr(),
                                          press: ()async{
                                            EasyLoading.show(status: "UpdatePackageEndDate".tr());
                                            var response = await _patientDetails.updatePatientPurchases(
                                                context.read<UserData>().token,
                                                snapshot.data[index]['id'].toString(),
                                                _controller!.text
                                            );
                                            var data = jsonDecode(await response.stream.bytesToString());
                                            if (await response.statusCode == 200) {
                                              print(data);
                                              EasyLoading.showSuccess(LocaleKeys.You_are_successfully_updated_information.tr());
                                              Navigator.pop(context);
                                              setState(() {});
                                            }else{
                                              print(data);
                                              if(response["error"] == "721"){
                                                _dialogs.errorDialog(context, LocaleKeys.PatientIsNotConnected.tr());
                                              }
                                            }
                                            EasyLoading.dismiss();
                                          },
                                        )
                                      ]
                                  );
                                }else if(snapshot.data[index]['package_unit'].toString() == "2"){
                                  print("update used amount");
                                  _bottomSheetWidget.showBottomSheetButtons(
                                      context, 200.0, const Text(""),
                                      [
                                        buildMaxFormField(snapshot.data[index]['used_amount'].toString(),snapshot.data[index]['package_amount'].toString()),
                                        const SizedBox(height: 20,),
                                        DefaultButton(
                                          text: "UpdateUsedAmount".tr(),
                                          press: ()async{
                                            try{
                                              if(int.parse(usedAmount.toString()) <= snapshot.data[index]['package_amount']){
                                                EasyLoading.show(status: "UpdateUsedAmount".tr());
                                                var response = await _patientDetails.updatePatientPurchases(
                                                    context.read<UserData>().token,
                                                    snapshot.data[index]['id'].toString(),
                                                    usedAmount
                                                );
                                                var data = jsonDecode(await response.stream.bytesToString());
                                                if (await response.statusCode == 200) {
                                                  print(data);
                                                  EasyLoading.showSuccess(LocaleKeys.You_are_successfully_updated_information.tr());
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                }else{
                                                  print(data);
                                                  if(response["error"] == "721"){
                                                    _dialogs.errorDialog(context, LocaleKeys.PatientIsNotConnected.tr());
                                                  }
                                                }
                                                EasyLoading.dismiss();
                                              }
                                            }catch(e){
                                              print(e);
                                            }

                                          },
                                        )
                                      ]
                                  );
                                }
                            },
                          );
                        }
                    ),
                  )
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
    );
  }

  buildDateFormField(){
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.date(
          title: "UpdatePackageEndDate".tr(),
          dateOrder: DatePickerDateOrder.dmy,
          pickerTextStyle:const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          titleStyle:const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.blue,
          ),
          onChange: (index) {
            // print(index);
          },
          onSubmit: (index) {
            date = index!.toString().split(" ")[0];
            _controller!.text = date!;
          },
          bottomPickerTheme: BottomPickerTheme.blue,
        ).show(context);
      },
      onSaved: (newValue) => date = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          return null;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return LocaleKeys.ThisFieldIsRequired.tr() ;
        }
        return null;
      },
    );
  }
  TextFormField buildMaxFormField(initData,maxUse) {
    return TextFormField(
      initialValue: initData,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        suffixText: "${"From".tr()} ${maxUse}",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        usedAmount = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          usedAmount = value;
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
