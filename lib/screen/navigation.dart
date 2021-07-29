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
    return Scaffold(
      body: Container(
        child: Center(child: _tabs.elementAt(_currentSelectedTabIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Workout!',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
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
