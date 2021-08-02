import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CountdownText extends AnimatedWidget {
  const CountdownText({
    Key key,
    @required this.animation,
    this.minimumFontSize = 20.0,
  }) :  super(key: key, listenable: animation);

  final Animation<int> animation;
  final double minimumFontSize;

  @override
  build(BuildContext context) {
    return AutoSizeText(
      durationToString(animation.value.floor()),
      minFontSize: minimumFontSize,
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