import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class IntervalTimer extends StatefulWidget {
  static const title = 'Interval Timer';
  @override
  _IntervalTimerState createState() => _IntervalTimerState();
}

class _IntervalTimerState extends State<IntervalTimer> {

  final CountDownController _countDownController = CountDownController();

  int _remainingDuration = 30;

  @override
  Widget build(BuildContext context) {
    final Widget timer = CircularCountDownTimer(
      duration: _remainingDuration,
      initialDuration: 0,
      controller: _countDownController,
      width: 200.0,
      height: 300.0,
      ringColor: Colors.orangeAccent,
      ringGradient: null,
      fillColor: Colors.purpleAccent[100],
      fillGradient: null,
      backgroundColor: Colors.purple[500],
      backgroundGradient: null,
      strokeWidth: 10.0,
      strokeCap: StrokeCap.round,
      textStyle: TextStyle(
          fontSize: 50.0, color: Colors.white, fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.S,
      isReverse: true,
      isReverseAnimation: false,
      isTimerTextShown: false,
      autoStart: false,
      onStart: () {
        print('Countdown Started');
      },
      onComplete: () {
        print('Countdown Ended');
      },
    );
    return Scaffold(
      appBar: AppBar(title: Text(IntervalTimer.title),),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              timer,
              IconButton(icon: Icon(Icons.play_arrow, color: Colors.white,), onPressed: () => _countDownController.start()),
            ],
          ),
        ),
      ),
    );
  }
}
