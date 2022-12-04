import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/TimeSlotItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class TimeSlotsGrid extends StatefulWidget {
  final List keys,values;
  final String id;

  const TimeSlotsGrid({Key? key,required this.keys,required this.values,required this.id}) : super(key: key);
  @override
  _TimeSlotsGridState createState() => _TimeSlotsGridState();
}

class _TimeSlotsGridState extends State<TimeSlotsGrid> {
  int? selectedIndex;
  Dialogs _dialogs = Dialogs();
  Bookings _bookings = Bookings();
  void onChange(int index){
    setState(() => selectedIndex = index);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width*0.9,
              height: 120,
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.5/0.25,
                children: [
                  for(int i=0;i<widget.keys.length;i++)
                    TimeSlotItem(Value: widget.values[i].toString(),onChange: ()=> onChange(i), isSelected: selectedIndex == i,)
                ],
              )
          ),
          const SizedBox(height: 20,),
          DefaultButton(
            text: "Reschedule",
            press: ()async{
              print("selected time is :- ${widget.keys[selectedIndex!]} : ${widget.values[selectedIndex!]}");
              print("for id : ${widget.id}");
              EasyLoading.show(status: "Reschedule Book");
              try{
                var response =await _bookings.rescheduleBook(
                  context.read<UserData>().token,
                  widget.id,
                  widget.keys[selectedIndex!]
                );
                if (await response.statusCode == 200) {
                  _dialogs.doneDialog(context,"You_are_successfully_update_Book_time","ok",(){});
                }else{
                  print(await response.stream.bytesToString());
                  _dialogs.errorDialog(context,"Error_while_updating_Book_time_data_check_your_interne_connection");
                }
                EasyLoading.dismiss();
                setState(() {});
              }catch(v){
                EasyLoading.dismiss();
                setState(() {});
              }finally{
                EasyLoading.showSuccess("Done Rescheduling Book");
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
