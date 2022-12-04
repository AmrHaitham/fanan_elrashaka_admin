import 'dart:convert';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/screens/EditDrPationt.dart';
import 'package:fanan_elrashaka_admin/screens/ImageScreen.dart';
import 'package:fanan_elrashaka_admin/screens/MeasurementsScreen.dart';
import 'package:fanan_elrashaka_admin/screens/PatientProfileTab.dart';
import 'package:fanan_elrashaka_admin/screens/PurchasesScreen.dart';
import 'package:fanan_elrashaka_admin/screens/VisitationNoteScreen.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/BottomSheet.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../networks/ApisEndPoint.dart';
import '../providers/UserData.dart';

class PationtProfile extends StatefulWidget {
  final String pid;

  PationtProfile({Key? key,required this.pid}) : super(key: key);

  @override
  State<PationtProfile> createState() => _PationtProfileState();
}

class _PationtProfileState extends State<PationtProfile> {
  PatientDetails _patientDetails = PatientDetails();
  final Dialogs _dialogs = Dialogs();
  final ImagePicker _picker = ImagePicker();
  BottomSheetWidget _bottomSheetWidget = BottomSheetWidget();
  String? date ;
  TextEditingController? _controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _patientDetails.getAllPatients(context.read<UserData>().token, widget.pid.toString()),
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
              return EditScreenContainer(
                name: "Patient Profile",
                topLeftAction:const BackIcon(),
                topRightaction: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditDrPationt(id: widget.pid,))
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 35,
                    height: 35,
                    decoration:  BoxDecoration(
                        color: Constants.mainColor,
                        borderRadius:const BorderRadius.all(Radius.circular(7))
                    ),
                    child: Icon(Icons.edit,color: Constants.secondColor,size: 30,),
                  ),
                ),
                topCenterAction: Container(
                    height: 72,
                    width: MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                      color:Constants.mainColor,
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
                  child: ListTile(
                    leading: (snapshot.data['patient_image']==null)
                        ? const CircleAvatar(backgroundImage: AssetImage("assets/user_avatar_male.png"),)
                        : SizedBox(
                          width: 50,
                          height: 70,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage("${Apis.api}${snapshot.data['patient_image']}")
                      ),
                    ),
                    title: Text('${snapshot.data['name']??"---"}',style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${snapshot.data['phone']??"---"}",style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Constants.secondTextColor
                        ),),
                        Text(
                          "${snapshot.data['pid']}  |  ${
                              (int.parse(DateTime.now().toString().split('-').first) - int.parse(snapshot.data['birthday'].toString().split('-')[0])).toString()
                          } Years  |  ${(snapshot.data['gender'].toString()=="M")?"Male":"Female"}",style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Constants.secondTextColor
                        ),),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: ()async{
                        EasyLoading.show(status: "Changing connect status");
                        var response = await _patientDetails.updateConnetcStatus(
                            context.read<UserData>().token,
                            snapshot.data['pid'].toString(),
                            snapshot.data['is_connected']?'0':'1'
                        );

                        if (await response.statusCode == 200) {
                          EasyLoading.showSuccess("Done Changing connect status");
                          setState(() {});
                        }else{
                          print(response);
                          // if(response["error"] == "702"){
                          // _dialogs.errorDialog(context, "user already exists");}
                        }
                        EasyLoading.dismiss();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration:  BoxDecoration(
                            color: (snapshot.data['is_connected']==true)?const Color(0xffe9dfff):const Color(0xffe1daf1),
                            borderRadius:const BorderRadius.all(Radius.circular(7))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/connection_active.png",color: (snapshot.data['is_connected']==true)?Constants.secondColor :const Color(0xffe9dfff),),
                        ),
                      ),
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 15,right: 15),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Patient Info",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),),
                      const SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text("Weight",style: TextStyle(color: Constants.secondTextColor,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 2,),
                              Text((snapshot.data['last_weight'] == null)?"---":"${snapshot.data['last_weight'].toString().split('.')[0]} kg",style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          Column(
                            children: [
                              Text("Height",style: TextStyle(color: Constants.secondTextColor,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 2,),
                              Text((snapshot.data['height'] == null)?"---":"${snapshot.data['height'].toString().split('.')[0]} cm",style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          Column(
                            children: [
                              Text("Last Visitation Date",style: TextStyle(color: Constants.secondTextColor,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 2,),
                              Text((snapshot.data['last_visitation_date'] == null)?"---":"${snapshot.data['last_visitation_date'].toString().split('T')[0]}",style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.5,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: (snapshot.data["is_penalized"])?const Color(0xffd2d2d2):Constants.secondColor ,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children:[
                                     Text(
                                       (snapshot.data["is_penalized"])
                                           ?"unpenalized the patient"
                                           :"Penalized the patient",
                                      style: TextStyle(
                                        color: (snapshot.data["is_penalized"])?const Color(0xffe1daf1) :Colors.white
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: ()async{
                                EasyLoading.show(status: "Changing Penalized Status");
                                var response = await _patientDetails.updateIsPenalized_status(
                                    context.read<UserData>().token,
                                    snapshot.data['pid'].toString(),
                                );

                                if (await response.statusCode == 200) {
                                  EasyLoading.showSuccess("Done Changing Penalized Status");
                                  setState(() {});
                                }else{
                                  print(response);
                                }
                                EasyLoading.dismiss();
                              },
                            ),
                            InkWell(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:const Color(0xfffff2d0),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.asset("assets/diet_image.png",color: Color(0xffefaa43),)
                                ),
                              ),
                              onTap: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ImageScreen(
                                        name: "Diet Image", imageUrl: snapshot.data['diet_image'].toString(),
                                        uploadButton: ()async{
                                          var imagePicker;
                                          imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                                          String imageLocation = imagePicker.path.toString();
                                          EasyLoading.show(status: "Upload Diet Image");
                                          var picResponse =await _patientDetails.uploadDietImage(
                                              context.read<UserData>().token,
                                              snapshot.data['pid'].toString(),
                                              imageLocation
                                          );
                                          if (await picResponse.statusCode == 200) {
                                            _dialogs.doneDialog(context,"You_are_successfully_Upload_Diet_Image","ok",(){
                                              Navigator.pop(context);
                                              setState(() {});
                                            });
                                          }else{
                                            print(await picResponse.stream.bytesToString());
                                            _dialogs.errorDialog(context,"Error_while_Uploading_Diet_Image_data_check_your_interne_connection");
                                          }
                                          EasyLoading.dismiss();
                                        },
                                      )
                                    )
                                );
                              },
                            ),
                            InkWell(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color:const Color(0xffc3f0fe),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.asset("assets/application_image.png",)
                                ),
                              ),
                              onTap: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ImageScreen(
                                      name: "Application Image", imageUrl: snapshot.data['application_image'].toString(),
                                      uploadButton: ()async{
                                        var imagePicker;
                                        imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                                        String imageLocation = imagePicker.path.toString();
                                        EasyLoading.show(status: "Upload Application Image");
                                        var picResponse =await _patientDetails.uploadAppImage(
                                            context.read<UserData>().token,
                                            snapshot.data['pid'].toString(),
                                            imageLocation
                                        );
                                        if (await picResponse.statusCode == 200) {
                                          _dialogs.doneDialog(context,"You_are_successfully_Upload_ApplicationImage","ok",(){
                                            Navigator.pop(context);
                                            setState(() {});
                                          });
                                        }else{
                                          print(await picResponse.stream.bytesToString());
                                          _dialogs.errorDialog(context,"Error_while_Uploading_Application_Image_data_check_your_interne_connection");
                                        }
                                        EasyLoading.dismiss();
                                      },
                                    )
                                    )
                                );
                              },
                            ),
                            InkWell(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color:Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.asset("assets/pay_in_cash.png",)
                                ),
                              ),
                              onTap: (){
                                _controller = TextEditingController(text: snapshot.data['pay_in_cash_until']);
                                _bottomSheetWidget.showBottomSheetButtons(
                                    context, 200.0, const Text(""),
                                  [
                                    buildDateFormField(),
                                    const SizedBox(height: 20,),
                                    DefaultButton(
                                      text: "Update Pay In Cash Status",
                                      press: ()async{
                                        EasyLoading.show(status: "Updating Pay In Cash Status");
                                        var response = await _patientDetails.change_pay_in_cash_status(
                                            context.read<UserData>().token,
                                            snapshot.data['pid'].toString(),
                                            _controller!.text
                                        );
                                        var data = jsonDecode(await response.stream.bytesToString());
                                        if (await response.statusCode == 200) {
                                          print(data);
                                          EasyLoading.showSuccess("Done Updating Pay In Cash Status");
                                          Navigator.pop(context);
                                          setState(() {});
                                        }else{
                                          print(data);
                                          if(response["error"] == "721"){
                                          _dialogs.errorDialog(context, "patient is not connected");
                                          }
                                        }
                                        EasyLoading.dismiss();
                                      },
                                    )
                                  ]
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width:double.infinity,
                        height: MediaQuery.of(context).size.height*0.6,
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  PatientProfileTab(
                                    color: Color(0xfffff2d0),
                                    name: "Food Agenda[Soon]",
                                    image: "food_agenda.png",
                                  ),
                                  const SizedBox(width: 5,),
                                  PatientProfileTab(
                                    color: Color(0xffb4f2ff),
                                    name: "Measurements[Soon]",
                                    image: "measures.png",
                                    onTap: (){
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(builder: (context) => MeasurementsScreen(pid: widget.pid,))
                                      // );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children:  [
                                  PatientProfileTab(
                                    color: Color(0xffffcaf0),
                                    name: "Purchases",
                                    image: "cart.png",
                                    onTap: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => PurchasesScreen(pid: widget.pid,))
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 5,),
                                  PatientProfileTab(
                                    color: Color(0xffb0ffac),
                                    name: "Visitation Notes",
                                    image: "notes.png",
                                    onTap: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => VisitationNoteScreen(pid: widget.pid,))
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
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
    );
  }
  buildDateFormField(){
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        BottomPicker.date(
          title: "Pay In Cash To",
          dateOrder: DatePickerDateOrder.dmy,
          pickerTextStyle:const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          titleStyle:const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.blue,
          ),
          onChange: (index) {
            // print(index);
          },
          onSubmit: (index) {
            date = index!.toString().split(" ")[0];
            _controller!.text = date!;
          },
          bottomPickerTheme: BottomPickerTheme.blue,
        ).show(context);
      },
      onSaved: (newValue) => date = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          return null;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "kDateNullError" ;
        }
        return null;
      },
    );
  }
}
