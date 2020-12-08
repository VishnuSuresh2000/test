import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseData {
  User user;
  bool hasError;
  Exception error;
  bool state;
  FirebaseData({this.user, this.hasError, this.error, this.state = false});
}

class BlocForFirebase extends ChangeNotifier {
  ConnectivityResult _connectivty = ConnectivityResult.none;
  FirebaseApp _app;
  FirebaseData _data = FirebaseData();
  StreamSubscription<User> _firbaseSub;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  update(ConnectivityResult result) {
    // print("on update BlocForFirebase $result");
    if (result != null && _connectivty != result) {
      print("on change in connectivty BlocForFirebase");
      initFirebse(initStreamFirebase);
      _connectivty = result;
    }
  }

  @override
  void dispose() {
    _firbaseSub.cancel();
    super.dispose();
  }

  FirebaseData get data => this._data;

  BlocForFirebase() : super() {
    initNotification();
  }

  void initNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void initFirebse(void Function() callback) async {
    // print("on initFirebse BlocForFirebase");
    try {
      if (_app == null) {
        // print("on initFirebse BlocForFirebase init firebase app");
        _app = await Firebase.initializeApp();
        fcmConfig();
      }
      _data.hasError = false;
      _data.state = !_data.state;
      callback();
    } catch (e) {
      print("Error is from initFirebse from BlocForFirebase $e");
      _data.hasError = true;
      _data.error = e;
      _data.user = null;
      _data.state = !_data.state;
      notifyListeners();
    }
  }

  void initStreamFirebase() async {
    try {
      if (_connectivty != ConnectivityResult.none) {
        // print("on initFirebse BlocForFirebase has Connection");
        if (_firbaseSub == null) {
          _firbaseSub =
              FirebaseAuth.instance.authStateChanges().listen((event) {
            _data = FirebaseData(
                user: event ?? null,
                error: null,
                hasError: false,
                state: !_data.state);
            notifyListeners();
          }, onError: (e) {
            print(
                "Error is from initFirebse from initStreamFirebase from firbase error $e");
            _data.hasError = true;
            _data.error = e;
            _data.user = null;
            _data.state = !_data.state;
            notifyListeners();
          });
        }
      }
    } catch (e) {
      print("Error is from initFirebse from initStreamFirebase $e");
      _data.hasError = true;
      _data.error = e;
      _data.user = null;
      _data.state = !_data.state;
      notifyListeners();
    }
  }

  void fcmConfig() async {
    try {
      if (Platform.isAndroid) {
        print("Firebase Msg notication ${await _fcm.getToken()}");
        _fcm.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            _flutterLocalNotificationsPlugin.show(
                1, "${message['title']}", "${message['body']}", null);
          },
          onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
          },
          onResume: (Map<String, dynamic> message) async {
            print("onResume: $message");
          },
        );
      }
    } catch (e) {
      print("Error on config fcmConfig $e");
    }
  }
}
