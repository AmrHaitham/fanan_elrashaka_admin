import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/networks/PatientDetails.dart';
import 'package:fanan_elrashaka_admin/screens/EditDrPationt.dart';
import 'package:fanan_elrashaka_admin/screens/FoodAgendaScreen.dart';
import 'package:fanan_elrashaka_admin/screens/ImageScreen.dart';
import 'package:fanan_elrashaka_admin/screens/MeasurementsScreen.dart';
import 'package:fanan_elrashaka_admin/screens/PatientProfileTab.dart';
import 'package:fanan_elrashaka_admin/screens/PurchasesScreen.dart';
import 'package:fanan_elrashaka_admin/screens/SelectPatient.dart';
import 'package:fanan_elrashaka_admin/screens/UploadAppImage.dart';
import 'package:fanan_elrashaka_admin/screens/VisitationNoteScreen.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
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
    return Scaffold(
      body: FutureBuilder(
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
                  name: "PatientProfile".tr(),
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
                      height: 80,
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
                          (context.locale.toString()=="en")?Text(
                            "${snapshot.data['pid']}  |  ${
                                (int.parse(DateTime.now().toString().split('-').first) - int.parse(snapshot.data['birthday'].toString().split('-')[0])).toString()
                            } Years  |  ${(snapshot.data['gender'].toString()=="M")?"Male":"Female"}",style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Constants.secondTextColor
                          ),):Text(
                            "${snapshot.data['pid']}  |  ${
                                (int.parse(DateTime.now().toString().split('-').first) - int.parse(snapshot.data['birthday'].toString().split('-')[0])).toString()
                            } سنه  |  ${(snapshot.data['gender'].toString()=="M")?"Male".tr():"Female".tr().toString().split('*')[0]}",style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Constants.secondTextColor
                          ),),
                        ],
                      ),
                      trailing: InkWell(
                        onTap: ()async{
                          if(snapshot.data['patient_id']!= null){
                            EasyLoading.show(status: "ChangingConnectStatus".tr());
                            var response = await _patientDetails.updateConnetcStatus(
                                context.read<UserData>().token,
                                snapshot.data['pid'].toString(),
                                snapshot.data['is_connected']?'0':'1'
                            );

                            if (await response.statusCode == 200) {
                              EasyLoading.showSuccess("DoneChangingConnectStatus".tr());
                              setState(() {});
                            }else{
                              print(response);
                              // if(response["error"] == "702"){
                              // _dialogs.errorDialog(context, "user already exists");}
                            }
                            EasyLoading.dismiss();
                          }else{
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>SelectPatient(patient_id: snapshot.data['pid'].toString(),))
                            );
                          }
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration:  BoxDecoration(
                              color: (snapshot.data['is_connected']==true)?const Color(0xffe9dfff): Color(0xffD3D3D3),
                              borderRadius:const BorderRadius.all(Radius.circular(7))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("assets/connection_active.png",color: (snapshot.data['is_connected']==true)?Constants.secondColor :Colors.white,),
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
                         Text("PatientInfo".tr(),style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Weight".tr(),style: TextStyle(color: Constants.secondTextColor,fontWeight: FontWeight.bold),),
                                const SizedBox(height: 2,),
                                Text((snapshot.data['last_weight'] == null)?"---":"${snapshot.data['last_weight'].toString().split('.')[0]} kg",style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Height".tr(),style: TextStyle(color: Constants.secondTextColor,fontWeight: FontWeight.bold),),
                                const SizedBox(height: 2,),
                                Text((snapshot.data['height'] == null)?"---":"${snapshot.data['height'].toString().split('.')[0]} cm",style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("LastVisitationDate".tr(),style: TextStyle(color: Constants.secondTextColor,fontWeight: FontWeight.bold),),
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
                                             ?"UnPenalizedThePatient".tr()
                                             :"PenalizedThePatient".tr(),
                                        style: TextStyle(
                                          color: (snapshot.data["is_penalized"])?Colors.white :Colors.white
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: ()async{
                                  if(snapshot.data['patient_id']!= null){
                                    EasyLoading.show(status: "ChangingPenalizedStatus".tr());
                                    var response = await _patientDetails.updateIsPenalized_status(
                                      context.read<UserData>().token,
                                      snapshot.data['pid'].toString(),
                                    );

                                    if (await response.statusCode == 200) {
                                      EasyLoading.showSuccess("DoneChangingPenalizedStatus".tr());
                                      setState(() {});
                                    }else{
                                      print(response);
                                    }
                                    EasyLoading.dismiss();
                                  }else{
                                    AwesomeDialog(
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.WARNING,
                                        body: Center(child: Text("PleaseConnectPatientFirst".tr(),),),
                                        btnOkText:"Ok".tr(),
                                        btnOkOnPress: (){}
                                    )..show();
                                  }
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
                                          pid: snapshot.data['pid'].toString(),
                                          name: "DietImage".tr(), imageUrl: snapshot.data['diet_image'].toString(),
                                          uploadButton: ()async{
                                            var imagePicker;
                                            imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                                            String imageLocation = imagePicker.path.toString();
                                            EasyLoading.show(status: "UploadDietImage".tr());
                                            var picResponse =await _patientDetails.uploadDietImage(
                                                context.read<UserData>().token,
                                                snapshot.data['pid'].toString(),
                                                imageLocation
                                            );
                                            if (await picResponse.statusCode == 200) {
                                              _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){
                                                Navigator.pop(context);
                                                setState(() {});
                                              });
                                            }else{
                                              print(await picResponse.stream.bytesToString());
                                              _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
                                            }
                                            EasyLoading.dismiss();
                                          }, takePicAndUpload: ()async{
                                        var imagePicker;
                                        imagePicker = await _picker.pickImage(source: ImageSource.camera,imageQuality: 20);
                                        String imageLocation = imagePicker.path.toString();
                                        EasyLoading.show(status: "UploadDietImage".tr());
                                        var picResponse =await _patientDetails.uploadDietImage(
                                            context.read<UserData>().token,
                                            snapshot.data['pid'].toString(),
                                            imageLocation
                                        );
                                        if (await picResponse.statusCode == 200) {
                                          _dialogs.doneDialog(context,LocaleKeys.You_are_successfully_updated_information.tr(),"Ok".tr(),(){
                                            Navigator.pop(context);
                                            setState(() {});
                                          });
                                        }else{
                                          print(await picResponse.stream.bytesToString());
                                          _dialogs.errorDialog(context,LocaleKeys.Error__please_check_your_internet_connection.tr());
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
                                      MaterialPageRoute(builder: (context) => AppImageScreen(
                                          name: "ApplicationImage".tr(),
                                          imageUrl:snapshot.data['application_image'].toString(),
                                          pid: snapshot.data['pid'].toString()
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
                                  if(snapshot.data['patient_id']!= null){
                                    _controller = TextEditingController(text: snapshot.data['pay_in_cash_until']);
                                    _bottomSheetWidget.showBottomSheetButtons(
                                        context, 280.0, const Text(""),
                                        [
                                          buildDateFormField(_controller!.text),
                                          const SizedBox(height: 20,),
                                          DefaultButton(
                                            text: "UpdatePayInCashStatus".tr(),
                                            press: ()async{
                                              if(_controller!.text != ""){
                                                EasyLoading.show(status: "UpdatePayInCashStatus".tr());
                                                var response = await _patientDetails.change_pay_in_cash_status(
                                                    context.read<UserData>().token,
                                                    snapshot.data['pid'].toString(),
                                                    (_controller!.text=="")?"":_controller!.text
                                                );
                                                var data = jsonDecode(await response.stream.bytesToString());
                                                if (await response.statusCode == 200) {
                                                  print(data);
                                                  EasyLoading.showSuccess("DoneUpdatingPayInCashStatus".tr());
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                }else{
                                                  print(data);
                                                  if(response["error"] == "721"){
                                                    _dialogs.errorDialog(context, "PatientIsNotConnected".tr());
                                                  }
                                                }
                                                EasyLoading.dismiss();
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 10,),
                                          DefaultButton(
                                            text: "CancelPayInCash".tr(),
                                            color: Colors.red,
                                            press: ()async{
                                              try{
                                                EasyLoading.show(status: "UpdatePayInCashStatus".tr());
                                                var response = await _patientDetails.cancle_pay_in_cash_status(
                                                  context.read<UserData>().token,
                                                  snapshot.data['pid'].toString(),
                                                );
                                                // var data =await response.stream.bytesToString();
                                                // print(data);
                                                if (await response.statusCode == 200) {
                                                  print(response);
                                                  EasyLoading.showSuccess("DoneUpdatingPayInCashStatus".tr());
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                }else{
                                                  print(response);
                                                  // if(response["error"] == "721"){
                                                  //   _dialogs.errorDialog(context, "PatientIsNotConnected".tr());
                                                  // }
                                                }
                                                EasyLoading.dismiss();
                                              }catch(v){
                                                EasyLoading.dismiss();
                                              }
                                            },
                                          )
                                        ]
                                    );
                                  }else{
                                    AwesomeDialog(
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.WARNING,
                                        body: Center(child: Text("PleaseConnectPatientFirst".tr(),),),
                                        btnOkText:"Ok".tr(),
                                        btnOkOnPress: (){}
                                    )..show();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width:double.infinity,
                          height: MediaQuery.of(context).size.height*0.57,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    PatientProfileTab(
                                      color: Color(0xfffff2d0),
                                      name: "FoodAgenda".tr(),
                                      image: "food_agenda.png",
                                      onTap: (){
                                        if(snapshot.data['patient_id']!= null){
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => FoodAgendaScreen(pid: widget.pid,))
                                          );
                                        }else{
                                          AwesomeDialog(
                                              context: context,
                                              animType: AnimType.SCALE,
                                              dialogType: DialogType.WARNING,
                                              body: Center(child: Text("PleaseConnectPatientFirst".tr(),),),
                                              btnOkText:"Ok".tr(),
                                              btnOkOnPress: (){}
                                          )..show();
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 5,),
                                    PatientProfileTab(
                                      color: Color(0xffb4f2ff),
                                      name: "Measurements".tr(),
                                      image: "measures.png",
                                      onTap: (){
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => MeasurementsScreen(pid: widget.pid,))
                                        );
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
                                      name: "Purchases".tr(),
                                      image: "cart.png",
                                      onTap: (){
                                        if(snapshot.data['patient_id']!= null){
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => PurchasesScreen(pid: widget.pid,patient_name: "${snapshot.data['name']}",))
                                          );
                                        }else{
                                          AwesomeDialog(
                                              context: context,
                                              animType: AnimType.SCALE,
                                              dialogType: DialogType.WARNING,
                                              body: Center(child: Text("PleaseConnectPatientFirst".tr(),),),
                                              btnOkText:"Ok".tr(),
                                              btnOkOnPress: (){}
                                          )..show();
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 5,),
                                    PatientProfileTab(
                                      color: Color(0xffb0ffac),
                                      name: "VisitationNotes".tr(),
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
      ),
    );
  }
  buildDateFormField(initData){
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        suffixText: "Until".tr(),
        hintText: "PayInCashTo".tr(),
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
          initialDateTime: (initData!="")?DateTime.parse(initData):DateTime.now(),
          title: "PayInCashTo".tr(),
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

    );
  }
}
