import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MeasurementsScreen extends StatefulWidget {
  final pid;

  const MeasurementsScreen({Key? key, this.pid}) : super(key: key);
  @override
  _MeasurementsScreenState createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  PatientDetails _patientDetails = PatientDetails();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _patientDetails.getAllMeasurements(context.read<UserData>().token, widget.pid),
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
              return ScreenContainer(
                  topLeftAction:const BackIcon(),
                  name: "Measurements",
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.79,
                    margin:const EdgeInsets.only(top: 25),
                    padding:const EdgeInsets.all(5),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return Container();
                        }
                    ),
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
    );
  }
}
