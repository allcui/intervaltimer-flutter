import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.text = 'Loading...'});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 5),
          Text(text),
        ],
      ),
    );
  }
}