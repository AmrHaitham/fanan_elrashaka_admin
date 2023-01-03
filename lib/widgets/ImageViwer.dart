import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class ImageViwer extends StatelessWidget {
  final String imageUrl;
  const ImageViwer({Key? key,required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PhotoView(
        imageProvider: NetworkImage(
            (imageUrl == null)?"":"${Apis.api}${imageUrl}"
        ),
        backgroundDecoration: BoxDecoration(
            color: Colors.transparent
        ),
        enableRotation: true,
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
    );
  }
}
