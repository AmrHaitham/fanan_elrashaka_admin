import 'dart:convert';
import 'package:fanan_elrashaka_admin/networks/ApisEndPoint.dart';
import 'package:http/http.dart' as http;

class Packages{
  getAllPackages(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.packages}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getPackage(token,id)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.packages}?edit=${id.toString()}"),headers: headers);
    print(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
  getSearchAllPackages(token,String value)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.packages}?search=${value}"),headers: headers);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }


  addPackage(token,name_ar,name_en,fee,order,old_fee,package_amount,package_unit,image)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('POST', Uri.parse("${Apis.packages}"));
    Map<String, String> items = {
      'name_ar': name_ar,
      'name_en': name_en,
      'fee': fee,
      'order': order,
      'package_amount': package_amount,
      'package_unit': package_unit
    };
    if(old_fee!=""){
       items['old_fee'] = old_fee;
    }
    request.fields.addAll(items);
    if(image != ""){
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }

  addPackageCopy(token,id,name_ar,name_en,fee,order,old_fee,package_amount,package_unit,image)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.packages}"));
    request.fields.addAll({
      'id' : id.toString(),
      'name_ar': name_ar,
      'name_en': name_en,
      'fee': fee,
      'order': order,
      'old_fee': old_fee,
      'package_amount': package_amount,
      'package_unit': package_unit
    });
    if(image != ""){
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  deletePackage(token,id)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('DELETE', Uri.parse("${Apis.packages}"));
    request.fields.addAll({
      'id':id.toString(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }

  updatePackageImage(token,id,name_ar,name_en,fee,order,old_fee,package_amount,package_unit,image)async{
    var headers = {
      'Authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse("${Apis.packages}"));
    // request.fields.addAll({
    //   'id' : id.toString(),
    //   'name_ar': name_ar.toString(),
    //   'name_en': name_en.toString(),
    //   'fee': fee.toString(),
    //   'order': order.toString(),
    //   'old_fee': old_fee.toString(),
    //   'package_amount': package_amount.toString(),
    //   'package_unit': package_unit.toString()
    // });

    Map<String, String> items = {
      'id' : id.toString(),
      'name_ar': name_ar.toString(),
      'name_en': name_en.toString(),
      'fee': fee.toString(),
      'order': order.toString(),
      'package_amount': package_amount.toString(),
      'package_unit': package_unit.toString()
    };
    if(old_fee!=null){
      items['old_fee'] = old_fee;
    }
    request.fields.addAll(items);
    request.files.add(await http.MultipartFile.fromPath('image', image));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
  buy_new_package(token,patient,package,paid_amount,description)async{
    var headers = {
      'Authorization': 'Token $token'
    };
    var request = http.MultipartRequest('POST', Uri.parse("${Apis.buy_new_package}"));
    request.fields.addAll({
      'patient': patient.toString(),
      'package': package.toString(),
      'paid_amount': paid_amount.toString(),
      'description': description.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response;
  }
}