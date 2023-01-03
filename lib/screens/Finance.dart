import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:fanan_elrashaka_admin/models/CategoriesModel.dart';
import 'package:fanan_elrashaka_admin/networks/Finance.dart';
import 'package:fanan_elrashaka_admin/networks/Reports.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/FinanceStats.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/models/Clinic.dart';
import 'package:fanan_elrashaka_admin/networks/MoneyLog.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AddMoneyLog.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/FinanceCard.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
class Finance extends StatefulWidget {
  final token ;

  const Finance({Key? key,required this.token}) : super(key: key);
  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  MoneyLog _moneyLog = MoneyLog();
  var data ;
  String? fromDate , toDate;
  TextEditingController _controller = TextEditingController();
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();

  String? clinics , categories , services;

  static List<Clinic> _clinics = [];
  List<MultiSelectItem<Object?>> _items = [];
  List<dynamic?> _selectedClinics = [];

  static List<CategoriesModel> _categories = [];
  List<MultiSelectItem<Object?>> _categoriesItems = [];
  List<dynamic?> _selectedCategories = [];

  static List<Clinic> _clinicServices = [];
  List<MultiSelectItem<Object?>> _itemsServices = [];
  List<dynamic?> _selectedClinicServices = [];
  DateTime? fromDateI , toDateI;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _clinics = context.read<ClinisData>().clinicsName;
    _items = _clinics
        .map((clinic) => MultiSelectItem<Clinic>(clinic, clinic.name!))
        .toList();

    _categories = context.read<ClinisData>().categoriesModel;
    _categoriesItems = _categories
        .map((categories) => MultiSelectItem<CategoriesModel>(categories, categories.name!))
        .toList();

