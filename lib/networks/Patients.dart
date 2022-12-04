import 'dart:convert';

import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;
class Patients{
  getAllPatients(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.getAllPatients}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getDrPatients(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.getDrPatients}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  getSearchAllPatients(token,String value)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.getAllPatients}?search=${value}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getSearchDrPatients(token,String value)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.getDrPatients}?search=${value}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  getPatient(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.getAllPatients}?id=${id}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  updatePatient(token,email,first_name,last_name,phone_country_code,phone,gender,birthday,address)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.getAllPatients}"));
    request.fields.addAll({
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'phone_country_code': phone_country_code,
      'phone': phone,
      'gender': gender,
      'birthday': birthday,
      'address': address
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
  updatePatientImage(token,email,first_name,last_name,phone_country_code,phone,gender,birthday,address,image)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.getAllPatients}"));
    request.fields.addAll({
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'phone_country_code': phone_country_code,
      'phone': phone,
      'gender': gender,
      'birthday': birthday,
      'address': address
    });
    request.files.add(await http.MultipartFile.fromPath('image', image));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
  getDrPatient(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.getDrPatients}?pid=${id}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  updateDrPatient(token,pid,name,phone,height,target_weight,notes)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.getDrPatients}"));
    request.fields.addAll({
      'pid': pid,
      'name': name,
      'phone': phone,
      'height': height,
      'target_weight': target_weight,
      'notes':notes
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
  updateDrPatientImage(token,pid,name,phone,height,target_weight,image,notes)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.getDrPatients}"));
    request.fields.addAll({
      'pid': pid,
      'name': name,
      'phone': phone,
      'height': height,
      'target_weight': target_weight,
      'notes':notes
    });
    request.files.add(await http.MultipartFile.fromPath('image', image));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
  updatePatientPassword(token,email,new_password)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.updatePatientPassword}${email}/"));
    request.fields.addAll({
      'new_password':new_password,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
  deletePatient(token,email)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('DELETE', Uri.parse("${Apis.deletePatientEndPoint}"));
    request.fields.addAll({
      'email':email,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
  deleteDrPatient(token,pid)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('DELETE', Uri.parse("${Apis.getDrPatients}"));
    request.fields.addAll({
      'pid':pid,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
  addPatient(token,email,first_name,last_name,password,phone_country_code,phone,gender,birthday,address,image)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('POST', Uri.parse("${Apis.addPatient}"));
    request.fields.addAll({
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'password':password,
      'phone_country_code': phone_country_code,
      'phone': phone,
      'gender': gender,
      'birthday': birthday,
      'address': address
    });
    if(image != ""){
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  addDrPatient(token,email,first_name,last_name,password,phone_country_code,phone,gender,birthday,address,image)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('POST', Uri.parse("${Apis.addDrPatient}"));
    request.fields.addAll({
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'password':password,
      'phone_country_code': phone_country_code,
      'phone': phone,
      'gender': gender,
      'birthday': birthday,
      'address': address
    });
    if(image != ""){
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  connectPatient(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.put(Uri.parse("${Apis.connect_patient}"),headers: headers,body: {
      'patient_id': id
    });
    return response;
  }
}
