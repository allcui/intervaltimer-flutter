import 'package:countdown_timer/model/round_state.dart';
import 'package:countdown_timer/model/slider_item.dart';
import 'package:flutter/material.dart';

class TimerProfile{

  static const int defaultWarmUpDurationInSeconds = 5;
  static const int defaultWorkDurationInSeconds = 5;
  static const int defaultRestDurationInSeconds = 5;
  static const int defaultCoolDownDurationInSeconds = 5;

  static const int defaultSetCount = 3;

  static const Duration defaultWarmUpDuration = Duration(seconds: defaultWarmUpDurationInSeconds);
  static const Duration defaultWorkDuration = Duration(seconds: defaultWorkDurationInSeconds);
  static const Duration defaultRestDuration = Duration(seconds: defaultRestDurationInSeconds);
  static const Duration defaultCoolDownDuration = Duration(seconds: defaultCoolDownDurationInSeconds);

  static TimerProfile getDefaultProfile(){
    return TimerProfile(
      warmUpDuration: defaultWarmUpDuration,
      workDuration: defaultWorkDuration,
      restDuration: defaultRestDuration,
      coolDownDuration: defaultCoolDownDuration,
      setCount: defaultSetCount,
    );
  }

  TimerProfile({
    this.id = 1,
    this.name = 'Test Profile',
    @required this.warmUpDuration,
    @required this.workDuration,
    @required this.restDuration,
    @required this.coolDownDuration,
    @required this.setCount,
  });

  final int id;
  final String name;
  Duration warmUpDuration;
  Duration workDuration;
  Duration restDuration;
  Duration coolDownDuration;
  int setCount;

  Duration getDurationByRoundState(RoundStates roundState){
    switch (roundState) {
      case RoundStates.warmUp:
        return warmUpDuration;
        break;
      case RoundStates.work:
        return workDuration;
        break;
      case RoundStates.rest:
        return restDuration;
        break;
      case RoundStates.coolDown:
        return coolDownDuration;
        break;
      default:
        return Duration.zero;
    }
  }

  int getSliderCountBySliderItem(SliderItems sliderItem){
    switch (sliderItem) {
      case SliderItems.warmUp:
        return warmUpDuration.inSeconds;
        break;
      case SliderItems.work:
        return workDuration.inSeconds;
        break;
      case SliderItems.rest:
        return restDuration.inSeconds;
        break;
      case SliderItems.coolDown:
        return coolDownDuration.inSeconds;
        break;
      case SliderItems.setCount:
        return setCount;
        break;
      default:
        return 0;
    }
  }

  void setCountBySliderItem(SliderItems sliderItem, int count){
    switch (sliderItem) {
      case SliderItems.warmUp:
        warmUpDuration = Duration(seconds: count);
        break;
      case SliderItems.work:
        workDuration = Duration(seconds: count);
        break;
      case SliderItems.rest:
        restDuration = Duration(seconds: count);
        break;
      case SliderItems.coolDown:
        coolDownDuration = Duration(seconds: count);
        break;
      case SliderItems.setCount:
        setCount = count;
        break;
    }
  }
  @override
  String toString(){
    return 'warm up duration: ' + this.warmUpDuration.inSeconds.toString();
        // ' work duration: ' + this.workDuration.toString() +
        // ' rest duration: ' + this.restDuration.toString() +
        // ' cooldown duration: ' + this.coolDownDuration.toString() +
        // ' set count: ' + this.setCount.toString();
  }

}