    _clinicServices = context.read<ClinisData>().clinicsService;
    _itemsServices = _clinicServices
        .map((clinic) => MultiSelectItem<Clinic>(clinic, clinic.name!))
        .toList();
  }

  Reports _reports = Reports();
  Future<bool> askPermission() async{
    PermissionStatus status = await Permission.storage.status;
    if(status.isDenied == true)
    {
      askPermission();
      return false;
    }
    else
    {
      return true;
    }
  }

  downloadReport(api)async{
    try{
      askPermission();
      EasyLoading.show(status: "GettingReport".tr());
      var response =await api;
      var data = jsonDecode(await response.stream.bytesToString());
      if(response.statusCode == 200){
        final uri = Uri.parse(data['link'].toString());
        var response = await http.get(uri);
        final bytes = response.bodyBytes;
        String path ='';
        if(Platform.isAndroid){
          path = '/storage/emulated/0/Download/${data['link'].toString().split('/').last}';
        }else{
          var directory = await getApplicationDocumentsDirectory();
          path = '${directory.path}/${data['link'].toString().split('/').last}';
        }
        try{
          print("save file to -> $path");
          File(path).writeAsBytesSync(bytes);
          EasyLoading.showSuccess("DoneDownloadingReport".tr());
          OpenFile.open(path);
        }catch(v){
          print(v);
          EasyLoading.showError("ErrorWhileDownloadingFile".tr());
        }finally{
          setState(() {
            services = null;
            clinics = null;
            services = null;
            _selectedClinicServices.clear();
            _selectedCategories.clear();
            _selectedClinics.clear();
          });
          Navigator.pop(context);
          Navigator.pop(context);
          EasyLoading.dismiss();
        }
      }else{
        print(response.statusCode);
        print("error : $data");
        EasyLoading.dismiss();
      }
    }catch(v){
      EasyLoading.dismiss();
      print(v);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor:Constants.secondColor ,
          child:const Icon(Icons.add,size: 30),
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddMoneyLog(date: _selectedDay.toString().split(" ")[0],))
            );
          }
      ),
      body: ScreenContainer(
          onRefresh: (){
            setState(() {});
          },
          name: "Financial".tr(),
          topLeftAction: BackIcon(),
          topCenterAction: Container(
            height: 80,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FinanceStats())
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration:const BoxDecoration(
                          color: Color(0xffe9dfff),
                          borderRadius:BorderRadius.all(Radius.circular(13)),
                        ),
                        width: 45,
                        height: 45,
                        padding:const EdgeInsets.all(8),
                        child: Image.asset("assets/stats.png"),
                      ),
                       Text("Stats".tr(),style: TextStyle(
                        color: Constants.secondTextColor,
                         fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    _bottomSheetWidget.showBottomSheetButtons(
                        context,
                        250.0,
                         Text("Reports".tr(),style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),),
                        [
                          SizedBox(height: 20,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: (){
                                  _bottomSheetWidget.showBottomSheetButtons(
                                      context,
                                      350.0,
                                       Text("FullFinancialReport".tr(),style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                  ),),
                                    [
                                      const SizedBox(height: 20,),
                                      buildFromToDateFormField(context),
                                      const SizedBox(height: 20,),
                                      buildClinicSelect(),
                                      const SizedBox(height: 20,),
                                      DefaultButton(
                                        text: "GetReport".tr(),
                                        press: ()async{
                                          await downloadReport(_reports.getFinance_full_report(widget.token, fromDate, toDate, clinics));

                                        },
                                      )
                                    ]
                                  );
                                },
                                  child: Text(LocaleKeys.FullFinancialReport.tr()
                                  ,style: TextStyle(
                                      color: Constants.secondTextColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                  ),)
                            ),
                          ),
                          const SizedBox(height: 5,),
                          const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                          const SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: (){
                                  _bottomSheetWidget.showBottomSheetButtons(
                                      context,
                                      550.0,
                                       Text("FinancialComparisonReport".tr(),style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                      ),),
                                      [
                                        const SizedBox(height: 20,),
                                        buildFromToDateFormField(context),
                                        const SizedBox(height: 20,),
                                        buildClinicServicesSelect(),
                                        const SizedBox(height: 20,),
                                        buildCategorysSelect(),
                                        const SizedBox(height: 20,),
                                        DefaultButton(
                                          text: "GetReport".tr(),
                                          press: ()async{
                                            await downloadReport(_reports.getFinance_comparison_report(widget.token, fromDate, toDate, services,categories));
                                          },
                                        )
                                      ]
                                  );
                                },
                                child: Text("FinancialComparisonReport".tr()
                                  ,style:TextStyle(
                                      color: Constants.secondTextColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                  ),)
                            ),
                          ),
                          const SizedBox(height: 5,),
                          const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                          const SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: (){
                                  _bottomSheetWidget.showBottomSheetButtons(
                                      context,
                                      350.0,
                                       Text("FinancialServicesReport".tr(),style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                      ),),
                                      [
                                        const SizedBox(height: 20,),
                                        buildFromToDateFormField(context),
                                        const SizedBox(height: 20,),
                                        buildClinicServicesSelect(),
                                        const SizedBox(height: 20,),
                                        DefaultButton(
                                          text: "GetReport".tr(),
                                          press: ()async{
                                            await downloadReport(_reports.getFinance_service_report(widget.token, fromDate, toDate, services));
                                          },
                                        )
                                      ]
                                  );
                                },
                                child: Text("FinancialServicesReport".tr()
                                  ,style: TextStyle(
                                      color: Constants.secondTextColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            ),
                          ),
                        ]
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration:const BoxDecoration(
                          color: Color(0xffc6fbfe),
                          borderRadius:BorderRadius.all(Radius.circular(13)),
                        ),
                        width: 45,
                        height: 45,
                        padding:const EdgeInsets.all(8),
                        child: Image.asset("assets/report.png"),
                      ),
                       Text("Reports".tr(),style: TextStyle(
                          color: Constants.secondTextColor,
                          fontWeight: FontWeight.bold
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          child: Expanded(
            child: Column(
              children: [
                TableCalendar(
                  headerStyle: HeaderStyle(
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                      formatButtonVisible: false,
                      formatButtonShowsNext: false,
                      headerMargin: EdgeInsets.only(left: 15),
                      titleTextStyle: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color:Constants.secondColor
                      ),
                      titleTextFormatter: (datetime, data) {
                        return DateFormat("MMMM, y").format(_focusedDay);
                      }),
                  onHeaderTapped: (date) {
                    setState(() {
                      _calendarFormat =
                      (_calendarFormat == CalendarFormat.week)
                          ? CalendarFormat.month
                          : CalendarFormat.week;
                    });
                  },
                  calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff373d46),
                        fontSize: 15,
                      ),
                      holidayTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff373d46),
                        fontSize: 15,
                      ),
                      rangeEndTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff373d46),
                        fontSize: 15,
                      ),
                      withinRangeTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff373d46),
                        fontSize: 15,
                      ),
                      disabledTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff373d46),
                        fontSize: 15,
                      ),
                      // outsideTextStyle: TextStyle(
                      //   fontWeight: FontWeight.bold,
                      //   color: Color(0xff373d46),
                      //   fontSize: 15,
                      // ),
                      rangeStartTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff373d46),
                        fontSize: 15,
                      ),
                      weekendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff373d46),
                        fontSize: 15,
                      ),
                      selectedTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Constants.secondColor
                      ),
                      defaultDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      disabledDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      holidayDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      markerDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      rangeEndDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      outsideDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      rangeStartDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      rowDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      weekendDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      withinRangeDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      selectedDecoration: BoxDecoration(
                          color:const Color(0xffe9dfff),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      )),
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      print(_selectedDay);
                      // getData();
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
                  },
                ),
                const Divider(
                  height: 4,
                  color: Colors.black,
                  thickness: 0.2,
                ),
                FutureBuilder(
                    future: _moneyLog.getAllMoneyLogs(widget.token, _selectedDay.toString().split(" ")[0]),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CustomLoading());
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          // error in data
                          print(snapshot.error.toString());
                          return  Container();
                        } else if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context , index){
                                  return Container(
                                      width: double.infinity,
                                      margin:const EdgeInsets.all(10),
                                      child:FinanceCard(
                                        snapshot: snapshot.data[index],
                                        date: _selectedDay.toString().split(" ")[0],
                                      )
                                  );
                                }
                            ),
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
              ],
            ),
          )
      ),
    );
  }
  buildFromToDateFormField(context){
    return TextFormField(
      controller:_controller ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText:"DateRange".tr(),
        label:  Text("DateRange".tr()),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.range(
          // initialFirstDate: DateTime.now().subtract(const  Duration(days:700)),
          // minSecondDate:  DateTime.now().subtract(const  Duration(days:356)),
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
  buildCategorysSelect(){
    return MultiSelectBottomSheetField(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      initialChildSize: 0.4,
      listType: MultiSelectListType.CHIP,
      searchable: true,
      buttonText: Text("Category".tr(),),
      title: Text("Category".tr(),style: TextStyle(
          fontSize: 30
      ),),
      items: _categoriesItems,
      onConfirm: (values){
        _selectedCategories = values;
        String holder = "";
        _selectedCategories.forEach((element) {
          holder +=  element.id;
        });
        categories = holder.split("").join(",");
        print(categories);
      },
      selectedItemsTextStyle:const TextStyle(
          color:  Color(0xfff8755ea)
      ),
      cancelText: Text("Cancel".tr()),
      confirmText: Text("Select".tr()),
      selectedColor:const Color(0xfffe9dfff) ,
      chipDisplay: MultiSelectChipDisplay(
        chipColor:const Color(0xfffe9dfff),
        textStyle:const TextStyle(
            color: Color(0xfff8755ea)
        ),
        // icon:const Icon(Icons.cancel_outlined,color: Color(0xfff8755ea),),
        // onTap: (value) {
        //   setState(() {
        //     _selectedCategories.remove(value);
        //     String holder = "";
        //     _selectedCategories.forEach((element) {
        //       holder +=  element.id;
        //     });
        //     categories = holder.split("").join(",");
        //     print(categories);
        //   });
        // },
      ),
    );
  }
  buildClinicSelect(){
    return MultiSelectBottomSheetField(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      initialChildSize: 0.4,
      listType: MultiSelectListType.CHIP,
      searchable: true,
      buttonText:  Text("Clinic".tr(),),
      title: Text("Clinic".tr(),style: TextStyle(
          fontSize: 30
      ),),
      items: _items,
      onConfirm: (values){
        _selectedClinics = values;
        String holder = "";
        _selectedClinics.forEach((element) {
          holder +=  element.id;
        });
        clinics = holder.split("").join(",");
        print(clinics);
      },
      selectedItemsTextStyle:const TextStyle(
          color:  Color(0xfff8755ea)
      ),
      cancelText: Text("Cancel".tr()),
      confirmText: Text("Select".tr()),
      selectedColor:const Color(0xfffe9dfff) ,
      chipDisplay: MultiSelectChipDisplay(
        chipColor:const Color(0xfffe9dfff),
        textStyle:const TextStyle(
            color: Color(0xfff8755ea)
        ),
        // icon:const Icon(Icons.cancel_outlined,color: Color(0xfff8755ea),),
        // onTap: (value) {
        //   setState(() {
        //     _selectedClinics.remove(value);
        //     String holder = "";
        //     _selectedClinics.forEach((element) {
        //       holder +=  element.id;
        //     });
        //     clinics = holder.split("").join(",");
        //     print(clinics);
        //   });
        // },
      ),
    );
  }
  buildClinicServicesSelect(){
    return MultiSelectBottomSheetField(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      initialChildSize: 0.4,
      listType: MultiSelectListType.CHIP,
      searchable: true,
      buttonText:  Text("ClinicsServices".tr(),),
      title: Text("ClinicsServices".tr(),style: TextStyle(
          fontSize: 30
      ),),
      items: _itemsServices,
      onConfirm: (values){
        _selectedClinicServices = values;
        String holder = "";
        _selectedClinicServices.forEach((element) {
          holder +=  element.id;
        });
        services = holder.split("").join(",");
        print(services);
      },
      selectedItemsTextStyle:const TextStyle(
          color:  Color(0xfff8755ea)
      ),
      cancelText: Text("Cancel".tr()),
      confirmText: Text("Select".tr()),
      selectedColor:const Color(0xfffe9dfff) ,
      chipDisplay: MultiSelectChipDisplay(
        chipColor:const Color(0xfffe9dfff),
        textStyle:const TextStyle(
            color: Color(0xfff8755ea)
        ),
        icon:const Icon(Icons.cancel_outlined,color: Color(0xfff8755ea),),
        onTap: (value) {
          setState(() {
            _selectedClinicServices.remove(value);
            String holder = "";
            _selectedClinicServices.forEach((element) {
              holder +=  element.id;
            });
            services = holder.split("").join(",");
            print(services);
          });
        },
      ),
    );
  }
}
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
