import 'package:countdown_timer/model/http_request_handler.dart';
import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:countdown_timer/screen/registration_page.dart';
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
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userNameRegistrationController = TextEditingController();
  final TextEditingController _userPasswordRegistrationController = TextEditingController();

  static const Map<AuthCodes, String> authenticationMessages = {
    AuthCodes.success: 'Authenticated successfully!',
    AuthCodes.incorrectPassword: 'Incorrect password!',
    AuthCodes.userDoesNotExist: 'UserName entered is not found!',
  };

  static const Map<RegisterCodes, String> registerMessages = {
    RegisterCodes.success: 'User registered successfully!',
    RegisterCodes.duplicateUserName: 'Same user name found in database!',
  };

  bool _isLoadingDummyData = true;
  bool _isWaitingForServerResponse = false;

  @override
  Widget build(BuildContext context) {
    final Device device = Device(context);
    final double width = device.getWidth();
    final double itemWidth = device.isLargeScreen() ? width * 0.45 : width * 0.9;
    final double height = device.getHeight();
    if (height < 350) return Text('Why is your screen height < 350?');
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: height * 0.25),
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Text('The free tier hosting service wipes out database once in a while', style: TextStyle(color: Colors.blue),),
                SizedBox(height: 5.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Checkbox(
                      focusNode: FocusNode(skipTraversal: true, canRequestFocus: false),
                      checkColor: Colors.white,
                      value: _isLoadingDummyData,
                      onChanged: (bool value) {
                        setState(() {
                          _isLoadingDummyData = value;
                          print(_isLoadingDummyData);
                        });
                      },
                    ),
                    Text('Let us load some data!', style: TextStyle(color: Colors.black),)
                  ],
                ),
                SizedBox(height: 10.0),
                InputField(
                  controller: _userNameController,
                  labelText: 'Enter your name!',
                  width: itemWidth,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                InputField(
                  isPasswordField: true,
                  controller: _userPasswordController,
                  labelText: 'Enter a password',
                  width: itemWidth,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomButton(
                  onPressed: () => _userNameAndPasswordValidation(RequestType.login),
                  text: 'Go',
                  width: itemWidth,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  textSize: 15.0,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                CustomButton(
                  onPressed: () => _openRegistrationPage(),
                  text: 'New User',
                  width: itemWidth,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  textSize: 15.0,
                ),
              ],
            ),
          ),
          if (_isWaitingForServerResponse) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  _sendRequest({RequestType requestType, userName, String password}) async {
    Controllers controller = Controllers.auth;
    ControllerActions action = ControllerActions.login;

    if (requestType == RequestType.register) {
      controller = Controllers.user;
      action = ControllerActions.add;
    }

    var body = jsonEncode({"name": "$userName", "password": "$password"});

    HTTPRequestHandler apiCaller = HTTPRequestHandler(
      controller: controller,
      action: action,
      requestBody: body,
    );
    setState(() {
      _isWaitingForServerResponse = true;
    });
    var response = await apiCaller.getResponse();
    setState(() {
      _isWaitingForServerResponse = false;
    });
    if (requestType == RequestType.register) {
      _handleRegistration(response.body);
    } else {
      _handleAuthentication(response.body);
    }
  }

  void _handleRegistration(var responseCode) {
    if (responseCode.toString() == "0") {
      _showAuthenticationSystemMessage(
          message: registerMessages[RegisterCodes.duplicateUserName]);
    } else {
      print('new user added, user id is ' + responseCode.toString());
      _showAuthenticationSystemMessage(
          message: registerMessages[RegisterCodes.success],
          allowLogin: true,
          userId: int.parse(responseCode));
    }
  }

  void _handleAuthentication(var responseCode) {
    if (responseCode.toString() == "0") {
      _showAuthenticationSystemMessage(
          message: authenticationMessages[AuthCodes.userDoesNotExist]);
    } else if ((responseCode.toString() == "-1")) {
      _showAuthenticationSystemMessage(
          message: authenticationMessages[AuthCodes.incorrectPassword]);
    } else {
      _goToHomePage(int.parse(responseCode));
    }
  }

  Future<void> _showAuthenticationSystemMessage(
      {String message, bool allowLogin = false, int userId}) async {
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
            if (allowLogin)
              TextButton(
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.red),
                ),
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
    if (_isLoadingDummyData) _sendDummyDataToServer(userId);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Navigation(
                userId: userId,
                authenticated: true,
              )),
    );
  }

  void _userNameAndPasswordValidation(RequestType requestType) {
    String userName = _userNameController.text.trim();
    String password = _userPasswordController.text.trim();
    if (requestType == RequestType.register) {
      userName = _userNameRegistrationController.text.trim();
      password = _userPasswordRegistrationController.text.trim();
    }
    if (userName == null ||
        userName == '' ||
        password == null ||
        password == '') {
      _showAlertDialog(requestType);
    } else {
      _sendRequest(
          userName: userName,
          password: password,
          requestType: requestType);
    }
  }

  Future<void> _showAlertDialog(RequestType requestType) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (requestType == RequestType.register) ? Text('New User Registration Error!') : Text('User Name And Password Input Error!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Username and password cannot be empty!'),
              ],
            ),
          ),
          actions: <Widget>[
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

  Future<void> _openRegistrationPage() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final Device device = Device(context);
        final double width = device.getWidth();
        final double height = device.getHeight();
        return AlertDialog(
          title: Center(child: const Text('New User Registration')),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                  InputField(
                    controller: _userNameRegistrationController,
                    labelText: 'Enter your name!',
                    width: width * 0.6,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  InputField(
                    isPasswordField: true,
                    controller: _userPasswordRegistrationController,
                    labelText: 'Enter a password',
                    width: width * 0.6,
                  ),
          ]),
          actions: <Widget>[
            TextButton(
              child: Text('Register', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.blue)),
              onPressed: () {
                _userNameAndPasswordValidation(RequestType.register);
              },
            ),
            TextButton(
              child: Text('Close', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendDummyDataToServer(int userId)async {
    List<WorkOut> userWorkOuts = await WorkOut.getAllWorkOuts(filterByUserId: userId);
    if (userWorkOuts.isNotEmpty) return;

    List<dynamic> workOuts = WorkOut.getListOfDummyWorkOuts(userId: userId);

    for (WorkOut item in workOuts){
      var body = item.toJson();

      HTTPRequestHandler apiCaller = HTTPRequestHandler(
        controller: Controllers.workOut,
        action: ControllerActions.add,
        requestBody: body,
      );
      await apiCaller.getResponse();
    }
  }
}
