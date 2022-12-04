import 'dart:convert';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;
class Clinics{
  getAllClinicsSchedule(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.clinic_availability}"),headers: headers);
    // return jsonDecode(utf8.decode(response.bodyBytes));
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getSearchClinicSchedule(token,clinic_name)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.clinic_availability}?search=$clinic_name"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  addClinicSchedule(token,clinic,from_hour,to_hour,repeat_from_date,repeat_to_date,day)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('POST', Uri.parse("${Apis.clinic_availability}"));
    request.fields.addAll({
      'clinic':clinic,// '1',
      'from_hour':from_hour,// '16:00',
      'to_hour': to_hour,//'19:00',
      'repeat_from_date': repeat_from_date,//'2022-09-22',
      'repeat_to_date': repeat_to_date,//'2022-10-01',
      'day': day,//'Fri'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  updateClinicSchedule(token,id)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.clinic_availability}"));
    request.fields.addAll({
      'id':id
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
}