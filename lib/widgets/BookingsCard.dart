import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/TimeSlotItem.dart';
import 'package:fanan_elrashaka_admin/widgets/TimeSlotsGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class BookingCard extends StatelessWidget {
  final snapshot;
  final String clinic_id;
  BookingCard({Key? key, this.snapshot,required this.clinic_id}) : super(key: key);
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  Dialogs _dialogs = Dialogs();
  Bookings _bookings = Bookings();
  @override
  Widget build(BuildContext context) {
    print(snapshot);
    return ExpansionTileCard(
      title: Text("${snapshot['first_name']} ${snapshot['last_name']}",style:
      const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20
      ),
      ),
      subtitle: Text(snapshot['clinic_service_en'],style: TextStyle(
          color: Constants.secondTextColor
      ),
      ),
      trailing: Container(
        width: 150,
        height: 50,
        child: Row(
          children: [
          Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (snapshot['paid'])?Color(0xffe9dfff):Color(0xffd2d2d2)
            ),
            child: Center(child: Text("Paid",style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (snapshot['paid'])?Constants.secondColor:Color(0xff9e9e9e)
            ),)),
          ),
          SizedBox(width: 10,),
          Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (snapshot['done'])?Color(0xffe9dfff):Color(0xffd2d2d2)
            ),
            child: Center(child: Text("Done",style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (snapshot['done'])?Constants.secondColor:Color(0xff9e9e9e)
            ),)),
          )
        ],),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Email:   "),
              Text(snapshot['email'].toString(),style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text("Phone:   "),
                Text(snapshot['phone'].toString(),style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("gender:   "),
              Expanded(child: Text((snapshot['gender'].toString() == 'F')?"Female":"Male",style: TextStyle(fontWeight: FontWeight.bold),))
            ],
          ),
        ),
        const Padding(
          padding:  EdgeInsets.only(top: 15.0,bottom: 10),
          child:  Divider(
            height: 4,
            color: Colors.black,
            thickness: 0.2,
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                _bottomSheetWidget.showBottomSheetButtons(
                    context,
                    300.0,
                    const Text("Booking Options",style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                    [
                      ListTile(
                        onTap: (){
                          _bottomSheetWidget.showBottomSheetButtons(
                              context,
                              250.0,
                            const Text(""),
                            [
                              FutureBuilder(
                                  future: _bookings.getReschedule(context.read<UserData>().token, snapshot['id'].toString()),
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CustomLoading());
                                    } else if (snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        // error in data
                                        print(snapshot.error.toString());
                                        return  Container();
                                      } else if (snapshot.hasData) {
                                        List values = snapshot.data.values.toList();
                                        List keys = snapshot.data.keys.toList();
                                        return TimeSlotsGrid(keys: keys, values: values,id:this.snapshot['id'].toString(),);
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
                            ]
                          );
                        },
                        dense: true,
                        leading: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/clock.png"),
                        ),
                        title:Text("Reschedule Booking",style: TextStyle(
                            color: Constants.secondTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                      const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                      ListTile(
                        onTap: ()async{
                          EasyLoading.show(status: "Change Done Status");
                          try{
                            var response =await _bookings.updateBookingData(
                                context.read<UserData>().token,
                                snapshot['id'].toString(),
                                clinic_id,
                                DateFormat("h:mm a").format(DateTime.parse("2020-01-02 ${snapshot['time']}.000")).toString(),
                                '0',
                                '1',
                            );
                            if (await response.statusCode == 200) {
                              _dialogs.doneDialog(context,"You_are_successfully_update_Done_Status","ok",(){});
                            }else{
                              print(await response.stream.bytesToString());
                              _dialogs.errorDialog(context,"Error_while_updating_Done_Status_check_your_interne_connection");
                            }
                            EasyLoading.dismiss();
                          }catch(v){
                            EasyLoading.dismiss();
                          }finally{
                            EasyLoading.showSuccess("Done Changing Done Status");
                            Navigator.pop(context);
                          }
                        },
                        dense: true,
                        leading: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/accept_2.png"),
                        ),
                        title:Text("Change Done Status",style: TextStyle(
                            color: Constants.secondTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                      const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                      ListTile(
                        onTap: ()async{
                          EasyLoading.show(status: "Change Paid Status");
                          try{
                            var response =await _bookings.updateBookingData(
                              context.read<UserData>().token,
                              snapshot['id'].toString(),
                              clinic_id,
                              DateFormat("h:mm a").format(DateTime.parse("2020-01-02 ${snapshot['time']}.000")).toString(),
                              '1',
                              '0',
                            );
                            if (await response.statusCode == 200) {
                              _dialogs.doneDialog(context,"You_are_successfully_update_Paid_Status","ok",(){});
                            }else{
                              print(await response.stream.bytesToString());
                              _dialogs.errorDialog(context,"Error_while_updating_Paid_Status_check_your_interne_connection");
                            }
                            EasyLoading.dismiss();
                          }catch(v){
                            EasyLoading.dismiss();
                          }finally{
                            EasyLoading.showSuccess("Done Changing Paid Status");
                            Navigator.pop(context);
                          }
                        },
                        dense: true,
                        leading: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/money_2.png"),
                        ),
                        title:Text("Change Paid Status",style: TextStyle(
                            color: Constants.secondTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                      const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                      ListTile(
                        onTap: ()async{
                          EasyLoading.show(status: "Cancel Book");
                          try{
                            var response =await _bookings.deleteBooking(
                              context.read<UserData>().token,
                              snapshot['id'].toString(),
                              DateFormat("h:mm a").format(DateTime.parse("2020-01-02 ${snapshot['time']}.000")).toString(),
                            );
                            if (await response.statusCode == 200) {
                              _dialogs.doneDialog(context,"You_are_successfully_Cancel_this_Book","ok",(){});
                            }else{
                              print(await response.stream.bytesToString());
                              _dialogs.errorDialog(context,"Error_while_Canceling_this_Book_check_your_interne_connection");
                            }
                            EasyLoading.dismiss();
                          }catch(v){
                            EasyLoading.dismiss();
                          }finally{
                            EasyLoading.showSuccess("Done Cancel Book");
                            Navigator.pop(context);
                          }
                        },
                        dense: true,
                        leading: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/bookmark_2.png"),
                        ),
                        title:Text("Cancel Booking",style: TextStyle(
                            color: Constants.secondTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                    ]
                );

              },
              child: Container(
                margin:const EdgeInsets.only(left: 10,right: 10),
                width: 30,
                height: 30,
                child: Image.asset("assets/more_bookings.png"),
              ),
            ),
            Column(
              children: [
                Text("Appointment Time",style: TextStyle(
                    color: Constants.secondTextColor
                ),),
                Text(DateFormat("h:mm a").format(DateTime.parse("2020-01-02 ${snapshot['time']}.000")).toString(),
                  style: TextStyle(
                      color: Constants.secondColor,
                      fontSize: 17
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
