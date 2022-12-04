import 'dart:convert';

import 'package:http/http.dart' as http;
import 'ApisEndPoint.dart';
class DashBoard {
  getDashboardData(token)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(
        Uri.parse("${Apis.dashboardEndPoint}"),
        headers: headers
    );
    return jsonDecode(await response.body);
  }
}