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

  Widget _buildHomePage(BuildContext context, workOuts) {
    return Container();
  }

  Future<List<WorkOut>>_getAllWorkOuts() async {
    final APICaller apiCaller = APICaller(
      controller: Controllers.workOut,
      action: ControllerActions.getAll,
      requestType: HTTPRequestTypes.get,
    );

    Response response = await apiCaller.getResponse();
  }
}
