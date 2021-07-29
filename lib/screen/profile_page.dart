import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({this.userId});
  final int userId;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('profile page'),
    );
  }
}
