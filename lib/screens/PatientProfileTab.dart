import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class PatientProfileTab extends StatelessWidget {
  final name , color , image , onTap;
  const PatientProfileTab({Key? key,required this.name,required this.color,required this.image, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width*0.43,
          height: MediaQuery.of(context).size.height*0.23,
          decoration: BoxDecoration(
              border: Border.all(width: 0.1,color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xfffbf8fd)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: color
                ),
                child: Padding(
                  padding:const EdgeInsets.all(25),
                  child: Image.asset("assets/$image"),
                ),
              ),
              const SizedBox(height: 5,),
              Text(name,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Constants.secondTextColor
              ),)
            ],
          )
      ),
    );
  }
}
