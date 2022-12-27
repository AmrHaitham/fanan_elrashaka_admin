import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class Dialogs{
  errorDialog(context,String text,){
    return AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(text,),),
        btnCancelOnPress: () {},
    )..show();
  }
  errorReDialog(context,String text,btnCancelOnPress){
    return AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.ERROR,
      body: Center(child: Text(text,),),
      btnCancelOnPress: btnCancelOnPress,
      btnCancelText: "Retry"
    )..show();
  }
  warningDialog(context,String text,action,String okText){
    return AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.WARNING,
      body: Center(child: Text(text,),),
      btnCancelOnPress: () {},
      btnOkOnPress: (){
        action();
      },
      btnOkText:okText
    )..show();
  }
  doneDialog(context,String text,String okText,action){
    return AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.SUCCES,
      body: Center(child: Text(text,),),
      btnOkText:okText,
      btnOkOnPress: (){
        action();
      }
    )..show();
  }
}