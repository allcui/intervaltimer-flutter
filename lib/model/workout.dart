import 'dart:convert';

import 'package:countdown_timer/model/timer_profile.dart';
import 'package:http/http.dart';

import 'http_request_handler.dart';

class WorkOut{

  static const int minimumSetsNeed = 1;

  WorkOut({
    this.userId = 1,
    this.profile,
    this.startTime,
    this.endTime,
    this.setsCompleted = 0,
    this.durationInSeconds = 0,
  });

  final int userId;
  TimerProfile profile;
  final DateTime startTime;
  final DateTime endTime;
  int setsCompleted;
  int durationInSeconds;

  void incrementSetsCompleted(){
    setsCompleted++;
  }

  bool allSetsCompleted(){
    return setsCompleted == profile.setCount;
  }

  bool sufficientWorkOutCompleted(){
    return setsCompleted >= minimumSetsNeed;
  }

  // WorkOut.fromJson(Map<String, dynamic> json)
  //     : userId = json["userId"],
  //       startTime = json["startTime"],
  //       endTime = json["endTime"],
  //       setsCompleted = json["setsCompleted"],
  //       durationInSeconds = json["durationInSeconds"]
  // ;

  factory WorkOut.fromJson(dynamic json){
    return WorkOut(
      userId: json['userId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json["endTime"]),
      setsCompleted: json["setsCompleted"],
      durationInSeconds: json["durationInSeconds"],
    );
  }

  String toJson() {
    return jsonEncode({
      "userId": "$userId",
      "startTime": "${startTime.toIso8601String()}",
      "endTime": "${endTime.toIso8601String()}",
      "setsCompleted": "$setsCompleted",
      "durationInSeconds": "$durationInSeconds",
    });
  }
  @override
  String toString() {
    return "WorkOut => userId: $userId, startTime: $startTime, endTime: $endTime, setsCompleted: $setsCompleted, durationInSeconds: $durationInSeconds";
  }
  
  static Future<List<WorkOut>> getAllWorkOuts({int filterByUserId}) async {
    final HTTPRequestHandler httpRequestHandler = HTTPRequestHandler(
      controller: Controllers.workOut,
      action: ControllerActions.getAll,
      requestType: HTTPRequestTypes.get,
    );

    Response response = await httpRequestHandler.getResponse();
    List<WorkOut> workOuts = List<WorkOut>.from(json.decode(response.body).map((workOut) => WorkOut.fromJson(workOut)));
    if (workOuts.isEmpty) return [];
    //Returning an empty list to distinguish between waiting for server response and an empty list being returned.
    print ('HTTPResponse(getAllWorkOuts) => ' + workOuts.toString());
    if (filterByUserId != null) {workOuts.removeWhere((workOut) => workOut.userId != filterByUserId);}
    return workOuts;
  }
}