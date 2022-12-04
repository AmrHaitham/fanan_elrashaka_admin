import 'dart:convert';

import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;

class Categories{
  getAllCategories(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.finance_categories}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}