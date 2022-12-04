import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ApisEndPoint.dart';


class UserProfile{

  getUserProfileData(email,token)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('GET', Uri.parse('${Apis.userProfileEndPoint}${email}/'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return jsonDecode(await response.stream.bytesToString());

  }

  updateUserPassword(email,token,oldPassword,newPassword)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.changeUserPasswordEndPoint}${email}/'));
    request.fields.addAll({
      'new_password': newPassword,
      'old_password': oldPassword
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return jsonDecode(await response.stream.bytesToString());
  }

  updateUserProfile(email,token,name,lastname,phone,birthday,gender,address)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.userProfileEndPoint}${email}/'));
    request.fields.addAll({
      'email': email,
      'first_name': name,
      'last_name': lastname,
      'phone': phone,
      'birthday': birthday,
      'gender': gender,
      'address': address,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return jsonDecode(await response.stream.bytesToString());
  }


  deleteProfile(email,token)async{
    var response =await http.delete(
        Uri.parse("${Apis.deleteEmailEndPoint}${email}/"),
        headers: {
          'authorization': 'Token ${token}'
        }
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }


}