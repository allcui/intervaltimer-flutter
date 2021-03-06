import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:countdown_timer/model/date_time_handler.dart';
import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/model/user.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:countdown_timer/widget/loading_indicator.dart';
import 'package:countdown_timer/widget/user_profile.dart';
import 'package:countdown_timer/widget/widgets.dart';
import 'package:countdown_timer/widget/work_out_item.dart';
import 'package:countdown_timer/widget/work_out_item_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({this.userId});
  final int userId;
  @override
  Widget build(BuildContext context) {
    // return FutureProvider(
    //     initialData: null,
    //     create: (_) async => await WorkOut.getAllWorkOuts(filterByUserId: userId),
    //     child: Consumer<List<WorkOut>>(
    //       builder: (context, workOuts, __) => _buildHomePage(context, workOuts),
    //     )
    // );
    return MultiProvider(
      providers: [
        FutureProvider<List<WorkOut>>(
          initialData: null,
          create: (_) async =>
              await WorkOut.getAllWorkOuts(filterByUserId: userId),
        ),
        FutureProvider<String>(
          initialData: null,
          create: (_) async => await User.getUserNameById(userId),
        )
      ],
      child: Consumer2<List<WorkOut>, String>(
          builder: (context, workOuts, userName, __) =>
              _buildProfilePage(context, workOuts, userName)),
    );
  }

  Widget _buildProfilePage(
      BuildContext context, List<WorkOut> workOuts, String userName) {
    if (workOuts == null || userName == null)
      return LoadingIndicator(text: 'Loading...');
    final Device device = Device(context);
    final double height = device.getHeight();
    final double width = device.getWidth();
    if (workOuts.isEmpty)
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: height * 0.2,
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: (device.isLargeScreen()) ? 150.0 : 40.0,
              fontFamily: 'Horizon',
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                RotateAnimatedText('START WORKOUT!',
                    textStyle: TextStyle(color: Colors.white)),
                RotateAnimatedText('BE MORE ACTIVE',
                    textStyle: TextStyle(color: Colors.white)),
                RotateAnimatedText('BE HEALTHIER',
                    textStyle: TextStyle(color: Colors.white)),
              ],
              repeatForever: true,
            ),
          ),
        ],
      );

    final int numberOfDaysAgo =
        DateTime.now().difference(workOuts[0].startTime).inDays;
    String lastWorkOutText = 'Last workout was $numberOfDaysAgo days ago.';
    if (numberOfDaysAgo <= 0)
      lastWorkOutText = 'You have just done a work out today.';

    final int averageDurationInSeconds = workOuts
            .map((workOut) => workOut.durationInSeconds)
            .reduce((a, b) => a + b) ~/
        workOuts.length;
    final int numberOfDaysOnJourney =
        workOuts.first.startTime.difference(workOuts.last.startTime).inDays;
    final Widget dashBoard = Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
      width: (device.isLargeScreen()) ? width * 0.3 : width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.greenAccent,
              Colors.blue,
              Colors.blueGrey,
            ],
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          UserProfile(
            userName: userName,
            height: 80.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container (
            child: AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  '@' + userName,
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Horizon',
                  ),
                  colors: [Colors.purple, Colors.black, Colors.yellow, Colors.red],
                ),
              ],
              isRepeatingAnimation: true,
              repeatForever: true,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          IconText(
            icon: Icons.workspaces_filled,
            text: '${workOuts.length} sets completed in total so far',
            centerAlign: true,
            color: Colors.white,
          ),
          IconText(
            icon: Icons.history,
            text: lastWorkOutText,
            centerAlign: true,
            color: Colors.white,
          ),
          IconText(
            icon: Icons.timelapse,
            text:
                'Your average duration is ${DateTimeHandler.convertSecondsToMinutesInString(averageDurationInSeconds)}.',
            centerAlign: true,
            color: Colors.white,
          ),
          IconText(
            icon: Icons.favorite,
            text:
                'It has been $numberOfDaysOnJourney day(s) since your first work out!',
            centerAlign: true,
            color: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );

    Widget child;
    workOuts.sort((a, b) =>
        b.startTime.compareTo(a.startTime)); //Sorting workouts by start time.
    print(workOuts.toString());
    if (device.isLargeScreen()) {
      child = GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 45.0, left: 50.0),
          childAspectRatio: 3.5,
          crossAxisCount: 2,
          children: workOuts
              .map((workOut) => WorkOutItem(
                    workOut: workOut,
                  ))
              .toList());
    }
    child = ListView.builder(
      shrinkWrap: true,
      itemCount: workOuts.length,
      itemBuilder: (BuildContext context, int index) {
        return WorkOutItemUser(workOut: workOuts[index]);
      },
    );
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          dashBoard,
          SizedBox(height: 20.0),
          Flexible(child: child),
        ],
      ),
    );
  }
}
