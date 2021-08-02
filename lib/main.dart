import 'package:countdown_timer/screen/interval_timer.dart';
import 'package:countdown_timer/screen/login_page.dart';
import 'package:countdown_timer/screen/navigation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff1b1b1f),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white)
        ),
      ),
      home: Navigation(),
    )
  );
}
