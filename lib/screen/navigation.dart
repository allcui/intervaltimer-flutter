import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/screen/home_page.dart';
import 'package:countdown_timer/screen/interval_timer.dart';
import 'package:countdown_timer/screen/profile_page.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'login_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({this.userId});
  final int userId;
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  static const List<String> _tabTitles = [
    'Home - Check Out Other Folks!',
    'Interval Timer - Work Out Time!',
    'My Progress'
  ];
  int _currentSelectedTabIndex;
  List<Widget> _tabs = [];

  @override
  void initState() {
    _tabs = [
      HomePage(userId: widget.userId,),
      IntervalTimer(userId: widget.userId,),
      ProfilePage(userId: widget.userId,),
    ];
    _currentSelectedTabIndex = 1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Device device = Device(context);
    final double height = device.getHeight();
    final double width = device.getWidth();
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: Drawer(
        elevation: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top + AppBar().preferredSize.height,
            ),
            ListTile(
              leading: Icon(Icons.arrow_back, color: Colors.black,),
              title: Text('Back to alcui.dev', style: TextStyle(color: Colors.black)),
              onTap: () {html.window.location.href = "https://alcui.dev";}
            ),
            ListTile(
                leading: Icon(Icons.logout, color: Colors.black,),
                title: Text('Log Out!', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                }
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: Image.asset('assets/logo.png', height: 50.0,),
                onTap: (){html.window.location.href = "https://alcui.dev";},
              ),
              SizedBox(width: (device.isLargeScreen()) ? width * 0.25 : 15.0,),
              Text(_tabTitles[_currentSelectedTabIndex]),
            ]
        ),
      ),
      body: _tabs.elementAt(_currentSelectedTabIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspaces_filled),
            label: 'Workout!',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded),
            label: 'Profile',
            backgroundColor: Colors.purple,
          ),
        ],
        currentIndex: _currentSelectedTabIndex,
        onTap: _onTabPressed,
    ),
    );
  }

  void _onTabPressed(int index) {
    setState(() {
      _currentSelectedTabIndex = index;
    });
  }
}
