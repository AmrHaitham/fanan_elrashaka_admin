import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/PationtProfile.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/MainContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../networks/ApisEndPoint.dart';
class AppImageScreen extends StatefulWidget {
  final String name , imageUrl ,pid;

  const AppImageScreen({Key? key,required this.name,required this.imageUrl,required this.pid,}) : super(key: key);

  @override
  State<AppImageScreen> createState() => _AppImageScreenState();
}


class _AppImageScreenState extends State<AppImageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PatientDetails _patientDetails = PatientDetails();
  final Dialogs _dialogs = Dialogs();
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PationtProfile(pid: widget.pid))
        );
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              child: Icon(Icons.image),
              onPressed:()async{
                var imagePicker;
                imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                String imageLocation = imagePicker.path.toString();
                EasyLoading.show(status: "UploadApplicationImage".tr());
                var picResponse =await _patientDetails.uploadAppImage(
                    context.read<UserData>().token,
                    widget.pid,
                    imageLocation
                );
                if (await picResponse.statusCode == 200) {
                  _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => PationtProfile(pid: widget.pid))
                    );
                  });
                }else{
                  print(await picResponse.stream.bytesToString());
                _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
                }
                EasyLoading.dismiss();
              },
            ),
            const SizedBox(width: 10,),
            FloatingActionButton(
              heroTag: "btn2",
              child: Icon(Icons.camera_alt),
              onPressed:()async{
                try{
                  var imagePicker;
                  imagePicker = await _picker.pickImage(source: ImageSource.camera,imageQuality: 20);
                  String imageLocation = imagePicker.path.toString();
                  EasyLoading.show(status: "UploadApplicationImage".tr());
                  var picResponse =await _patientDetails.uploadAppImage(
                      context.read<UserData>().token,
                      widget.pid,
                      imageLocation
                  );
                  if (await picResponse.statusCode == 200) {
                    EasyLoading.dismiss();
                    _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => PationtProfile(pid: widget.pid))
                      );
                    });
                  }else{
                    print(await picResponse.stream.bytesToString());
                    _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
                  }
                }catch(v){
                  print(v);
                }
              },
            ),
          ],
        ),
        body: MainContainer(
            title: widget.name,
            child: PhotoView(
              imageProvider: NetworkImage(
                  (widget.imageUrl == null)?"":"${Apis.api}${widget.imageUrl}"
              ),
              backgroundDecoration: BoxDecoration(
                  color: Colors.transparent
              ),
              enableRotation: false,
              errorBuilder: (context, object, stackTrace) =>
                  Icon(Icons.all_inclusive_rounded),
              loadingBuilder: (context, progress) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            backIcon: false, patternColor: Colors.grey),
      ),
    );
  }
}
