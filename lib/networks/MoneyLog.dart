import 'dart:convert';

import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;

class MoneyLog{
  getAllMoneyLogs(token,date)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.finance}?date=$date"),headers: headers);
    print('token is = ${token}, date is = ${date}');
    print("mony logs = ${response.body}");
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getMoneyLog(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.finance}?edit=$id"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  addMoneyLog(token,name, category_id, amount, log_type, notes, clinic_id)async{
    String time = DateTime.now().toString().split(" ")[0];
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('POST', Uri.parse("${Apis.finance}"));
    request.fields.addAll({
      'name': name,
      'category_id':category_id,
      'amount': amount,
      'log_type': log_type,
      'notes': notes,
      'clinic_id': clinic_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  editMoneyLog(token,id, name, category_id, amount, log_type, notes, clinic_id)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.finance}"));
    request.fields.addAll({
      "id":id, "name":name, "category_id":category_id,
      "amount":amount, "log_type":log_type, "notes":notes, "clinic_id":clinic_id
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  deleteMoneyLog(token,id)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('DELETE', Uri.parse("${Apis.finance}"));
    request.fields.addAll({
      "id":id,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }

}

