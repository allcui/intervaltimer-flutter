import 'package:countdown_timer/model/timer_profile.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({this.profile, this.width = 100.0, this.height = 40.0, this.onPressed, this.index});

  final TimerProfile profile;
  final double width;
  final double height;
  final Function onPressed;
  final int index;
  
  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        color: Colors.white70,
        width: widget.width,
        height: widget.height,
        child: (widget.profile == null) ? Icon(Icons.add) : Center(child: Text((widget.index + 1).toString())),
      ),
    );
  }

}
