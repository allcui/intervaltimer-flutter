import 'package:flutter/material.dart';

class CountdownText extends AnimatedWidget {
  const CountdownText({
    Key key,
    @required this.animation,
    this.fontSize = 20.0,
    this.startText = "",
    this.endText = "",
  }) :  super(key: key, listenable: animation);
  final Animation<double> animation;
  final double fontSize;
  final String startText;
  final String endText;

  @override
  build(BuildContext context) {
    return Text(
      durationToString(animation.value.floor()),
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }

  String durationToString(int durationInSeconds){
    final duration = Duration(seconds: durationInSeconds);
    final minutes = duration.inMinutes;
    final seconds = durationInSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }
}