import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class SearchWithBack extends StatelessWidget {
  final onSubmitted;
  final onSearchClick;
  final onBack;
  final controller;
  SearchWithBack({Key? key,required this.onSubmitted,required this.onSearchClick, this.onBack, this.controller}) : super(key: key);
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: 90,
        decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(20)),
            color: Constants.mainColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 10,
                offset:const Offset(0, 4), // changes position of shadow
              ),
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  [
            InkWell(
              onTap: (){
                onBack();
              },
              child: Transform.scale(
                scaleX: -1,
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: Image.asset("assets/right-arrow_gray.png"),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.76,
              padding:const EdgeInsets.only(left: 10,right: 10),
              child: TextField(
                controller: controller??myController,
                onSubmitted:(value){
                  onSubmitted(value);
                },
                decoration:const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search..',
                ),
              ),
            ),
            InkWell(
              onTap: (){
                onSearchClick(myController.value.text);
              },
              child: SizedBox(
                width: 18,
                height: 18,
                child: Image.asset("assets/search.png"),
              ),
            )
          ],
        )
    );
  }
}
