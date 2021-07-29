import 'package:flutter/material.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.userId});
  final int userId;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginPage(),
    );
  }
}
