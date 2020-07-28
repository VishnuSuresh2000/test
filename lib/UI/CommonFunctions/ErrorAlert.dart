import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void errorAlert(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "$msg",
          style:Theme.of(context).textTheme.subtitle1,
        ),
        actions: [
          RaisedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Back"),
          )
        ],
      );
    },
  );
}
