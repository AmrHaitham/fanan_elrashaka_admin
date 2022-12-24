import 'dart:collection';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/models/agenda.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/AgendaContainer.dart';

class FoodAgendaScreen extends StatefulWidget {
  final pid;

  const FoodAgendaScreen({Key? key, this.pid}) : super(key: key);
  @override
  State<FoodAgendaScreen> createState() => _FoodAgendaScreenState();
}

class _FoodAgendaScreenState extends State<FoodAgendaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  bool _isLoading = true;
  List<Agenda> data = [];
  PatientDetails _patientDetails = PatientDetails();
  // convetToMillisecondsSinceEpoch(date,time){
  //   String datetime ="${DateFormat("yyyy-MM-dd").format(DateTime.parse(date)).toString()} ${time.toString()}";
  //   return DateTime.parse(datetime).millisecondsSinceEpoch.toString();//add(Duration(hours: 2)).
  // }
  getData() async {
    bool getting = true;
    for(var row in data){
      if(DateFormat("yyyy-MM-dd").format(DateTime.parse(row.time!)).toString() == DateFormat("yyyy-MM-dd").format(DateTime.parse(_selectedDay.toString())).toString()){
        getting = false;
      }else{
        getting = true;
      }
    }
    if(getting){
      setState(() => _isLoading = true);
      var response =await _patientDetails.getAllFoodAgendas(
          context.read<UserData>().token,
          widget.pid,
          DateFormat("yyyy-MM-dd").format(DateTime.parse(_selectedDay.toString())).toString()
      );
      data.clear();
      for(var row in response){
        print(DateFormat("yyyy-MM-dd").format(DateTime.parse(row['timestamp'])).toString());
        data.add(
            Agenda(
                id: row['id'],
                name: row['name'],
                amount: row['amount'],
                note: row['notes'],
                mealData: row['meal_details'],
                time: row['timestamp'],
                type: int.parse(row['agenda_type'])
            ));
      }
      setState(() => _isLoading = false);
    }
  }

  getMealNumber(data) {
    int num = 0;
    for (Agenda agenda in data) {
      if (DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(agenda.time!))
          .toString() == DateFormat("yyyy-MM-dd").format(
          DateTime.parse(_selectedDay.toString())).toString()) {
        if (agenda.type == 1) {
          num++;
        }
      }
    }
    return num;
  }

  getAmount(int type, data) {
    num number = 0;
    for (Agenda agenda in data) {
      if (DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(agenda.time!))
          .toString() == DateFormat("yyyy-MM-dd").format(
          DateTime.parse(_selectedDay.toString())).toString()) {
      if (agenda.type == type) {
        number += agenda.amount!;
      }
    }
  }
    return number.toInt();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ScreenContainer(
          topLeftAction: BackIcon(),
          name: "FoodAgenda".tr(),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 18),
            height: MediaQuery.of(context).size.height*0.79,
            child: ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      TableCalendar(
                        headerStyle: HeaderStyle(
                            leftChevronVisible: false,
                            rightChevronVisible: false,
                            formatButtonVisible: false,
                            formatButtonShowsNext: false,
                            headerMargin: EdgeInsets.only(left: 15),
                            // titleTextStyle: Constants.secondTheardSmallTextNormal,
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
                                color: Constants.secondColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10)),
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
                          // Use `selectedDayPredicate` to determine which day is currently selected.
                          // If this returns true, then `day` will be marked as selected.

                          // Using `isSameDay` is recommended to disregard
                          // the time-part of compared DateTime objects.
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            // Call `setState()` when updating the selected day
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                            getData();
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
                    ],
                  ),
                ),
                Divider(
                  height: 4,
                  color: Colors.black,
                  thickness: 0.2,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Meals".tr(),
                                style: Constants.regularTextNormal,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${getMealNumber(data)}",
                                // style: Constants.secondsmallTextBookScreen,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("Butter".tr(), style: Constants.regularTextNormal),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${getAmount(1, data)}${LocaleKeys.gm.tr()}",
                                // style: Constants.secondsmallTextBookScreen,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("Walking".tr(), style: Constants.regularTextNormal),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${getAmount(3, data)}${"Min".tr()}",
                                // style: Constants.secondsmallTextBookScreen,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("Water".tr(), style: Constants.regularTextNormal),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${getAmount(2, data)}${"L".tr()}",
                                // style: Constants.secondsmallTextBookScreen,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
                  child: Divider(
                    height: 4,
                    color: Colors.black,
                    thickness: 0.2,
                  ),
                ),
                if (_isLoading != true)
                  for (int i = 0; i < data.length; i++)
                    AgendaContainer(
                      agenda: data[i],
                      selectedDay: _selectedDay.toString(),
                    )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(child: CustomLoading()),
                  )
              ],
            ),
          ),
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
