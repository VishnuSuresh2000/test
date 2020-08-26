import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BeruErrorPage extends StatelessWidget {
  final String errMsg;
  const BeruErrorPage({Key key, this.errMsg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        color: Colors.white,
        child: Center(
          child: "Error : $errMsg".text.red700.bold.make(),
        ),
      ),
    );
  }
}
