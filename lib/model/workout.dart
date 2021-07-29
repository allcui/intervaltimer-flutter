import 'dart:convert';

import 'package:countdown_timer/model/timer_profile.dart';

class WorkOut{

  static const int minimumSetsNeed = 1;

  WorkOut({
    this.userId = 1,
    this.profile,
    this.startTime,
    this.endTime,
    this.setsCompleted = 0,
  });

  final int userId;
  TimerProfile profile;
  final DateTime startTime;
  final DateTime endTime;
  int setsCompleted;

  void incrementSetsCompleted(){
    setsCompleted++;
  }

  bool allSetsCompleted(){
    return setsCompleted == profile.setCount;
  }

  bool sufficientWorkOutCompleted(){
    return setsCompleted >= minimumSetsNeed;
  }

  WorkOut.fromJson(Map<String, dynamic> json)
      : userId = json["userId"],
        startTime = json["startTime"],
        endTime = json["endTime"],
        setsCompleted = json["setsCompleted"];

  String toJson() {
    return jsonEncode({
      "userId": "$userId",
      "startTime": "$startTime",
      "endTime": "$endTime",
      "setsCompleted": "$setsCompleted"
    });
  }
  @override
  String toString() {
    return "WorkOut => userId: $userId, startTime: $startTime, endTime: $endTime, setsCompleted: $setsCompleted.";
  }
}