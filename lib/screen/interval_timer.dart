import 'dart:developer';

import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/model/round_state.dart';
import 'package:countdown_timer/model/slider_item.dart';
import 'package:countdown_timer/model/timer_profile.dart';
import 'package:countdown_timer/model/work_state.dart';
import 'package:countdown_timer/widget/countdown_text.dart';
import 'package:countdown_timer/widget/custom_slider.dart';
import 'package:flutter/material.dart';

class IntervalTimer extends StatefulWidget {
  static const String title = 'Interval Timer';
  static const int maxWorkDurationInSeconds = 180;
  static const int maxRestDurationInSeconds = 120;
  static const int maxWarmUpDurationInSeconds = 60;
  static const int maxCoolDownDurationInSeconds = 60;
  static const int maxSetCount = 20;
  @override
  _IntervalTimerState createState() => _IntervalTimerState();
}

class _IntervalTimerState extends State<IntervalTimer> with SingleTickerProviderStateMixin{

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


  AnimationController _countdownController;
  Animation _countdownAnimation;
  StepTween _countdownAnimationTween = StepTween(begin: 0, end: 0);

  TimerProfile _profileSelected = TimerProfile.getDefaultProfile();
  int _remainingWorkDuration = TimerProfile.getDefaultProfile().workDuration.inSeconds;
  int _remainingRestDuration = TimerProfile.getDefaultProfile().restDuration.inSeconds;
  int _remainingWarmUpDuration = TimerProfile.getDefaultProfile().warmUpDuration.inSeconds;
  int _remainingCoolDownDuration = TimerProfile.getDefaultProfile().coolDownDuration.inSeconds;
  int _remainingSets = TimerProfile.getDefaultProfile().setCount;

  RoundStates _currentRoundState = RoundStates.end;

  @override
  void initState() {
    _countdownController = AnimationController(
      vsync: this,
      duration: _roundStates[_currentRoundState].duration,
    );
    _countdownController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _currentRoundState != RoundStates.coolDown) _updateRoundState(_roundStates[_currentRoundState].next);
    });

    _countdownAnimationTween.begin = _roundStates[_currentRoundState].duration.inSeconds;
    _countdownAnimation = _countdownAnimationTween.animate(_countdownController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Device device = Device(context);
    final double width = device.getWidth();
    final Widget timer = (_countdownController.status == AnimationStatus.forward)
        ? CountdownText(animation: _countdownAnimation, fontSize: 100.0,)
        : Text(durationToString(_remainingWarmUpDuration), style: TextStyle(fontSize: 100.0));

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
          max: IntervalTimer.maxSetCount.toDouble(),
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
              coolDownDurationSlider,
              setCountSlider,
              IconButton(onPressed: () => _startTimer(), icon: Icon(Icons.play_arrow, color: Colors.white,),),
              Text(_currentRoundState.toString(), style: TextStyle(color: Colors.white),),
              CustomSlider(
                sliderItem: SliderItems.warmUp,
                width: width * 0.9,
              ),
              CustomSlider(
                sliderItem: SliderItems.work,
                width: width * 0.9,
              ),
              CustomSlider(
                sliderItem: SliderItems.rest,
                width: width * 0.9,
              ),
              CustomSlider(
                sliderItem: SliderItems.coolDown,
                width: width * 0.9,
              ),
              CustomSlider(
                sliderItem: SliderItems.setCount,
                width: width * 0.9,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startTimer(){
    _profileSelected = TimerProfile(
      warmUpDuration: Duration(seconds: _remainingWarmUpDuration),
      workDuration: Duration(seconds: _remainingWorkDuration),
      restDuration: Duration(seconds: _remainingRestDuration),
      coolDownDuration: Duration(seconds: _remainingCoolDownDuration),
      setCount: _remainingSets,
    );
    _updateRoundState(RoundStates.warmUp);
  }
  void _updateRoundState(RoundStates roundState) async {
    setState(() {
      _currentRoundState = roundState;
      log('updated round state to ' + roundState.toString());
    });
    Duration currentRoundStateDuration = _profileSelected.getDurationByRoundState(_currentRoundState);
    _countdownAnimationTween.begin = currentRoundStateDuration.inSeconds;

    _countdownController.duration = currentRoundStateDuration;
    _countdownController.reset();
    await _countdownController.forward();
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

