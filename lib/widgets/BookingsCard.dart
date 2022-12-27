import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/TimeSlotItem.dart';
import 'package:fanan_elrashaka_admin/widgets/TimeSlotsGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class BookingCard extends StatefulWidget {
  final snapshot;
  final String clinic_id;
  BookingCard({Key? key, this.snapshot,required this.clinic_id}) : super(key: key);

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();

  Dialogs _dialogs = Dialogs();

  Bookings _bookings = Bookings();

  @override
  Widget build(BuildContext context) {
    print(widget.snapshot);
    return (widget.snapshot["id"] != "")?ExpansionTileCard(
      baseColor: Colors.white,
      shadowColor: Colors.grey,
      title: Text("${widget.snapshot['first_name']} ${widget.snapshot['last_name']}",style:
      const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20
      ),
      ),
      subtitle: Text((context.locale.toString()=="en")?widget.snapshot['clinic_service_en']:widget.snapshot['clinic_service_ar'],style: TextStyle(
          color: Color(0xff6a6a6c),
          fontWeight: FontWeight.bold
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
              color: (widget.snapshot['paid'])?Color(0xffe9dfff):Color(0xffd2d2d2)
            ),
            child: Center(child: Text("Paid".tr(),style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (widget.snapshot['paid'])?Constants.secondColor:Color(0xff9e9e9e)
            ),)),
          ),
          SizedBox(width: 10,),
          Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (widget.snapshot['done'])?Color(0xffe9dfff):Color(0xffd2d2d2)
            ),
            child: Center(child: Text("Done".tr(),style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (widget.snapshot['done'])?Constants.secondColor:Color(0xff9e9e9e)
            ),)),
          )
        ],),
      ),
      children: [
        const Divider(
          height: 4,
          color: Colors.black,
          thickness: 0.2,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
               Text("${"Email".tr()}:       ",style: TextStyle(
                  color: Color(0xff6a6a6c),
                  fontWeight: FontWeight.bold
              ),),
              Text(widget.snapshot['email'].toString(),style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                 Text("${"Phone".tr()}:     ",style: TextStyle(
                    color: Color(0xff6a6a6c),
                    fontWeight: FontWeight.bold
                ),),
                Text(widget.snapshot['phone'].toString(),style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
               Text("${"Gender".tr().split("*")[0]}:   ",style: TextStyle(
                  color: Color(0xff6a6a6c),
                  fontWeight: FontWeight.bold
              ),),
              Expanded(child: Text((widget.snapshot['gender'].toString() == 'F')?"Female":"Male",style: TextStyle(fontWeight: FontWeight.bold),))
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
                     Text("BookingOptions".tr(),style: TextStyle(
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
                                  future: _bookings.getReschedule(context.read<UserData>().token, widget.snapshot['id'].toString()),
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
                                        return TimeSlotsGrid(keys: keys, values: values,id:this.widget.snapshot['id'].toString());
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
                        title:Text("RescheduleBooking".tr(),style: TextStyle(
                            color: Constants.secondTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                      const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                      ListTile(
                        onTap: ()async{
                          EasyLoading.show(status: "ChangeDoneStatus".tr());
                          try{
                            var response =await _bookings.updateBookingData(
                                context.read<UserData>().token,
                                widget.snapshot['id'].toString(),
                                widget.clinic_id,
                                DateFormat("h:mm a").format(DateTime.parse("2020-01-02 ${widget.snapshot['time']}.000")).toString(),
                                '0',
                                '1',
                            );
                            if (await response.statusCode == 200) {
                              _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){
                                Navigator.pop(context);
                                setState(() {
                                  widget.snapshot['done'] = !widget.snapshot['done'];
                                });
                              });
                            }else{
                              print(await response.stream.bytesToString());
                              _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
                            }
                            EasyLoading.dismiss();
                          }catch(v){
                            EasyLoading.dismiss();
                          }
                        },
                        dense: true,
                        leading: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/accept_2.png"),
                        ),
                        title:Text("ChangeDoneStatus".tr(),style: TextStyle(
                            color: Constants.secondTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                      const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                      ListTile(
                        onTap: ()async{
                          EasyLoading.show(status: "ChangePaidStatus".tr());
                          try{
                            var response =await _bookings.updateBookingData(
                              context.read<UserData>().token,
                              widget.snapshot['id'].toString(),
                              widget.clinic_id,
                              DateFormat("h:mm a").format(DateTime.parse("2020-01-02 ${widget.snapshot['time']}.000")).toString(),
                              '1',
                              '0',
                            );
                            if (await response.statusCode == 200) {
                              _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){
                                Navigator.pop(context);
                                setState(() {
                                  widget.snapshot['paid'] = !widget.snapshot['paid'];
                                });
                              });
                            }else{
                              print(await response.stream.bytesToString());
                              _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
                            }
                            EasyLoading.dismiss();
                          }catch(v){
                            EasyLoading.dismiss();
                          }
                        },
                        dense: true,
                        leading: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/money_2.png"),
                        ),
                        title:Text("ChangePaidStatus".tr(),style: TextStyle(
                            color: Constants.secondTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                      const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                      ListTile(
                        onTap: ()async{
                          EasyLoading.show(status: "CancelBook".tr());
                          try{
                            var response =await _bookings.deleteBooking(
                              context.read<UserData>().token,
                              widget.snapshot['id'].toString(),
                              DateFormat("h:mm a",context.locale.toString()).format(DateTime.parse("2020-01-02 ${widget.snapshot['time']}.000")).toString(),
                            );
                            if (await response.statusCode == 200) {
                              _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){
                                Navigator.pop(context);
                                setState(() {
                                  widget.snapshot["id"] = "";
                                });
                              });
                            }else{
                              print(await response.stream.bytesToString());
                              _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
                            }
                            EasyLoading.dismiss();
                          }catch(v){
                            EasyLoading.dismiss();
                          }
                        },
                        dense: true,
                        leading: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/bookmark_2.png"),
                        ),
                        title:Text("CancelBook".tr(),style: TextStyle(
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("AppointmentTime".tr(),style: TextStyle(
                    color: Constants.secondTextColor
                ),),
                Text(DateFormat("h:mm a",context.locale.toString()).format(DateTime.parse("2020-01-02 ${widget.snapshot['time']}.000")).toString(),
                  style: TextStyle(
                      color: Constants.secondColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            )
          ],
        )
      ],
    ):Container();
  }
}
