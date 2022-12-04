import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ApisEndPoint.dart';

class FinanceStatistics{

  getFinance_statistics(token,from_date,to_date) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.finance_statistics}?from_date=$from_date&to_date=$to_date"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

}