import 'package:flutter/material.dart';

class TimerProfile{

  static const defaultWarmUpDuration = Duration(seconds: 30);
  static const defaultWorkDuration = Duration(seconds: 60);
  static const defaultRestDuration = Duration(seconds: 30);
  static const defaultCoolDownDuration = Duration(seconds: 60);

  const TimerProfile({
    this.id = 1,
    this.name = 'Test Profile',
    @required this.warmUpDuration,
    @required this.workDuration,
    @required this.restDuration,
    @required this.coolDownDuration,
  });

  final int id;
  final String name;
  final Duration warmUpDuration;
  final Duration workDuration;
  final Duration restDuration;
  final Duration coolDownDuration;

  TimerProfile getDefaultProfile(){
    return TimerProfile(
      warmUpDuration: defaultWarmUpDuration,
      workDuration: defaultWorkDuration,
      restDuration: defaultRestDuration,
      coolDownDuration: defaultCoolDownDuration,
    );
  }
}