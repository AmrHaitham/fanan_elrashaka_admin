import 'dart:convert';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;
class Reports{

  getFinance_full_report(token,from_date,to_date,clinics) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('GET', Uri.parse("${Apis.finance_full_report}"));
    request.fields.addAll({
      'from_date': from_date,
      'to_date': to_date,
      'clinics': clinics
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }
  //finance_comparison_report
  getFinance_comparison_report(token,from_date,to_date,clinics,category) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('GET', Uri.parse("${Apis.finance_full_report}"));
    request.fields.addAll({
      'from_date': from_date,
      'to_date': to_date,
      'packages': clinics,
      'categories':category
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }
  //finance_service_report
  getFinance_service_report(token,from_date,to_date,services) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('GET', Uri.parse("${Apis.finance_full_report}"));
    request.fields.addAll({
      'from_date': from_date,
      'to_date': to_date,
      'services': services,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }
}