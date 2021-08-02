import 'package:flutter/material.dart';

class Device{

  const Device(this.context);

  final BuildContext context;

  bool isLargeScreen(){
    return MediaQuery.of(context).size.width > 1040.0;
  }

  double getWidth(){
    return MediaQuery.of(context).size.width;
  }

  double getHeight(){
    return MediaQuery.of(context).size.height;
  }

}