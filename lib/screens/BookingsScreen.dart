import 'dart:collection';
import 'package:fanan_elrashaka_admin/networks/Bookings.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AddDrPationt.dart';
import 'package:fanan_elrashaka_admin/screens/SelectDoctorPatient.dart';
import 'package:fanan_elrashaka_admin/screens/SelectPatient.dart';
import 'package:fanan_elrashaka_admin/widgets/BookingsCard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/CustomAnimSearchBar.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchList.dart';
import 'package:fanan_elrashaka_admin/widgets/SearchWithBack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:table_calendar/table_calendar.dart';
class BookingsScreen extends StatefulWidget {

  const BookingsScreen({Key? key,}) : super(key: key);
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  String? fromDate , toDate;
  Bookings _bookings = Bookings();
  String? clinic;
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  TextEditingController textController = TextEditingController();
  bool openSearch = false;
  String? _searchValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _clinics = context.read<ClinisData>().clinicsName;

  }
  getClinic(){
    List<Map<String,dynamic>> _clinics = [];
    context.read<ClinisData>().clinicsName.forEach((element) {
      _clinics.add({
        'value':element.id.toString(),
        'label':element.name.toString(),
      });
    });
    return _clinics;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenContainer(
          name: "Bookings",
          topCenterAction: AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 10),
            height: 80,
            margin:const EdgeInsets.only(left: 15,right: 15,),
            decoration: BoxDecoration(
              color: !openSearch?Constants.mainColor:Colors.transparent,
              borderRadius:const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                if(!openSearch)
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
                Visibility(
                  visible: !openSearch,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: (){
                        _bottomSheetWidget.showBottomSheetButtons(
                            context,
                            180.0,
                            const Text("Add New Patient",style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                            [
                              ListTile(
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>AddDrPationt())
                                  );
                                },
                                dense: true,
                                leading: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/add_patient.png"),
                                ),
                                title:Text("New Patient",style: TextStyle(
                                    color: Constants.secondTextColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal
                                ),),
                              ),
                              const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                              ListTile(
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>SelectPatient())
                                  );
                                },
                                dense: true,
                                leading: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/add_patient.png"),
                                ),
                                title:Text("Existing Patient",style: TextStyle(
                                    color: Constants.secondTextColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal
                                ),),
                              ),
                            ]
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
                            child: Image.asset("assets/booking_add_patient.png"),
                          ),
                          Text("New Patient",style: TextStyle(
                              color: Constants.secondTextColor,
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !openSearch,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: InkWell(
                      onTap: (){
                        _bottomSheetWidget.showBottomSheetButtons(
                            context,
                            180.0,
                            const Text("Make New Payment",style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                            [
                              ListTile(
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>SelectDrPatient(is_new_booking: true,))
                                  );
                                },
                                dense: true,
                                leading: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/bookings_active.png"),
                                ),
                                title:Text("New Booking",style: TextStyle(
                                    color: Constants.secondTextColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                              const Divider(thickness: 0.6,indent: 10,endIndent: 10,),
                              ListTile(
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>SelectDrPatient(is_new_booking: false,))
                                  );
                                },
                                dense: true,
                                leading: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/package.png"),
                                ),
                                title:Text("Package Purchase",style: TextStyle(
                                    color: Constants.secondTextColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ]
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration:const BoxDecoration(
                              color: Color(0xffffddde),
                              borderRadius:BorderRadius.all(Radius.circular(13)),
                            ),
                            width: 45,
                            height: 45,
                            padding:const EdgeInsets.all(8),
                            child: Image.asset("assets/booking_payment.png"),
                          ),
                          Text("New Payment",style: TextStyle(
                              color: Constants.secondTextColor,
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !openSearch,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        openSearch = !openSearch;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration:const BoxDecoration(
                            color: Color(0xffcafbff),
                            borderRadius:BorderRadius.all(Radius.circular(13)),
                          ),
                          width: 45,
                          height: 45,
                          padding:const EdgeInsets.all(8),
                          child: Image.asset("assets/booking_search.png"),
                        ),
                        Text("Search",style: TextStyle(
                            color: Constants.secondTextColor,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: openSearch,
                  child:SearchWithBack(
                    onBack: (){
                      setState(() {
                        openSearch = !openSearch;
                        _searchValue = "";
                      });
                    },
                    onSubmitted: (value){
                      setState(() {
                        _searchValue = value;
                      });
                    },
                    onSearchClick: (value){
                      setState(() {
                        _searchValue = value;
                      });
                    },
                  )
                )
              ],
            ),
          ),
          child: Expanded(
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 5,),
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
                              selectedTextStyle: TextStyle(
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
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          width: 150,
                          height: 50,
                          child: buildSelect()
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 4,
                  color: Colors.black,
                  thickness: 0.2,
                ),
                FutureBuilder(
                    future: (_searchValue == "")?_bookings.getBooks(context.read<UserData>().token, _selectedDay.toString().split(" ")[0],clinic):_bookings.getBooksSearch(context.read<UserData>().token, _selectedDay.toString().split(" ")[0],clinic,_searchValue),
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
                                      child:BookingCard(
                                        clinic_id:clinic.toString(),
                                        snapshot: snapshot.data[index],
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
  SelectFormField buildSelect(){
    return SelectFormField(
      type: SelectFormFieldType
          .dropdown, // or can be dialog
      items: getClinic(),
      initialValue: context.read<ClinisData>().clinicsService.first.id,
      style: TextStyle(color: Constants.secondColor,fontWeight: FontWeight.bold,),
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        suffixIcon: Container(
            padding:const EdgeInsets.all(18),
            width: 10,
            height: 10,
            child: Image.asset(
                "assets/dropdown_arrow.png")),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
        border: InputBorder.none,

      ),
      onSaved: (newValue){
        setState(() {
          clinic= newValue;
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            clinic = value;
            print(clinic);
          });
        }
        return null;
      },
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
