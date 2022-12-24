import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/Clinics.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/EditPackage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../translations/locale_keys.g.dart';
class ClinicCard extends StatefulWidget {
  final snapshot;
  final index;
  const ClinicCard({Key? key,required this.snapshot,required this.index}) : super(key: key);

  @override
  State<ClinicCard> createState() => _ClinicCardState();
}

class _ClinicCardState extends State<ClinicCard> {
  late bool is_available ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    is_available = widget.snapshot.data[widget.index]['available'];
  }
  @override
  Widget build(BuildContext context) {
      print(widget.snapshot.data[widget.index]);
      return ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: (is_available == true)?Image.asset("assets/availability_right_avatar.png"):Image.asset("assets/availability_wrong_avatar.png")
          ),
        ),
        title: Text((context.locale.toString()=="en")?
          "${widget.snapshot.data[widget.index]['clinic_name_en']}":
        "${widget.snapshot.data[widget.index]['clinic_name_ar']}",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Constants.textColor
          ),
        ),
        subtitle: Row(
          children: [
            Text(
                "${DateFormat('EEEE',context.locale.toString()).format(DateTime.parse("${widget.snapshot.data[widget.index]['date'].toString()} 00:00:00.00"))}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              "     |    ${widget.snapshot.data[widget.index]['date']}",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        trailing: InkWell(
          onTap: ()async{
            EasyLoading.show(status: "UpdateClinicAvailability".tr());
            Clinics _clinics = Clinics();
            final Dialogs _dialogs = Dialogs();
            var response =await  _clinics.updateClinicSchedule(context.read<UserData>().token,widget.snapshot.data[widget.index]['id'].toString());
            if(response.statusCode == 200){
              EasyLoading.dismiss();
              setState(() {
                is_available = !is_available;
              });
              _dialogs.doneDialog(context, "AvailabilityUpdated".tr(),'Ok'.tr(),(){
              });
            }else{
              print(jsonDecode(await response.stream.bytesToString()));
              EasyLoading.dismiss();
              _dialogs.errorDialog(context, LocaleKeys.Error__please_check_your_internet_connection.tr());
            }
          },
          child: SizedBox(
            width: 20,
            height: 20,
            child: Image.asset("assets/switch.png"),
          ),
        ),
      );
  }
}
