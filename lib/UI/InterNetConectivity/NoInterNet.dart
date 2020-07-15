import 'package:flutter/material.dart';

class NoInterNet extends StatelessWidget {
  static const String route = '/noNetWork';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            "No Inter Net Connect",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
