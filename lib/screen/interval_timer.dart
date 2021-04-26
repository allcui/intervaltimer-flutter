import 'package:countdown_timer/model/round_state.dart';
import 'package:countdown_timer/model/work_state.dart';
import 'package:flutter/material.dart';

class IntervalTimer extends StatefulWidget {
  static const String title = 'Interval Timer';
  static const int maxWorkDurationInSeconds = 180;
  static const int maxRestDurationInSeconds = 120;
  static const int maxWarmUpDurationInSeconds = 60;
  static const int maxCoolDownDurationInSeconds = 60;
  static const int maxSets = 20;
  @override
  _IntervalTimerState createState() => _IntervalTimerState();
}

class _IntervalTimerState extends State<IntervalTimer> with TickerProviderStateMixin{

  AnimationController _countdownController;
  Animation _countdownAnimation;

  int _remainingWorkDuration = 60;
  int _remainingRestDuration = 30;
  int _remainingWarmUpDuration = 30;
  int _remainingCoolDownDuration = 30;
  int _remainingSets = 10;
  
  static const Map<RoundStates, RoundState> _roundStates = {
    RoundStates.end: RoundState(
      current: RoundStates.end,
      next: RoundStates.warmUp,
      duration: Duration.zero,
    ),
    RoundStates.warmUp: RoundState(
      current: RoundStates.warmUp,
      next: RoundStates.work,
      duration: Duration.zero,
    ),
    RoundStates.work: RoundState(
      current: RoundStates.work,
      next: RoundStates.coolDown,
      duration: Duration.zero,
    ),
    RoundStates.coolDown: RoundState(
      current: RoundStates.coolDown,
      next: RoundStates.end,
      duration: Duration.zero,
    ),
  };

  static const Map<WorkStates, WorkState> _workStates = {
    WorkStates.work: WorkState(
      current: WorkStates.work,
      next: WorkStates.rest,
      duration: Duration.zero,
    ),
    WorkStates.rest: WorkState(
      current: WorkStates.rest,
      next: WorkStates.work,
      duration: Duration.zero,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final Widget timer = Text(
      durationToString(_remainingWorkDuration),
      style: TextStyle(
        fontSize: 150.0,
      ),
    );
    final Widget warmUpDurationSlider = Row(
      children: <Widget>[
        Text('Warm Up Duration(MM:SS): '),
        Slider(
          divisions: IntervalTimer.maxWarmUpDurationInSeconds ~/ 15,
          value: _remainingWarmUpDuration.toDouble(),
          min: 0,
          max: IntervalTimer.maxWarmUpDurationInSeconds.toDouble(),
          onChanged: (newDuration) {
            setState(() {_remainingWarmUpDuration = newDuration.toInt();}
            );
          },
        ),
        Text(durationToString(_remainingWarmUpDuration)),
      ],
    );
    final Widget coolDownDurationSlider = Row(
      children: <Widget>[
        Text('Cool down Duration(MM:SS): '),
        Slider(
          divisions: IntervalTimer.maxCoolDownDurationInSeconds ~/ 15,
          value: _remainingCoolDownDuration.toDouble(),
          min: 0,
          max: IntervalTimer.maxCoolDownDurationInSeconds.toDouble(),
          onChanged: (newDuration) {
            setState(() {_remainingCoolDownDuration = newDuration.toInt();}
            );
          },
        ),
        Text(durationToString(_remainingWarmUpDuration)),
      ],
    );
    final Widget workDurationSlider = Row(
      children: <Widget>[
        Text('Work Duration(MM:SS): '),
        Slider(
          divisions: IntervalTimer.maxWorkDurationInSeconds ~/ 15,
          value: _remainingWorkDuration.toDouble(),
          min: 0,
          max: IntervalTimer.maxWorkDurationInSeconds.toDouble(),
          onChanged: (newDuration) {
            setState(() {_remainingWorkDuration = newDuration.toInt();}
          );
          },
        ),
        Text(durationToString(_remainingWorkDuration)),
      ],
    );
    final Widget restDurationSlider = Row(
      children: <Widget>[
        Text('Rest Duration(MM:SS): '),
        Slider(
          divisions: IntervalTimer.maxRestDurationInSeconds ~/ 15,
          value: _remainingRestDuration.toDouble(),
          min: 0,
          max: IntervalTimer.maxRestDurationInSeconds.toDouble(),
          onChanged: (newDuration) {
            setState(() {_remainingRestDuration = newDuration.toInt();}
            );
          },
        ),
        Text(durationToString(_remainingRestDuration)),
      ],
    );
    final Widget setCountSlider = Row(
      children: <Widget>[
        Text('Set of Intervals: '),
        Slider(
          value: _remainingSets.toDouble(),
          min: 0,
          max: IntervalTimer.maxSets.toDouble(),
          onChanged: (newSetCount) {
            setState(() {_remainingSets = newSetCount.toInt();}
            );
          },
        ),
        Text(_remainingSets.toString()),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text(IntervalTimer.title),),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              timer,
              warmUpDurationSlider,
              workDurationSlider,
              restDurationSlider,
              setCountSlider
            ],
          ),
        ),
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

