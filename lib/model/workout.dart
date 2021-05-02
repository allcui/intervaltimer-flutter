import 'package:countdown_timer/model/timer_profile.dart';

class WorkOut{
  const WorkOut({
    this.id = 1,
    this.timerProfile,
    this.startTime,
    this.endTime,
  });

  final int id;
  final TimerProfile timerProfile;
  final DateTime startTime;
  final DateTime endTime;
}