import 'package:fanan_elrashaka_admin/widgets/MainContainer.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../networks/ApisEndPoint.dart';
class ImageScreen extends StatefulWidget {
  final String name , imageUrl ;
  final uploadButton;

  const ImageScreen({Key? key,required this.name,required this.imageUrl,required this.uploadButton}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:(){
          widget.uploadButton();
        },
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
