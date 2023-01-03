import 'package:fanan_elrashaka_admin/screens/PationtProfile.dart';
import 'package:fanan_elrashaka_admin/widgets/MainContainer.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../networks/ApisEndPoint.dart';
class ImageScreen extends StatefulWidget {
  final String name , imageUrl ;
  final uploadButton;
  final takePicAndUpload;
  final String pid;

  const ImageScreen({Key? key,required this.name,required this.imageUrl,required this.uploadButton,required this.takePicAndUpload,required this.pid}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}


class _ImageScreenState extends State<ImageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
              onPressed:(){
                widget.uploadButton();
              },
            ),
            const SizedBox(width: 10,),
            FloatingActionButton(
              heroTag: "btn2",
              child: Icon(Icons.camera_alt),
              onPressed:(){
                widget.takePicAndUpload();
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
