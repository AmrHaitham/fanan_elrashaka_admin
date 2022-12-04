import 'dart:io';

import 'package:flutter/material.dart';
class AddProfilePhoto extends StatelessWidget {
  final getImage;
  final  profile;
  final String demoPhoto;
  AddProfilePhoto({Key? key, this.getImage, this.profile, this.demoPhoto ="assets/user_avatar_male.png"}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: getImage,
      child: SizedBox(
        height: 90,
        width: 90,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            if(profile==null)
               CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(demoPhoto),
              ),
            if(profile != null)
              CircleAvatar(
                backgroundImage: Image.file(
                  File(profile),
                  fit: BoxFit.cover,
                ).image,
              ),
            Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.white),
                    ),
                    primary: Colors.white,
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  child: Image.asset("assets/camera.png"),
                  onPressed: getImage,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}