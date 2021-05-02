import 'package:countdown_timer/model/round_state.dart';
import 'package:flutter/material.dart';

class TimerProfile{

  static const Duration defaultWarmUpDuration = Duration(seconds: 5);
  static const Duration defaultWorkDuration = Duration(seconds: 4);
  static const Duration defaultRestDuration = Duration(seconds: 3);
  static const Duration defaultCoolDownDuration = Duration(seconds: 2);
  static const int defaultSetCount = 20;

  static TimerProfile getDefaultProfile(){
    return TimerProfile(
      warmUpDuration: defaultWarmUpDuration,
      workDuration: defaultWorkDuration,
      restDuration: defaultRestDuration,
      coolDownDuration: defaultCoolDownDuration,
      setCount: defaultSetCount,
    );
  }

  const TimerProfile({
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
  final Duration warmUpDuration;
  final Duration workDuration;
  final Duration restDuration;
  final Duration coolDownDuration;
  final int setCount;

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

}