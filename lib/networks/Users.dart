import 'dart:convert';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;

class Users{
  getAllUsers(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.getAllUsers}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getUser(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.system_users}?id=${id}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getSearchAllUsers(token,String value)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.getAllUsers}?search=${value}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  addSystemUser(token,email,name,password,phone,image,clinics)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('POST', Uri.parse("${Apis.system_users}"));
    request.fields.addAll({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'clinics': clinics,
      'is_active':true.toString(),
    });
    if(image != ""){
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  updateSystemUser(token,email,name,phone,image,clinics,isActive)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.system_users}"));
    request.fields.addAll({
      'name': name,
      'email': email,
      'phone': phone,
      'clinics': clinics,
      'is_active':isActive.toString()
    });
    if(image != ""){
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  deleteSystemUser(token,email)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('DELETE', Uri.parse("${Apis.system_users}"));
    request.fields.addAll({
      'email':email,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  updateSystemUserPassword(token,email,new_password)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.change_system_user_password}${email}/"));
    request.fields.addAll({
      'new_password':new_password,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  updateSystemUserImage(token,email,name,phone,image,clinics,isActive)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.system_users}"));
    request.fields.addAll({
      'name': name,
      'email': email,
      'phone': phone,
      'clinics': clinics,
      'is_active':isActive.toString()
    });
    request.files.add(await http.MultipartFile.fromPath('image', image));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
}