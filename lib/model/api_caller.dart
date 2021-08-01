import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';

enum Controllers { user, workOut, auth }
enum ControllerActions { add, login, addWorkOut, getAll }
enum HTTPRequestTypes { post, get, delete, put }

class APICaller{
  static const String serverUrl = 'https://afternoon-cliffs-94702.herokuapp.com';
  static const Map<String, String> defaultHeaders = {
    "Accept": "application/json",
    "content-type": "application/json"
  };

  static const Map<ControllerActions, String> actionPaths = {
    ControllerActions.add : '/new',
    ControllerActions.login : '/login',
    ControllerActions.getAll: '/get/all',
  };

  static const Map<Controllers, String> controllerPaths = {
    Controllers.user : '/users',
    Controllers.workOut : '/workouts',
    Controllers.auth : '/auth',
  };

  APICaller({
    @required this.controller,
    @required this.action,
    this.requestBody,
    this.headers = defaultHeaders,
    this.requestType = HTTPRequestTypes.post,
  });

  final Controllers controller;
  final ControllerActions action;
  final String requestBody;
  final Map<String, String> headers;
  final HTTPRequestTypes requestType;

  Future<Response> getResponse() async {
    var url = Uri.parse(serverUrl + controllerPaths[controller] + actionPaths[action]);
    var body = requestBody;
    var headers = this.headers;

    print('API call to be made=> url: [$url], body: $body.');

    if (requestType == HTTPRequestTypes.post) {
      return await http.post(
        url,
        body: body,
        headers: headers
      );
    } else if (requestType == HTTPRequestTypes.get) {
      return await http.get(
        url,
      );
    }

    return null;
  }

}