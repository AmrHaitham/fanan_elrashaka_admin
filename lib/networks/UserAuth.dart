import 'package:http/http.dart' as http;
import 'ApisEndPoint.dart';

class Auth{

  login(userName ,password)async{
    var response =await http.get(Uri.parse("${Apis.loginEndPoint}${userName}/${password}/"));
    return response;
  }

}