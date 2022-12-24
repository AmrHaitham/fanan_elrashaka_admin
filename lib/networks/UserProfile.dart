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
    return response;
  }

  updateUserProfile(email,token,name,phone)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.userProfileEndPoint}${email}/'));
    request.fields.addAll({
      'email': email,
      'name': name,
      'phone': phone,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  updateUserProfileImage(email,token,name,phone,image)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.userProfileEndPoint}${email}/'));
    request.fields.addAll({
      'email': email,
      'name': name,
      'phone': phone,
    });

    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('image', image));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }

  deleteProfile(token,email)async{
    var response =await http.delete(
        Uri.parse("${Apis.deleteEmailEndPoint}${email}/"),
        headers: {
          'authorization': 'Token ${token}'
        }
    );
    return response;
  }


}