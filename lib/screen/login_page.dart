
import 'dart:developer';

import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/widget/widgets.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _userNameController = TextEditingController();
  final _userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Device device = Device(context);
    final double width = device.getWidth();
    final double itemWidth = device.isLargeScreen() ? width * 0.6 : width * 0.9;
    final double height = device.getHeight();
    if (height < 350) return Text('Why is your screen height < 350?');
    return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.3),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              InputField(
                controller: _userNameController,
                labelText: 'Enter your name!',
                width: itemWidth,
              ),
              SizedBox(height: height * 0.01,),
              InputField(
                isPasswordField: true,
                controller: _userPasswordController,
                labelText: 'Enter a password',
                width: itemWidth,
              ),
              SizedBox(height: height * 0.02,),
              CustomButton(
                onPressed: () => login(),
                text: 'Go',
                width: itemWidth,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                textSize: 15.0,
              ),
              SizedBox(height: height * 0.01,),
              CustomButton(
                onPressed: () => register(userName: _userNameController.text, password: _userPasswordController.text),
                text: 'New User',
                width: itemWidth,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                textSize: 15.0,
              ),
            ],
          ),
        )
    );
  }

  login() {

  }

  register({String userName, String password}) async {
    var url = Uri.parse('https://afternoon-cliffs-94702.herokuapp.com/users/new');
    var body = jsonEncode({
      "name": "$userName",
      "password": "$password"
    });
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }
    );
    print(response.body);
  }
}