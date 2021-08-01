import 'dart:convert';

import 'package:countdown_timer/model/api_caller.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
        initialData: null,
        create: (_) async => await _getAllWorkOuts(),
        child: Consumer<List<WorkOut>>(
          builder: (context, workOuts, __) => _buildHomePage(context, workOuts),
        )
    );
  }

  Widget _buildHomePage(BuildContext context, List<WorkOut> workOuts) {
    if (workOuts == null) return Container(color: Colors.green,);
      return Container(color: Colors.blue);
  }

  Future<List<WorkOut>> _getAllWorkOuts() async {
    final APICaller apiCaller = APICaller(
      controller: Controllers.workOut,
      action: ControllerActions.getAll,
      requestType: HTTPRequestTypes.get,
    );

    Response response = await apiCaller.getResponse();
    List<WorkOut> workOuts = List<WorkOut>.from(json.decode(response.body).map((workOut) => WorkOut.fromJson(workOut)));
    //print ('HTTPResponse(getAllWorkOuts) => ' + workOuts.toString());
    return workOuts;
  }
}