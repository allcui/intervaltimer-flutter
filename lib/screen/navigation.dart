import 'package:countdown_timer/screen/home_page.dart';
import 'package:countdown_timer/screen/interval_timer.dart';
import 'package:countdown_timer/screen/profile_page.dart';
import 'package:flutter/material.dart';

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
    'My Profile'
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
    _currentSelectedTabIndex = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(_tabTitles[_currentSelectedTabIndex])),
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
