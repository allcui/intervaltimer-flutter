import 'package:countdown_timer/model/http_request_handler.dart';
import 'package:countdown_timer/model/workout.dart';
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
    return Card(
      child: Column(
        children: <Widget>[

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
}
