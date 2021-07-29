import 'package:flutter/material.dart';

enum Controllers { user, workOut, auth }
enum Actions { addNew }
class APICaller{
  static const String url = 'https://afternoon-cliffs-94702.herokuapp.com';
  static const Map<String, dynamic> defaultHeaders = {
    "Accept": "application/json",
    "content-type": "application/json"
  };

  APICaller({
    this.controller,
    this.action,
    this.requestBody,
    this.headers = defaultHeaders,
  });

  final Controllers controller;
  final Actions action;
  final Map<String, dynamic> requestBody;
  final Map<String, dynamic> headers;

}