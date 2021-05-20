
import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/widget/widgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _playerNameController = TextEditingController();
  final _lobbyIdController = TextEditingController();

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
                controller: _playerNameController,
                labelText: 'Enter your name!',
                width: itemWidth,
              ),
              SizedBox(height: height * 0.01,),
              InputField(
                isPasswordField: true,
                controller: _lobbyIdController,
                labelText: 'Enter a password',
                width: itemWidth,
              ),
              SizedBox(height: height * 0.02,),
              CustomButton(
                onPressed: () => null,
                text: 'Go',
                width: itemWidth,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                textSize: 15.0,
              ),
            ],
          ),
        )
    );
  }
}