import 'dart:convert';

import 'package:countdown_timer/model/http_request_handler.dart';
import 'package:countdown_timer/model/workout.dart';
import 'package:countdown_timer/widget/loading_indicator.dart';
import 'package:countdown_timer/widget/work_out_item.dart';
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
        create: (_) async => await WorkOut.getAllWorkOuts(),
        child: Consumer<List<WorkOut>>(
          builder: (context, workOuts, __) => _buildHomePage(context, workOuts),
        )
    );
  }

  Widget _buildHomePage(BuildContext context, List<WorkOut> workOuts) {
    if (workOuts == null) return LoadingIndicator(text: 'Loading...');
    if (workOuts.isEmpty) return Center(child: Text('No one has shared there progress yet!', style: TextStyle(color: Colors.black),));
    return ListView.builder(
      itemCount: workOuts.length,
      itemBuilder: (BuildContext context, int index){
        return WorkOutItem(
          workOut: workOuts[index]
        );
      },
    );
    return Container();
  }

}