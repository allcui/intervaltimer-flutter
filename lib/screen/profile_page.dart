import 'package:countdown_timer/model/device.dart';
import 'package:countdown_timer/model/user.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:countdown_timer/widget/loading_indicator.dart';
import 'package:countdown_timer/widget/work_out_item.dart';
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
          create: (_) async => await WorkOut.getAllWorkOuts(filterByUserId: userId),
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

  Widget _buildProfilePage(BuildContext context, List<WorkOut> workOuts, String userName) {
    if (workOuts == null || userName == null) return LoadingIndicator(text: 'Loading...');
    if (workOuts.isEmpty) return Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/startbg.png'),
            Text('Start your first Work Out!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
          ],
        ),
      );

    final Device device = Device(context);

    Widget child;
    workOuts.sort((a, b) => b.startTime.compareTo(a.startTime)); //Sorting workouts by start time.
    print(workOuts.toString());
    if (device.isLargeScreen()) {
      child = GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 45.0, left: 50.0),
          childAspectRatio: 3.5,
          crossAxisCount: 2,
          children: workOuts.map((workOut) => WorkOutItem(workOut: workOut,)).toList()
      );
    }
    child = ListView.builder(
      shrinkWrap: true,
      itemCount: workOuts.length,
      itemBuilder: (BuildContext context, int index){
        return WorkOutItem(
            workOut: workOuts[index]
        );
      },
    );
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('wodasda'),
          Flexible(child: child),
        ],
      ),
    );
  }
}
