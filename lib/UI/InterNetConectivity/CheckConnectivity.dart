import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/InterNetConectivity/NoInterNet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CheckInerNetAndFirebaseInit extends StatefulWidget {
  final Widget child;

  const CheckInerNetAndFirebaseInit({Key key, this.child}) : super(key: key);
  @override
  _CheckInerNetAndFirebaseInitState createState() =>
      _CheckInerNetAndFirebaseInitState();
}

class _CheckInerNetAndFirebaseInitState
    extends State<CheckInerNetAndFirebaseInit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        switch (snapshot.data) {
          case ConnectivityResult.none:
            return NoInterNet();
            break;
          default:
            return widget.child;
        }
      },
    );
  }

  // Widget checkFirebaseInIt() {
  //   if (_error) {
  //     return BeruErrorPage(errMsg: _errorOnInitFirebase.toString());
  //   }
  //   if (!_initialized) {
  //     return beruLoadingBar();
  //   }
  //   return widget.child;
  // }
}

Widget checkInterNet(child) {
  return StreamBuilder<ConnectivityResult>(
    stream: Connectivity().onConnectivityChanged,
    builder: (context, snapshot) {
      print("called checknet");
      switch (snapshot.data) {
        case ConnectivityResult.none:
          return NoInterNet();
          break;
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          return firebaseInit(child);
          break;
      }
      return Offstage();
    },
  );
}

Widget firebaseInit(child) {
  print("called firbaseinit");
  return FutureBuilder(
    // Initialize FlutterFire:
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      // Check for errors
      if (snapshot.hasError) {
        return BeruErrorPage(
          errMsg: snapshot.error,
        );
      }

      // Once complete, show your application
      if (snapshot.connectionState == ConnectionState.done) {
        return child;
      }

      // Otherwise, show something whilst waiting for initialization to complete
      return beruLoadingBar();
    },
  );
}
