import 'package:countdown_timer/screen/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white)
        ),
      ),
      home: LoginPage(),
    )
  );
}
