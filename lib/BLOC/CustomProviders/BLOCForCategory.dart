import 'dart:async';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Server/ServerWebSocket.dart';
import 'package:flutter/material.dart';

class StreamOutCategory {
  List<BeruCategory> list;
  Exception error;
  bool isError;
  String msg;
  bool loading = true;
  StreamOutCategory({this.list, this.error, this.isError, this.msg});
}

class BlocForCategory extends ChangeNotifier {
  StreamOutCategory data = StreamOutCategory();
  Timer syncServer;
  int delay = 30;

  BlocForCategory() : super() {
    setData();
    webSocketControl();
  }

  void setData() async {
    try {
      data.list = await ServerApi.serverGetCategory();
      data.isError = false;

      if (syncServer != null &&
          syncServer.isActive != null &&
          (syncServer.isActive ?? false)) {
        disposeTimer();
      }
    } catch (e) {
      print("From setData error $e");
      if (data.loading) {
        data.isError = true;
      }
      data.error = BeruServerError();
    } finally {
      data.loading = false;
      notifyListeners();
      if (data.isError && syncServer == null) {
        initTimer();
      }
    }
  }

  void webSocketControl() {
    try {
      Stream stream = serverSocket('category');
      stream.listen((event) {
        if (event == "true") {
          setData();
        }
      }, onError: (error) {
        print("From lisenetr error $error");
      }, onDone: () {
        print("canceled the Stream in Listern");
        webSocketControl();
      });
    } catch (e) {
      print("From ouside error $e");
      webSocketControl();
    }
  }

  void initTimer() {
    syncServer =
        Timer.periodic(Duration(seconds: delay), (timer) => this.setData());
  }

  void disposeTimer() {
    syncServer.cancel();
  }
}
