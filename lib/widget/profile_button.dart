import 'package:countdown_timer/model/timer_profile.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({this.profile, this.hasNoProfile = true, this.width = 100.0, this.height = 40.0, this.onPressed, this.index});

  final TimerProfile profile;
  final bool hasNoProfile;
  final double width;
  final double height;
  final Function(int, TimerProfile) onPressed;
  final int index;
  
  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  TimerProfile _profile;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        color: Colors.white70,
        width: widget.width,
        height: widget.height,
        child: (widget.hasNoProfile || widget.profile == null) ? Icon(Icons.add) : Text(widget.profile.name),
      ),
    );
  }

  void onPressed() {
    setState(() {
      _profile = widget.profile;
    });
    widget.onPressed(widget.index, widget.profile);
  }
}
