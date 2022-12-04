import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child:LoadingIndicator(
          indicatorType: Indicator.lineScalePulseOutRapid, /// Required, The loading type of the widget
          colors: Constants.statisticsColors,       /// Optional, The color collections
          // strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
          backgroundColor: Colors.transparent,      /// Optional, Background of the widget
          pathBackgroundColor: Colors.transparent   /// Optional, the stroke backgroundColor
      )
      ,
    );
  }
}
