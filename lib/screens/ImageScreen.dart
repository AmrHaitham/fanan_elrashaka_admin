import 'package:fanan_elrashaka_admin/widgets/MainContainer.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../networks/ApisEndPoint.dart';
class ImageScreen extends StatefulWidget {
  final String name , imageUrl ;
  final uploadButton;
  final takePicAndUpload;

  const ImageScreen({Key? key,required this.name,required this.imageUrl,required this.uploadButton,required this.takePicAndUpload}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}


class _ImageScreenState extends State<ImageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          backIcon: true, patternColor: Colors.grey),
    );
  }
}
