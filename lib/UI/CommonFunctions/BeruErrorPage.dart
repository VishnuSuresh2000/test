import 'package:flutter/material.dart';

class BeruErrorPage extends StatelessWidget {
  final String errMsg;
  const BeruErrorPage({Key key, this.errMsg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text("Error\n$errMsg"),
      ),
    );
  }
}
