import 'dart:convert';

import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;
class Services{
  getAllServices(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.services}"),headers: headers);
    return response;
  }
  getAllServicesScreen(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.services}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getServicesSearch(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.services}?search=${id}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getService(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.services}?id=${id}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  updateService(token,id,fee) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.services}"));
    request.fields.addAll({
      'id': id.toString(),
      'fee': fee
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
}