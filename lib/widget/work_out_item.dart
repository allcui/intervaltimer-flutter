import 'package:countdown_timer/model/date_time_handler.dart';
import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/model/user.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:countdown_timer/widget/user_profile.dart';
import 'package:countdown_timer/widget/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkOutItem extends StatelessWidget {
  const WorkOutItem({this.workOut});
  final WorkOut workOut;

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
        initialData: null,
        create: (_) async => await User.getUserNameById(workOut.userId),
        child: Consumer<String>(
          builder: (context, userName, __) =>
              _buildWorkOutItem(context, userName),
        ));
  }

  Widget _buildWorkOutItem(BuildContext context, String userName) {
    if (userName == null) return Container();
    final Device device = Device(context);
    final double width = device.getWidth();
    final double height = device.getHeight();
    print(width.toString() + ' ' + height.toString());

   final String workOutSetsText = '${workOut.setsCompleted} set(s) completed!';
   final Widget workOutTime = Row(
        children: <Widget>[
          IconText(
            icon:Icons.date_range,
            text: DateTimeHandler.convertDateTimeToString(workOut.startTime),
          ),
          SizedBox(width: 15.0,),
          IconText(
            icon: Icons.timer_sharp,
            text: DateTimeHandler.convertSecondsToMinutesInString(workOut.durationInSeconds),
          )
        ],
    );
    final Widget workOutInfo = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)) ,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.black,
            ],
          )
      ),
      width: (device.isLargeScreen()) ? width * 0.4 : width * 0.8,
      padding: EdgeInsets.only(left: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0,),
          Text(
              userName,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )
          ),
          SizedBox(height: 5.0,),
          Text(
              workOutSetsText,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white70,
              )
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 200.0,
              color: Color(0xff00c6ff)
          ),
          SizedBox(height: 15.0,),
          workOutTime,
          SizedBox(height: 20.0,),
        ],
      )
    );

    final Widget child = Stack(
      children: <Widget>[
        SizedBox(width: 20.0,),
        Positioned(
            left: 50.0,
            child: workOutInfo
        ),
        Positioned(
          top: 25,
          child: Container(
            alignment: FractionalOffset.centerLeft,
            child: UserProfile(
              userName: userName,
              height: 100.0,
            ),
          ),
        ),
        SizedBox(width: 20.0,),
      ],
    );

    print('111    ' + (height * 0.15).toString() + '   ' + (width * 0.45).toString());
    return Container(
      margin: (device.isLargeScreen()) ? EdgeInsets.zero : EdgeInsets.all(10.0) ,
      height: height * 0.18,
      width: (device.isLargeScreen()) ? width * 0.45 : width * 0.8,
      child: child,
    );
  }
}
