import 'package:countdown_timer/model/timer_profile.dart';

class WorkOut{
  WorkOut({
    this.id = 1,
    this.profile,
    this.startTime,
    this.endTime,
    this.setsCompleted = 0,
  });

  final int id;
  final TimerProfile profile;
  final DateTime startTime;
  final DateTime endTime;
  int setsCompleted;

  bool allSetsCompleted(){
    return setsCompleted == profile.setCount;
  }

  void incrementSetsCompleted(){
    setsCompleted++;
  }
}