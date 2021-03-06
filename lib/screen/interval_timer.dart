import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:countdown_timer/model/http_request_handler.dart';
import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/model/round_state.dart';
import 'package:countdown_timer/model/slider_item.dart';
import 'package:countdown_timer/model/timer_profile.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:countdown_timer/widget/countdown_text.dart';
import 'package:countdown_timer/widget/custom_slider.dart';
import 'package:countdown_timer/widget/profile_button.dart';
import 'package:flutter/material.dart';

class IntervalTimer extends StatefulWidget {
  const IntervalTimer({this.userId});
  final int userId;

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
  RoundStates _currentRoundState = RoundStates.end;

  Map<int, TimerProfile> _userProfiles = {};
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
    final double height = device.getHeight();
    final double width = device.getWidth();
    double minimumFontSize = 180.0;
    if (device.isLargeScreen()) minimumFontSize = 400.0;
    final Widget timer = Expanded(child: Container(
        alignment: Alignment.center,
        color: _roundStatesColors[_currentRoundState],
        width: width * 0.9,
        child: (_countdownController.status == AnimationStatus.forward)
            ? CountdownText(animation: _countdownAnimation, minimumFontSize: minimumFontSize,)
            : AutoSizeText(durationToString(0), minFontSize: minimumFontSize,
        )
    ));
    final Widget statusMessage = Text(
        (_currentRoundState == RoundStates.end)
            ? _roundStatesMessages[_currentRoundState]
            : _roundStatesMessages[_currentRoundState] + ' (${_currentWorkOut.setsCompleted.toString()}/${_currentWorkOut.profile.setCount.toString()})',
      style: TextStyle(fontSize: (device.isLargeScreen()) ? 30.0 : 20.0),
    );
    final Widget controlButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(onPressed: () => _startTimer(), icon: Icon(Icons.play_arrow, color: Colors.green, size: 40.0,),),
        IconButton(onPressed: () => _endWorkOut(), icon: Icon(Icons.stop, color: Colors.red,size: 40.0,),),
        IconButton(onPressed: () => _pauseAndResumeTimer(), icon: Icon(Icons.pause, color: Colors.grey,size: 40.0,),),
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
        ProfileButton(onPressed: () => _profileButtonPressed(0), profile: _userProfiles[0], index: 0),
        ProfileButton(onPressed: () => _profileButtonPressed(1), profile: _userProfiles[1], index: 1),
        ProfileButton(onPressed: () => _profileButtonPressed(2), profile: _userProfiles[2], index: 2),
      ],
    );
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            timer,
            statusMessage,
            controlButtons,
            SizedBox(height: 20.0,),
            if (_currentRoundState == RoundStates.end) sliders,
            SizedBox(height: 20.0,)
          ],
        ),
      ),
    );
  }

  void _startTimer(){
    _profileSelected = _getCurrentSelectedProfile();
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
      callback: (sliderItem, newCount) => _updateProfileSelected(sliderItem, newCount),
      count: _profileSelected.getSliderCountBySliderItem(sliderItem),
    );
  }

  void _updateProfileSelected(SliderItems sliderItem, int newCount){
    TimerProfile tempProfile = new TimerProfile(
      warmUpDuration: _profileSelected.warmUpDuration,
      workDuration: _profileSelected.workDuration,
      restDuration: _profileSelected.restDuration,
      coolDownDuration: _profileSelected.coolDownDuration,
      setCount: _profileSelected.setCount,
    );
    tempProfile.setCountBySliderItem(sliderItem, newCount);
    setState(() {
      _profileSelected = tempProfile;
    });
  }

  Future<dynamic> _showCompleteDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Bravo! You have completed ${_currentWorkOut.setsCompleted} workout(s)!!!!'),
            actions: [
              //TextButton(child: Text('Save and Share'), onPressed: () => _saveWorkOut(),),
              TextButton(child: Text('Close'), onPressed: () {
                Navigator.of(context).pop();
                _saveWorkOut(shareWorkOut: false);
                })
            ],
          );
        });
  }

  Future<void> _saveWorkOut({bool shareWorkOut = true}) async {
    var body = WorkOut(
      userId: widget.userId,
      startTime: _currentWorkOut.startTime,
      endTime: DateTime.now(),
      setsCompleted: _currentWorkOut.setsCompleted,
      durationInSeconds: DateTime.now().difference(_currentWorkOut.startTime).inSeconds,
    ).toJson();

    HTTPRequestHandler apiCaller = HTTPRequestHandler(
      controller: Controllers.workOut,
      action: ControllerActions.add,
      requestBody: body,
    );

    await apiCaller.getResponse();

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

  void _profileButtonPressed(int index){
    log(index.toString());
    log(_userProfiles.toString());
    if (_userProfiles[index] == null) {
      log('is empty');
      _saveCurrentProfile(index);
    } else {
      setState(() {
        log('set');
        _profileSelected = _userProfiles[index];
        log(_profileSelected.toString());
      });
    }
  }

  void _saveCurrentProfile(int index) {
    setState(() {
      _userProfiles[index] = _profileSelected;
    });
    log(_userProfiles.toString());
  }


  TimerProfile _getCurrentSelectedProfile(){
    return _profileSelected;
  }

}

