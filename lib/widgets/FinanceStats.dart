import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/networks/Finance.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FinanceStats extends StatefulWidget {
  @override
  _FinanceStatsState createState() => _FinanceStatsState();
}

class _FinanceStatsState extends State<FinanceStats> {
  String? fromDate , toDate;
  DateTime? fromDateI , toDateI;
  TextEditingController _controller = TextEditingController();
  FinanceStatistics _financeStatistics = FinanceStatistics();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        name: "FinanceStatistics".tr(),
        topLeftAction: BackIcon(),
        topCenterAction: Container(
          height: 70,
          margin:const EdgeInsets.only(left: 15,right: 15,),
          decoration: BoxDecoration(
            color: Constants.mainColor,
            borderRadius:const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child:Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: buildFromToDateFormField(context),
            ),
          ),
        ),
        child: FutureBuilder(
            future: _financeStatistics.getFinance_statistics(context.read<UserData>().token, fromDate, toDate),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CustomLoading());
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // error in data
                  print(snapshot.error.toString());
                  return  Container();
                } else if (snapshot.hasData) {
                  print(snapshot.data);
                  data.clear();
                  // data.addAll(dataDemo);
                  for(int i = 0 ; i < snapshot.data.length ;i++){
                    data.add(BarChartModel(
                        name: snapshot.data[i]['name'],
                        financial: int.parse(snapshot.data[i]['amount'].toString().split('.')[0]) ,
                        color: charts.ColorUtil.fromDartColor(colorsList[i]),
                        percentage: snapshot.data[i]['percentage']
                    ));
                  }
                  // data.add(BarChartModel());
                  series = [
                    charts.Series(
                        id: "Financial",
                        data: data,
                        domainFn: (BarChartModel series, _) => series.name!,
                        measureFn: (BarChartModel series, _) => series.financial,
                        colorFn: (BarChartModel series, _) => series.color!
                    ),
                  ];
                  return Expanded(
                      child: ListView(
                        children: [
                          Container(
                            margin:const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Constants.mainColor,
                              borderRadius:const BorderRadius.all(Radius.circular(1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            height: MediaQuery.of(context).size.height*0.3,
                            child: charts.BarChart(
                                series,
                                animate: true
                            )
                            ,),
                          Container(
                            margin:const EdgeInsets.only(left: 10,right: 10,bottom: 8),
                            padding: const EdgeInsets.all(5),
                            height: MediaQuery.of(context).size.height*0.4,
                            decoration: BoxDecoration(
                              color: Constants.mainColor,
                              borderRadius:const BorderRadius.all(Radius.circular(1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListView(
                              children: [
                                for(int i = 0 ; i < data.length ;i++)
                                  ListTile(
                                    leading: Container(
                                        width: 50,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: colorsList[i]
                                        ),
                                        child: Center(child: Text("${data[i].percentage.toString().split('.')[0]}%",style:const TextStyle(
                                          color: Colors.white
                                        ),))
                                    ),
                                    title: Text(data[i].name.toString()),
                                    trailing: Text("EGP ${data[i].financial.toString()}"),
                                  )
                              ],
                            ),
                          )
                        ],
                      )
                  );
                }else{
                  //no data
                  return Container();
                }
              }else{
                //error in connection
                return Container();
              }
            }
        ),
    );
  }
  buildFromToDateFormField(context){
    return TextFormField(
      controller:_controller ,
      decoration: InputDecoration(
        hoverColor: Constants.secondColor,
        fillColor: Constants.secondColor,
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(10),
        ),
        hintText:"DateRange".tr(),
        label:  Text("DateRange".tr()),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.range(
          initialFirstDate:fromDateI?? DateTime.now().subtract(Duration(days: 1000)),
          initialSecondDate:toDateI,
          minSecondDate:toDateI??  DateTime.now().subtract(Duration(days: 1000)),
          title: "DateRange".tr(),
          dateOrder: DatePickerDateOrder.dmy,
          pickerTextStyle:const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          titleStyle:const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.blue,
          ),
          bottomPickerTheme: BottomPickerTheme.blue,
          onSubmitPressed: (from , to ) {
            fromDateI = from;
            toDateI = to;
            fromDate = from.toString().split(" ")[0];
            toDate = to.toString().split(" ")[0];
            _controller.text = fromDate! + " - " + toDate!;
            setState(() {});
          },
        ).show(context);
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          return null;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return LocaleKeys.ThisFieldIsRequired.tr() ;
        }
        return null;
      },
    );
  }
  final List<Color> colorsList = <Color>[
    Color(0xFF47505F),
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.grey,
    Colors.blue,
    Colors.brown,
    Colors.lightGreenAccent,
    Colors.purple,
    Colors.greenAccent,
    Colors.deepOrangeAccent,
    Colors.indigo,
    Colors.yellowAccent,
    Colors.purpleAccent,
    (Colors.lime)
  ];
  final List<BarChartModel> data = [];
  final List<BarChartModel> dataDemo = [
    BarChartModel(
      name: "2015",
      financial: 300,
      color: charts.ColorUtil.fromDartColor
        (Colors.red),
      percentage: 10
    ),
    BarChartModel(
      name: "2016",
      financial: 100,
      color: charts.ColorUtil.fromDartColor
        (Colors.green),
        percentage: 20
    ),
    BarChartModel(
      name: "2017",
      financial: 450,
      color: charts.ColorUtil.fromDartColor
        (Colors.yellow),
        percentage: 50
    ),
    BarChartModel(
      name: "2018",
      financial: 630,
      color: charts.ColorUtil.fromDartColor
        (Colors.lightBlueAccent),
        percentage: 20
    ),
    BarChartModel(
      name: "2019",
      financial: 1000,
      color: charts.ColorUtil.fromDartColor
        (Colors.pink),
        percentage: 30
    ),
    BarChartModel(
      name: "2020",
      financial: 400,
      color: charts.ColorUtil.fromDartColor
        (Colors.purple),
        percentage: 40
    ),
  ];
  List<charts.Series<BarChartModel, String>> series =[];
}
class BarChartModel {
  String? name;
  int? financial;
  final charts.Color? color;
  double? percentage;

  BarChartModel({
    this.name,
    this.financial,
    this.color,
    this.percentage
  }
      );
}