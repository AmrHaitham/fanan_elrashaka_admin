import 'dart:convert';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;

class Bookings{

  getBooks(token,date,clinic_id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.bookings}$date/$clinic_id"),headers: headers);
    print("token:-${token} , date:- ${date} , clinic_id :- ${clinic_id}");
    print("bookings = ${response.body}");
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  getBooksSearch(token,date,clinic_id,search_data)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.bookings}$date/$clinic_id/?search=$search_data"),headers: headers);
    print("bookings search = ${response.body}");
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  getReschedule(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.reschedule_booking}$id/"),headers: headers);
    return jsonDecode(response.body);
  }

  rescheduleBook(token,id,time)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.reschedule_booking}$id/"));
    request.fields.addAll({
      'time_slot': time.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }

  updateBookingData(token,id,clinic_id,time,paid,done)async{
    var headers = {
      'Authorization': 'Token $token'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.bookings}$time/$clinic_id/'));
    request.fields.addAll({
      'id': id.toString(),
      'paid': paid,
      'done': done
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }

  deleteBooking(token,id,time)async{
    var headers = {
      'Authorization': 'Token $token'
    };
    var request = http.MultipartRequest('DELETE', Uri.parse('${Apis.bookings}$time/$id/'));
    request.fields.addAll({
      'id': id.toString(),
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }

  newBooking(token,clinic_time,clinic_service,booking_time,doctor_patient,payment_method,paid_amount)async{
    var headers = {
      'Authorization': 'Token $token'
    };
    // var request = http.MultipartRequest('POST', Uri.parse("${Apis.new_bookings}$clinic_time/$clinic_service"));
    // request.fields.addAll({
    //   'booking_time': booking_time,
    //   'doctor_patient': doctor_patient,
    //   'payment_method': payment_method,
    //   'paid_amount': paid_amount
    // });
    // request.headers.addAll(headers);
    //
    // // http.StreamedResponse response = await request.send();
    print("$clinic_time,$clinic_service,$booking_time,$doctor_patient,$payment_method,$paid_amount");
    var response = http.post( Uri.parse("${Apis.new_bookings}$clinic_time/$clinic_service/"),headers: headers,
        body: {
          'booking_time': booking_time,
          'doctor_patient': doctor_patient,
          'payment_method': payment_method,
          'paid_amount': paid_amount
        });
    return response;
  }

  get_next_available_time(token,clinic_time,clinic_service)async{
    var headers = {
      'Authorization': 'Token $token'
    };
    var request = http.MultipartRequest('GET', Uri.parse("${Apis.new_bookings}$clinic_time/$clinic_service"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  get_clinic_calendar(token,clinic_service)async{
    print(clinic_service);
    var headers = {
      'Authorization': 'Token $token'
    };
    var request = http.MultipartRequest('GET', Uri.parse("${Apis.clinic_calendar}$clinic_service/"));

    request.headers.addAll(headers);


    http.StreamedResponse response = await request.send();

    return jsonDecode(await response.stream.bytesToString());
  }



}