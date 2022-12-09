import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/Dialogs.dart';
import 'package:fanan_elrashaka_admin/models/Clinic.dart';
import 'package:fanan_elrashaka_admin/networks/Users.dart';
import 'package:fanan_elrashaka_admin/providers/ClinicsData.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/widgets/AddProfilePhoto.dart';
import 'package:fanan_elrashaka_admin/widgets/BackIcon.dart';
import 'package:fanan_elrashaka_admin/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_admin/widgets/EditScreenContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/ProfilePic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
class EditUser extends StatefulWidget {
  final id ;

  const EditUser({Key? key, this.id}) : super(key: key);
  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final Dialogs _dialogs = Dialogs();

  final Users _users = Users();

  final _formKey = GlobalKey<FormState>();

  String? email;

  String? oldPassword;

  String? password;

  String? conform_password;

  String? fullName;

  String? phoneNumber;

  String? imageLocation ;

  String? clinics;

  final ImagePicker _picker = ImagePicker();

  static List<Clinic> _clinics = [];

  List<MultiSelectItem<Object?>> _items = [];

  List<dynamic?> _selectedClinics = [];

  bool? _switchValue ;

  final _passwordFormKey = GlobalKey<FormState>();

  bool _isLoading = false;

  initClinicsData(initClinics){
    List<MultiSelectItem<Object?>> _items = [];
    List<Clinic> clinicsName = [];
    for(var clinic in initClinics){
      Clinic clinicModel =Clinic();
      clinicModel.id=clinic["id"].toString();
      clinicModel.name=clinic["clinic_en"];
      clinicsName.add(clinicModel);
    }
    _items = _clinics
        .map((clinic) => MultiSelectItem<Clinic>(clinic, clinic.name!))
        .toList();
    return _items;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _clinics = context.read<ClinisData>().clinicsName;
    _items = _clinics
        .map((clinic) => MultiSelectItem<Clinic>(clinic, clinic.name!))
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _users.getSearchAllUsers(context.read<UserData>().token, widget.id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // error in data
              print(snapshot.error.toString());
              return  Container();
            } else if (snapshot.hasData) {
              print(snapshot.data);
              return EditScreenContainer(
                  name: "Edit System User",
                  topLeftAction: BackIcon(),
                  topRightaction: InkWell(
                    onTap: ()async{
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        EasyLoading.show(status: "Edit System User");
                        var responseData = await _users.updateSystemUser(
                            context.read<UserData>().token,
                            email,
                            fullName,
                            phoneNumber,
                            imageLocation??"",
                            clinics??"",
                            _switchValue
                        );
                        if (await responseData.statusCode == 200) {
                          _dialogs.doneDialog(context,"You_are_successfully_update_user","ok",(){
                            setState(() {
                              _formKey.currentState!.reset();
                            });
                          });
                        }else{
                          var response = jsonDecode(await responseData.stream.bytesToString());
                          print(response);
                          _dialogs.errorDialog(context, "Error_while_updating_user_please_check_your_internet_connection");
                        }
                        EasyLoading.dismiss();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 25,
                      height: 25,
                      child: Image.asset("assets/Save-512.png"),
                    ),
                  ),
                  topCenterAction: ProfilePic(
                    profile: snapshot.data[0]['image'].toString(),
                    uploadImage: () async{
                      EasyLoading.show(status: "Updating Patient Image");
                      var imagePicker;
                      imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                      String imageLocation = imagePicker.path.toString();
                      var picResponse =await _users.updateSystemUserImage(
                          context.read<UserData>().token,
                          snapshot.data[0]["email"],
                          snapshot.data[0]["name"],
                          snapshot.data[0]["phone"],
                          imageLocation,
                          snapshot.data[0]["clinics"],
                          _switchValue
                      );
                      if (await picResponse.statusCode == 200) {
                        _dialogs.doneDialog(context,"You_are_successfully_change_your_profile_picture","ok",(){});
                      }else{
                        print(await picResponse.stream.bytesToString());
                        _dialogs.errorDialog(context,"Error_while_updating_picture_profile_data_check_your_interne_connection");
                      }
                      EasyLoading.dismiss();
                      setState(() {
                      });
                    },
                  ),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.715,
                    padding: const EdgeInsets.only(right: 15,left: 15),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            buildFirstNameFormField(snapshot.data[0]["name"]),
                            const SizedBox(height: 20),
                            buildEmailFormField(snapshot.data[0]["email"]),
                            const SizedBox(height: 20),
                            buildPhoneNumberFormField(snapshot.data[0]["phone"]),
                            const SizedBox(height: 20),
                            buildMultiSelect(),
                            // buildNewMuiltiSelectClinic(),
                            const SizedBox(height: 10),
                            buildIsUserActive(snapshot.data[0]["is_active"]),
                            const SizedBox(height: 10),
                            const Divider(height: 5,color: Colors.black,thickness: 0.8,),
                            const SizedBox(height: 20),
                            changePassword(context,snapshot.data[0]['email']),
                            const SizedBox(height: 20),
                            Card(
                              color:const Color(0xffff5d63),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset("assets/delete.png"),
                                ),
                                title: Text("Delete Account",style: TextStyle(
                                    color: Constants.mainColor,
                                    fontWeight: FontWeight.bold
                                ),),
                                trailing: SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: Image.asset("assets/right-arrow_gray.png",color: Colors.white,),
                                ),
                                onTap: (){
                                  AwesomeDialog(
                                      context: context,
                                      animType: AnimType.SCALE,
                                      dialogType: DialogType.WARNING,
                                      body:const Center(child: Text(
                                        "Are you sure you want to delete this account",
                                      ),),
                                      btnOkOnPress: () async{
                                        var response = await _users.deleteSystemUser(context.read<UserData>().token, snapshot.data[0]['email']);
                                        if (await response.statusCode == 200) {
                                          print(await response.stream.bytesToString());
                                          Navigator.pop(context);
                                        }
                                      },
                                      btnCancelOnPress: (){},
                                      btnCancelText:"Cancel",
                                      btnOkText:"Delete"
                                  ).show();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
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
  buildIsUserActive(initIsActive){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding:  EdgeInsets.all(8.0),
          child:  Text("Is User Active:",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        CupertinoSwitch(
          trackColor: Colors.grey,
          activeColor: Constants.secondColor,
          value: _switchValue??initIsActive,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
          },
        ),
      ],
    );
  }
  buildMultiSelect(){
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
      buttonText: const Text("Active Clinics",),
      title:const Text("Clinics",style: TextStyle(
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
      cancelText:const Text("Cancel"),
      confirmText:const Text("Select"),
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
  TextFormField buildEmailFormField(initEmail) {
    return TextFormField(
      initialValue: initEmail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          email = value;
        } else if (Constants.emailValidatorRegExp.hasMatch(value)) {
          email = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kEmailNullError;
        } else if (!Constants.emailValidatorRegExp.hasMatch(value)) {
          return Constants.kInvalidEmailError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Email",
        hintText: "Enter_your_email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildFirstNameFormField(initFullName) {
    return TextFormField(
      initialValue: initFullName,
      onSaved: (newValue) => fullName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          fullName = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "kNamelNullError";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Full Name*",
        hintText: "Enter_your_full_name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildPhoneNumberFormField(initPhoneNumber) {
    return TextFormField(
      initialValue: initPhoneNumber,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "Phone_Number",
        hintText:"Enter_your_phone_number",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (newValue) {
        phoneNumber = newValue;
      } ,
      onChanged: (value) {
        if (value != "") {
          phoneNumber = value;
        }
        return null;
      },
      validator: (value) {
        if (value=="") {
          return "kPhoneNumberNullError";
        }
        return null;
      },
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          password = value;
        } else if (value.length >= 8) {
          password = value;
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if (value.length < 8) {
          return Constants.kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: "New_Password",
        hintText: "Enter_your_password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          conform_password = value;
        } else if (value.isNotEmpty && password == conform_password) {
          conform_password = value;
        }
        conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if ((password != value)) {
          return Constants.kMatchPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: "Confirm_New_Password",
        hintText: "Re_enter_your_password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextField changePassword(context,account){
    return TextField(
      decoration: InputDecoration(
        suffixIcon:const SizedBox(
          width: 10,
          height: 10,
          child: Icon(Icons.arrow_forward_ios),
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(5.0),
        ),
        hintText: "Change Password",
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
      ),
      readOnly: true,
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor:
            Colors.transparent,
            builder:
                (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(
                        context)
                        .viewInsets
                        .bottom),
                child:
                SingleChildScrollView(
                  child: Form(
                    key: _passwordFormKey,
                    child: Container(
                      padding:
                      const EdgeInsets
                          .all(20),
                      height: MediaQuery.of(
                          context)
                          .size
                          .height *
                          0.4,
                      decoration: const BoxDecoration(
                          color:
                          Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius
                                  .circular(
                                  15),
                              topRight: Radius
                                  .circular(
                                  15))),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                // buildOldPasswordFormField(),
                                // const SizedBox(height: 20),
                                buildPasswordFormField(),
                                const SizedBox(height: 20),
                                buildConformPassFormField(),
                              ],
                            ),
                          ),
                          DefaultButton(
                            loading: _isLoading,
                            text: "Change",
                            press: () async{
                              if (_passwordFormKey.currentState!.validate()) {
                                _passwordFormKey.currentState!.save();
                                setState(() {
                                  _isLoading = true;
                                });
                                var changeResponse = await _users.updateSystemUserPassword(
                                    context.read<UserData>().token,
                                    account,
                                    password
                                );
                                if (await changeResponse.statusCode == 200) {
                                  print(await changeResponse.stream.bytesToString());
                                  _dialogs.doneDialog(context,"You_are_successfully_change_your_password","ok",(){
                                    Navigator.pop(context);
                                  });
                                }else{
                                  print(await changeResponse.stream.bytesToString());
                                  _dialogs.errorDialog(context, "Error while update password");
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  //----------------------
  // buildNewMuiltiSelectClinic(){
  //   return TextField(
  //     decoration: InputDecoration(
  //       suffixIcon:const SizedBox(
  //         width: 10,
  //         height: 10,
  //         child: Icon(Icons.arrow_forward_ios),
  //       ),
  //       border: OutlineInputBorder(
  //         borderRadius:
  //         BorderRadius.circular(5.0),
  //       ),
  //       hintText: "Active Clinics",
  //       floatingLabelBehavior:
  //       FloatingLabelBehavior.auto,
  //     ),
  //     readOnly: true,
  //     onTap: () {
  //       showModalBottomSheet(
  //           isScrollControlled: true,
  //           context: context,
  //           backgroundColor:
  //           Colors.white,
  //           builder:
  //               (BuildContext context) {
  //             return Container(
  //               height: 400,
  //               width: double.infinity,
  //               decoration:const BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(15))
  //               ),
  //               child: MultiSelectContainer(
  //                   items: [
  //                 MultiSelectCard(value: 'Dart', label: 'Dart'),
  //                 MultiSelectCard(value: 'Python', label: 'Python'),
  //                 MultiSelectCard(value: 'JavaScript', label: 'JavaScript'),
  //                 MultiSelectCard(value: 'Java', label: 'Java'),
  //                 MultiSelectCard(value: 'C#', label: 'C#'),
  //                 MultiSelectCard(value: 'C++', label: 'C++'),
  //                 MultiSelectCard(value: 'Go Lang', label: 'Go Lang'),
  //                 MultiSelectCard(value: 'Swift', label: 'Swift'),
  //                 MultiSelectCard(value: 'PHP', label: 'PHP'),
  //                 MultiSelectCard(value: 'Kotlin', label: 'Kotlin')
  //               ], onChange: (allSelectedItems, selectedItem) {}),
  //             );
  //           });
  //     },
  //   );
  // }
}