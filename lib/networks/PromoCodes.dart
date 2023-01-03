import 'dart:convert';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;
class PromoCodes {
  getAllPromoCodes(token) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var response = await http.get(
        Uri.parse("${Apis.promocodes}"), headers: headers);
    // return jsonDecode(utf8.decode(response.bodyBytes));
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  getSearchPromoCodes(token, promocode_name) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var response = await http.get(
        Uri.parse("${Apis.promocodes}?search=$promocode_name"),
        headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  getPromoCode(token, promocode_name) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var response = await http.get(
        Uri.parse("${Apis.promocodes}?edit=$promocode_name"),
        headers: headers);
    print(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  addPromoCode(token, code, from_date, to_date, clinic_service, max_number, fee_after_code) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('POST', Uri.parse("${Apis.promocodes}"));

    request.fields.addAll({
      'code': code,
      'from_date': from_date,
      'to_date': to_date,
      'clinic_service': clinic_service,
      'max_number': max_number.toString(),
      'fee_after_code': fee_after_code,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }

  updatePromoCode(token, code, from_date, to_date, clinic_service, max_number, fee_after_code) async {
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.promocodes}"));
    request.fields.addAll({
      'code': code,
      'from_date': from_date,
      'to_date': to_date,
      'clinic_service': clinic_service,
      'max_number': max_number,
      'fee_after_code': fee_after_code,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }

  deletePromoCode(token,code)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('DELETE', Uri.parse("${Apis.promocodes}"));

    request.fields.addAll({
      'code':code,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
}