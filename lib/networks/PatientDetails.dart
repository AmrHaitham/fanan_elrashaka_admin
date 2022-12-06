import 'dart:convert';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;

class PatientDetails{

  getAllPatients(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.patient_details}$id/"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  updateConnetcStatus(token,pid,connect)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Apis.change_IsConnected_status));
    request.fields.addAll({
      'pid': pid,
      'connected': connect
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  updateIsPenalized_status(token,pid)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Apis.change_IsPenalized_status));
    request.fields.addAll({
      'pid': pid,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  uploadDietImage(token,pid,image)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Apis.upload_diet_image));
    request.fields.addAll({
      'pid': pid,
    });

    request.files.add(await http.MultipartFile.fromPath('diet_image', image));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  uploadAppImage(token,pid,image)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Apis.upload_application_image));
    request.fields.addAll({
      'pid': pid,
    });

    request.files.add(await http.MultipartFile.fromPath('diet_image', image));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  change_pay_in_cash_status(token,pid,pay_in_cash_until)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Apis.change_pay_in_cash_status));
    request.fields.addAll({
      'pid': pid,
      'pay_in_cash': '1',
      'pay_in_cash_until': pay_in_cash_until
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  getAllPatientPurchases(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.patient_purchases}?pid=$id"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  updatePatientPurchases(token,pid,used_amount)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Apis.patient_purchases));
    request.fields.addAll({
      'id': pid,
      'used_amount': used_amount,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  getAllVisitation_notes(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.visitation_notes}?pid=$id"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  addVisitation_note(token,pid,note)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('POST', Uri.parse(Apis.visitation_notes));
    request.fields.addAll({
      'pid': pid,
      'note': note,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  updateVisitation_note(token,pid,note)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Apis.visitation_notes));
    request.fields.addAll({
      'id': pid,
      'note': note,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  deleteVisitation_note(token,pid)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('DELETE', Uri.parse(Apis.visitation_notes));
    request.fields.addAll({
      'id': pid,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  getAllMeasurements(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.measurements}?pid=$id"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  addMeasurement(token,pid,data)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('POST', Uri.parse(Apis.measurements));
    request.fields.addAll({
      'pid': '1',
      'weight': data[0],
      'arms': data[1],
      'chest': data[2],
      'waist': data[3],
      'high_hip': data[4],
      'calves': data[5],
      'thigh': data[6],
      'note': data[7]
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
  updateMeasurement(token,pid,data)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('PUT', Uri.parse(Apis.measurements));
    request.fields.addAll({
      'id': '1',
      'weight': data[0],
      'arms': data[1],
      'chest': data[2],
      'waist': data[3],
      'high_hip': data[4],
      'calves': data[5],
      'thigh': data[6],
      'note': data[7]
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }

  deleteMeasurement(token,pid)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('DELETE', Uri.parse(Apis.measurements));
    request.fields.addAll({
      'id': pid,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;

  }
}