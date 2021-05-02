import 'dart:developer';

import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/model/round_state.dart';
import 'package:countdown_timer/model/slider_item.dart';
import 'package:countdown_timer/model/timer_profile.dart';
import 'package:countdown_timer/model/work_state.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:countdown_timer/widget/countdown_text.dart';
import 'package:countdown_timer/widget/custom_slider.dart';
import 'package:countdown_timer/widget/profile_button.dart';
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
      next: RoundStates.rest,
      duration: Duration.zero,
    ),
    RoundStates.rest: RoundState(
      current: RoundStates.rest,
      next: RoundStates.coolDown,
      duration: Duration.zero,
    ),
    RoundStates.coolDown: RoundState(
      current: RoundStates.coolDown,
      next: RoundStates.end,
      duration: Duration.zero,
    ),
  };

  static const Map<RoundStates, Color> _roundStatesColors = {
    RoundStates.warmUp: Colors.pinkAccent,
    RoundStates.work: Colors.redAccent,
    RoundStates.rest: Colors.blue,
    RoundStates.coolDown: Colors.teal,
    RoundStates.end: Colors.black,
  };

  static const Map<RoundStates, String> _roundStatesMessages = {
    RoundStates.warmUp: 'Warm Up Phase',
    RoundStates.work: 'Intense Work Out Phase, Go, Go, Go!',
    RoundStates.rest: 'Rest Phase, Slow Down!',
    RoundStates.coolDown: 'Cool Down Phase, Great Job!',
    RoundStates.end: 'Start a Work Out!',
  };
  AnimationController _countdownController;
  Animation _countdownAnimation;
  StepTween _countdownAnimationTween = StepTween(begin: 0, end: 0);

  TimerProfile _profileSelected = TimerProfile.getDefaultProfile();
  WorkOut _currentWorkOut;

  Map<SliderItems, int> _sliderItemCount = {
    SliderItems.warmUp: TimerProfile.defaultWarmUpDurationInSeconds,
    SliderItems.work: TimerProfile.defaultWorkDurationInSeconds,
    SliderItems.rest: TimerProfile.defaultRestDurationInSeconds,
    SliderItems.coolDown: TimerProfile.defaultCoolDownDurationInSeconds,
    SliderItems.setCount: TimerProfile.defaultSetCount,
  };
  RoundStates _currentRoundState = RoundStates.end;

  Map<int, TimerProfile> _profileButtons = {};
  @override
  void initState() {
    _countdownController = AnimationController(
      vsync: this,
      duration: _roundStates[_currentRoundState].duration,
    );
    _countdownController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _currentRoundState != RoundStates.end) _updateRoundState(_roundStates[_currentRoundState].next);
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
          ? CountdownText(animation: _countdownAnimation, fontSize: 200.0,)
          : Text(durationToString(0), style: TextStyle(fontSize: 200.0)
    );
    final Widget statusMessage = Text(
        (_currentRoundState == RoundStates.end)
            ? _roundStatesMessages[_currentRoundState]
            : _roundStatesMessages[_currentRoundState] + ' (${_currentWorkOut.setsCompleted.toString()}/${_currentWorkOut.profile.setCount.toString()})',
    );
    final Widget controlButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(onPressed: () => _startTimer(), icon: Icon(Icons.play_arrow, color: Colors.white,),),
        IconButton(onPressed: () => _endWorkOut(), icon: Icon(Icons.stop, color: Colors.white,),),
        IconButton(onPressed: () => _pauseAndResumeTimer(), icon: Icon(Icons.pause, color: Colors.white,),),
      ],
    );
    final double sliderWidth = width * 0.9;
    final Widget sliders = Column(
      children: <Widget>[
        ...SliderItems.values.map((item) => _buildSliderItem(sliderItem: item, width: sliderWidth)).toList(),
      ]
    );
    final Widget profileButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ProfileButton(onPressed: (index, profile) => _saveCurrentProfile(index, profile), profile: _profileButtons[0], index: 0),
        ProfileButton(onPressed: (index, profile) => _saveCurrentProfile(index, profile), profile: _profileButtons[1], index: 1),
        ProfileButton(onPressed: (index, profile) => _saveCurrentProfile(index, profile), profile: _profileButtons[2], index: 2),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text(IntervalTimer.title),),
      body: Container(
        color: _roundStatesColors[_currentRoundState],
        child: Center(
          child: Column(
            children: <Widget>[
              timer,
              statusMessage,
              controlButtons,
              if (_currentRoundState == RoundStates.end) sliders,
              if (_currentRoundState == RoundStates.end) profileButtons
            ],
          ),
        ),
      ),
    );
  }

  void _startTimer(){
    _profileSelected = TimerProfile(
      warmUpDuration: Duration(seconds: _sliderItemCount[SliderItems.warmUp]),
      workDuration: Duration(seconds: _sliderItemCount[SliderItems.work]),
      restDuration: Duration(seconds: _sliderItemCount[SliderItems.rest]),
      coolDownDuration: Duration(seconds: _sliderItemCount[SliderItems.coolDown]),
      setCount: _sliderItemCount[SliderItems.setCount],
    );
    _currentWorkOut = WorkOut(startTime: DateTime.now(), profile: _profileSelected);
    _updateRoundState(RoundStates.warmUp);
  }
  void _updateRoundState(RoundStates roundState) async {

    switch (roundState) {
      case RoundStates.coolDown:
        _currentWorkOut.incrementSetsCompleted();
        log(_currentWorkOut.setsCompleted.toString());
        if (!_currentWorkOut.allSetsCompleted()) {
          _updateRoundState(RoundStates.work);
          break;
        }
        continue asNormal;

      case RoundStates.end:
        if (_currentWorkOut.sufficientWorkOutCompleted()) _showCompleteDialog();
        continue asNormal;

      asNormal:
      default:
        setState(() {
          _currentRoundState = roundState;
          log('updated round state to ' + roundState.toString());
        });
        Duration currentRoundStateDuration = _profileSelected.getDurationByRoundState(_currentRoundState);
        _countdownAnimationTween.begin = currentRoundStateDuration.inSeconds;

        _countdownController.duration = currentRoundStateDuration;
        _countdownController.reset();
        await _countdownController.forward();
        break;
    }
  }

  String durationToString(int durationInSeconds){
    final duration = Duration(seconds: durationInSeconds);
    final minutes = duration.inMinutes;
    final seconds = durationInSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  Widget _buildSliderItem({SliderItems sliderItem, double width}){
    return CustomSlider(
      sliderItem: sliderItem,
      width: width,
      callback: (sliderItem, newCount) => _updateSliderItemCount(sliderItem, newCount),
    );
  }

  void _updateSliderItemCount(SliderItems sliderItem, int newCount){
    setState(() {
      _sliderItemCount[sliderItem] = newCount;
    });
  }

  Future<dynamic> _showCompleteDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Bravo! You have completed ${_currentWorkOut.setsCompleted} workout(s)!!!!'),
            actions: [
              TextButton(child: Text('Save and Share'), onPressed: () => _saveWorkOut(),),
              TextButton(child: Text('Close'), onPressed: () {
                Navigator.of(context).pop();
                _saveWorkOut(shareWorkOut: false);
                })
            ],
          );
        });
  }

  void _saveWorkOut({bool shareWorkOut = true}) {
    WorkOut workOutToSave = _currentWorkOut;
  }

  void _endWorkOut(){
    _updateRoundState(RoundStates.end);
  }

  void _pauseAndResumeTimer() {
    if (_countdownController.isAnimating) {
      _countdownController.stop(canceled: false);
    } else {
      _countdownController.forward();
    }

    log(_countdownController.isAnimating.toString());
  }

  void _saveCurrentProfile(int index, TimerProfile profile) {
      _profileButtons[index] = profile;
  }

}

