import 'dart:convert';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/networks/Packages.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/DateSlotGrid.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:drop_down_list/drop_down_list.dart';
class NewBooking extends StatefulWidget {
  final String  patient_id , clinic , payment_type, paidAmount;

  NewBooking({Key? key,required this.patient_id,required this.clinic,required this.payment_type,required this.paidAmount}) : super(key: key);

  @override
  State<NewBooking> createState() => _NewBookingState();
}

class _NewBookingState extends State<NewBooking> {
  final Dialogs _dialogs = Dialogs();

  // final _formKey1 = GlobalKey<FormState>();

  Bookings _bookings = Bookings();

  String? booking_time;
  TextEditingController _controllerDay = TextEditingController();
  TextEditingController _controller = TextEditingController();
  String? selectedDate;
  getClinic(){
    List<Map<String,dynamic>> _clinics = [];
    context.read<ClinisData>().clinicsService.forEach((element) {
      _clinics.add({
        'value':element.id.toString(),
        'label':element.name.toString(),
      });
    });
    return _clinics;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        name: "NewBooking".tr(),
        topLeftAction: BackIcon(),
        // topRightaction: InkWell(
        //   onTap: ()async{
        //     if( booking_time != null){
        //       EasyLoading.show(status: "Buy Package");
        //       //token,clinic_time,clinic_service,booking_time,doctor_patient,payment_method,paid_amount
        //       var responseData = await _bookings.newBooking(
        //           context.read<UserData>().token,
        //           "?",
        //           widget.clinic,
        //           booking_time,
        //           widget.patient_id,
        //           widget.payment_type,
        //           widget.paidAmount
        //       );
        //       if (await responseData.statusCode == 200) {
        //         _dialogs.doneDialog(context,"You_are_successfully_Buy_package","ok",(){
        //         });
        //       }else{
        //         var response = jsonDecode(await responseData.stream.bytesToString());
        //         print(response);
        //         _dialogs.errorDialog(context, "Error_while_Buying_package_please_check_your_internet_connection");
        //       }
        //       EasyLoading.dismiss();
        //     }else{
        //       print("Input all fields");
        //     }
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(right: 10),
        //     width: 25,
        //     height: 25,
        //     child: Image.asset("assets/Save-512.png"),
        //   ),
        // ),
        child: FutureBuilder(
            future: _bookings.get_clinic_calendar(context.read<UserData>().token,widget.clinic),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(child: CustomLoading()),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // error in data
                  print(snapshot.error.toString());
                  return  Container();
                } else if (snapshot.hasData) {
                  // print(snapshot.data);
                  // List values = [];
                  // List keys = [];
                  List<SelectedListItem> _selectedItems =[];
                  for(var row in snapshot.data){
                    print(row);
                    // keys.add(row['id'].toString());
                    // values.add(row['date'].toString());
                    _selectedItems.add(SelectedListItem(
                      name: row['date'].toString(),
                      value: row['id'].toString(),
                      isSelected: false,
                    ));
                  }
                  return Expanded(
                    // width: double.infinity,
                    // height: MediaQuery.of(context).size.height*0.715,
                    // padding: const EdgeInsets.only(right: 15,left: 15),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,right: 15,left: 15),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // DateSlotsGrid(
                          //   keys: keys,
                          //   values: values,
                          //   clinic: widget.clinic,
                          //   payment_type: widget.payment_type,
                          //   paidAmount: widget.paidAmount,
                          //   patient_id: widget.patient_id,
                          // ),
                          buildSelectDay(_selectedItems),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width*0.53,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      labelText: "BookingTime".tr(),
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width*0.35,
                                  child: DefaultButton(
                                    text: "GetTime".tr(),
                                    press: ()async{
                                      if( selectedDate != null) {
                                        EasyLoading.show(status: "GetTime".tr());
                                        //token,clinic_time,clinic_service,booking_time,doctor_patient,payment_method,paid_amount
                                        print("${context
                                            .read<UserData>()
                                            .token},${context
                                            .read<ClinisData>().timeId},${widget.clinic}");
                                        var responseData = await _bookings
                                            .get_next_available_time(
                                          context
                                              .read<UserData>()
                                              .token,
                                          selectedDate.toString(),
                                          widget.clinic,
                                        );
                                        if (await responseData.statusCode == 200) {
                                          var response = jsonDecode(await responseData.stream
                                              .bytesToString());
                                          print(response);
                                          setState(() {
                                            _controller.text = DateFormat("h:mm a",context.locale.toString()).format(
                                                DateTime.parse("2020-01-02 ${response['time']
                                                    .toString()}.000")).toString();
                                            booking_time = response['time'].toString();
                                          });
                                        } else {
                                          var response = jsonDecode(await responseData.stream
                                              .bytesToString());
                                          print(response);
                                          _dialogs.errorDialog(
                                              context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                                        }
                                        EasyLoading.dismiss();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          DefaultButton(
                            text: "BookClinic".tr(),
                            press: ()async{
                              try{
                                if( booking_time != null){

                                  EasyLoading.show(status: "BookClinic".tr());
                                  //token,clinic_time,clinic_service,booking_time,doctor_patient,payment_method,paid_amount
                                  var response = await _bookings.newBooking(
                                      context.read<UserData>().token,
                                      selectedDate.toString(),
                                      widget.clinic,
                                      booking_time,
                                      widget.patient_id,
                                      widget.payment_type,
                                      widget.paidAmount
                                  );
                                  // print(await response.stream.bytesToString());
                                  if (await response.statusCode == 200) {
                                    print(await response.body);
                                    _dialogs.doneDialog(context,"You_are_successfully_Book".tr(),"Ok".tr(),(){
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  }else{
                                    // var response1 = jsonDecode(await response.stream.bytesToString());
                                    print(await response.body);
                                    _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
                                  }
                                  EasyLoading.dismiss();
                                }else{
                                  print("Input all fields");
                                }
                              }catch(v){
                                print(v);
                                // EasyLoading.showError("error while booking");
                                EasyLoading.dismiss();
                              }
                            },
                          )
                        ],
                      ),
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

buildSelectDay(data){
  return  TextFormField(
    controller:_controllerDay ,
    decoration: InputDecoration(
      hoverColor: Constants.secondColor,
      fillColor: Constants.secondColor,
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),
      ),
      hintText:"SelectDay".tr(),
      label:  Text("SelectDay".tr()),
      floatingLabelBehavior:
      FloatingLabelBehavior.auto,
    ),
    readOnly: true,
    onTap: (){
      DropDownState(
        DropDown(
          // searchWidget: TextFormField(decoration: InputDecoration(
          //     hoverColor: Constants.secondColor,
          //     fillColor: Constants.secondColor,
          //     contentPadding: EdgeInsets.all(8),
          //     border: OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.circular(10),
          //     ),
          //     label: Text(LocaleKeys.Search.tr())
          // ),),
          isSearchVisible: false,
          bottomSheetTitle:  Text(
            "Select".tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          submitButtonChild:  Text(
            'Done'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          data: data?? [],
          selectedItems: (List<dynamic> item) {
            selectedDate = item.first.value;
            _controllerDay.text = item.first.name;
            print(selectedDate);
          },
          enableMultipleSelection: false,
        ),
      ).showModal(context);
    },
  );
}
}
