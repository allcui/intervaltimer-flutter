import 'dart:convert';

import 'package:http/http.dart';

import 'http_request_handler.dart';

class User{
  const User({
    this.id,
    this.password,
    this.name,
  });

  final int id;
  final String password;
  final String name;

  String toJson() {
   return jsonEncode({
     "name": "$name",
     "password": "$password"
   });
  }
  
  static Future<String> getUserNameById(int userId) async {
    final HTTPRequestHandler httpRequestHandler = HTTPRequestHandler(
      controller: Controllers.user,
      action: ControllerActions.getUserName,
      requestType: HTTPRequestTypes.get,
      pathVariable: '/$userId',
    );

    Response response = await httpRequestHandler.getResponse();
    print('HTTPResponse(getUserNameById) => ${response.body.toString()}');
    return response.body.toString();
  }

}