import 'package:countdown_timer/model/http_request_handler.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class WorkOutItem extends StatelessWidget {
  const WorkOutItem({this.workOut});
  final WorkOut workOut;


  @override
  Widget build(BuildContext context) {
    return FutureProvider(
        initialData: null,
        create: (_) async => await _getUserNameById(),
        child: Consumer<String>(
          builder: (context, userName, __) => _buildWorkOutItem(context, userName),
        )
    );
  }

  Widget _buildWorkOutItem(BuildContext context, String userName) {
    if (userName == null) return Container();
    return Card(
      child: Column(
          children: <Widget>[
            Text(userName),
            Text(_convertDateTime(workOut.startTime)),
            Text(_convertDateTime(workOut.endTime)),
            Text('sets completed: ${workOut.setsCompleted.toString()}'),
            Text(_convertDuration(Duration(seconds: workOut.durationInSeconds))),
          ],
        ),
    );
  }

  Future<String> _getUserNameById() async {
    final HTTPRequestHandler httpRequestHandler = HTTPRequestHandler(
      controller: Controllers.user,
      action: ControllerActions.getUserName,
      requestType: HTTPRequestTypes.get,
      pathVariable: '/${workOut.userId}',
    );

    Response response = await httpRequestHandler.getResponse();
    return response.body.toString();
  }

  String _convertDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  String _convertDuration(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
