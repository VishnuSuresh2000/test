import 'package:beru/UI/InterNetConectivity/NoInterNet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

StreamBuilder<ConnectivityResult> checkInterNet(Widget child) {
  return StreamBuilder<ConnectivityResult>(
    stream: Connectivity().onConnectivityChanged,
    builder: (context, snapshot) {
      switch (snapshot.data) {
        case ConnectivityResult.none:
          return NoInterNet();
          break;
        default:
          return child;
      }
    },
  );
}
