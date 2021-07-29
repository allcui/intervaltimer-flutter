import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/widget/widgets.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'interval_timer.dart';
import 'navigation.dart';

enum RequestType { login, register }
enum AuthCodes { success, incorrectPassword, userDoesNotExist }
enum RegisterCodes { success, duplicateUserName }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _userNameController = TextEditingController();
  final _userPasswordController = TextEditingController();

  static const Map<AuthCodes, String> authenticationMessages = {
    AuthCodes.success: 'Authenticated successfully!',
    AuthCodes.incorrectPassword: 'Incorrect password!',
    AuthCodes.userDoesNotExist: 'UserName entered is not found!',
  };

  static const Map<RegisterCodes, String> registerMessages = {
    RegisterCodes.success: 'User registered successfully!',
    RegisterCodes.duplicateUserName: 'Same user name found in database!',
  };

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
                onPressed: () => _sendRequest(
                    userName: _userNameController.text,
                    password: _userPasswordController.text,
                    requestType: RequestType.login
                ),
                text: 'Go',
                width: itemWidth,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                textSize: 15.0,
              ),
              SizedBox(height: height * 0.01,),
              CustomButton(
                onPressed: () => _sendRequest(
                    userName: _userNameController.text,
                    password: _userPasswordController.text,
                    requestType: RequestType.register
                ),
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

  _sendRequest({RequestType requestType,  userName, String password}) async {
    print('called');
    var url = Uri.parse('https://afternoon-cliffs-94702.herokuapp.com/auth/login');
    if (requestType == RequestType.register) {
      url = Uri.parse('https://afternoon-cliffs-94702.herokuapp.com/users/new');
    }
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

    if (requestType == RequestType.register){
      _handleRegistration(response.body);
    } else {
      _handleAuthentication(response.body);
    }
  }

  void _handleRegistration(var responseCode) {
    if (responseCode.toString() == "0") {
      _showAuthenticationSystemMessage(message: registerMessages[RegisterCodes.duplicateUserName]);
    } else {
      print('new user added, user id is ' + responseCode.toString());
      _showAuthenticationSystemMessage(message: registerMessages[RegisterCodes.success], allowLogin: true, userId: int.parse(responseCode));
    }
  }

  void _handleAuthentication(var responseCode) {
    if (responseCode.toString() == "0") {
      _showAuthenticationSystemMessage(message: authenticationMessages[AuthCodes.userDoesNotExist]);
    } else if ((responseCode.toString() == "-1")){
      _showAuthenticationSystemMessage(message: authenticationMessages[AuthCodes.incorrectPassword]);
    } else {
      _goToHomePage(int.parse(responseCode));
    }
  }

  Future<void> _showAuthenticationSystemMessage({String message, bool allowLogin = false, int userId }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Authentication System Message:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            if (allowLogin) TextButton(
              child: const Text('Login', style: TextStyle(color: Colors.red),),
              onPressed: () {
                _goToHomePage(userId);
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _goToHomePage(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Navigation(userId: userId,)),
    );
  }
}