import 'package:flutter/material.dart';

void alertWithCallBack(
    {String content,
    String callBackName,
    Function cakllback,
    BuildContext context}) {
  showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          "$content",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        actions: [
          RaisedButton(
            onPressed: cakllback,
            child: Text(
              "$callBackName",
              style: Theme.of(context).textTheme.headline1,
            ),
          )
        ],
      ));
}
