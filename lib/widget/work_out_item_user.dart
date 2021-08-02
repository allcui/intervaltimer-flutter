import 'package:countdown_timer/model/date_time_handler.dart';
import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:countdown_timer/widget/widgets.dart';
import 'package:flutter/material.dart';

class WorkOutItemUser extends StatelessWidget {
  const WorkOutItemUser({this.workOut});
  final WorkOut workOut;

  @override
  Widget build(BuildContext context) {
    final Device device = Device(context);
    final double width = device.getWidth();
    final double height = device.getHeight();


    final int numberOfDaysAgo = DateTime.now().difference(workOut.startTime).inDays;
    String numberOfDaysAgoText = '$numberOfDaysAgo days ago';
    if (numberOfDaysAgo <= 0) numberOfDaysAgoText = 'Today';
    final String dateText = '${DateTimeHandler.convertDateTimeToString(workOut.startTime)} ($numberOfDaysAgoText)';
    final String setsText = 'Bravo! You have completed ${workOut.setsCompleted} set(s)!';
    final String durationText = 'This work out lasted ${DateTimeHandler.convertSecondsToMinutesInString(workOut.durationInSeconds)}, keep it up!';
    final List<Widget> children = [
      IconText(icon: Icons.workspaces_filled, text: setsText, color: Colors.black,),
      IconText(icon: Icons.timer_sharp, text: durationText, color: Colors.black),
    ];
    return Padding(
      padding: EdgeInsets.only(top: height * 0.01, bottom: height* 0.01, left: width * 0.05, right: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8)
              ),
              border: Border.all(color: Colors.grey,),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.sports_handball, color: Colors.white,),
                SizedBox(width: 5.0,),
                Text(dateText)],
            ),
          ),
          Container(
            width: width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ) ,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.grey,
                  ],
                )
            ),
            child: (device.isLargeScreen())
              ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[...children])
              : Column(
                children: <Widget>[
                  ...children
                ],
              ),
            ),
        ],
      ),
    );
  }
}
