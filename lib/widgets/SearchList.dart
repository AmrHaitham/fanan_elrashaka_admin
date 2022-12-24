import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
class SearchList extends StatelessWidget {
  final onSubmitted;
  final onSearchClick;
  SearchList({Key? key,required this.onSubmitted,required this.onSearchClick}) : super(key: key);
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: 45,
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
            Container(
              width: MediaQuery.of(context).size.width*0.76,
              padding:const EdgeInsets.only(left: 10,right: 10),
              child: TextField(
                controller: myController,
                onSubmitted:(value){
                  onSubmitted(value);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search'.tr(),
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
