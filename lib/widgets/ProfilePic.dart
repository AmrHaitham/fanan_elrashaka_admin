import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final uploadImage;
  final  profile;
  ProfilePic({Key? key, this.uploadImage, this.profile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: uploadImage,
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
                backgroundImage: AssetImage("assets/user_avatar_male.png"),
                // child: SizedBox( width:40,height:40,child: Image.asset("assets/user_avatar_male.png")),
              ),
            if(profile != null)
              CircleAvatar(
                backgroundImage: NetworkImage("${Apis.api}${profile}"),
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
                  onPressed: uploadImage,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
