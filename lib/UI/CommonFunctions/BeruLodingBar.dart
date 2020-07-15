import 'package:flutter/material.dart';

class BeruLoadingBar extends StatelessWidget {
  const BeruLoadingBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: AlertDialog(
          content: AspectRatio(
            aspectRatio: 60/9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                ),
                Text("Please Wait...",style: TextStyle(
                  color: Colors.green,
                  fontSize: 20
                ),)
              ],
            ),
          ),
        ),
        );
  }
}
