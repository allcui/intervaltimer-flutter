import 'package:countdown_timer/model/device.dart';
import 'package:flutter/material.dart';

class WorkOutItemUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Device device = Device(context);
    final double width = device.getWidth();
    final double height = device.getHeight();
    return Container();
  }
}
