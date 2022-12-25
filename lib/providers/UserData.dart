import 'package:flutter/material.dart';
class UserData with ChangeNotifier{
  String _token = "";

  String get token => _token;

  void setUserToken(String token){
    _token = token;
    notifyListeners();
  }

  String _email = "";

  String get email => _email;

  void setUserEmail(String email){
    _email = email;
    notifyListeners();
  }

  String _name = "";

  String get name => _name;

  void setUserName(String name){
    _name = name;
    notifyListeners();
  }

  String _lastname = "";

  String get lastname => _lastname;

  void setUserLastName(String lastname){
    _lastname = lastname;
    notifyListeners();
  }

  String _phone = "";

  String get phone => _phone;

  void setUserPhone(String phone){
    _phone = phone;
    notifyListeners();
  }

  String _userType = "";

  String get userType => _userType;

  void setUserType(String userType){
    _userType = userType;
    notifyListeners();
  }
}