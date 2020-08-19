import 'package:flutter/material.dart';

Center beruLoadingBar() {
  return Center(
    child: AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.green),
          ),
          Text(
            "Please Wait...",
            style: TextStyle(
              color: Colors.green,
            ),
          )
        ],
      ),
    ),
  );
}
