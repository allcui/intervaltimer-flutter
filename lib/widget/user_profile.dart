import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  
  const UserProfile({this.userName, this.height});
  final String userName;
  final double height;
  @override
  Widget build(BuildContext context) {
    String initial = _getInitialFromUserName(userName);
    return CircleAvatar(
      backgroundImage: AssetImage('assets/avatorbg.png'),
      radius: (height) / 2,
      child: Center(child: Text(initial, style: TextStyle(fontSize: height * 0.4, color: Colors.white)),),
    );
  }

  String _getInitialFromUserName(String userName) => userName.isNotEmpty
      ? userName.trim().split(' ').map((l) => l[0]).take(3).join()
      : '';
}
