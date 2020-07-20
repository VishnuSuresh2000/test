import 'dart:async';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/REST_Api/ServerApi.dart';
import 'package:beru/Schemas/BeruCategory.dart';
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
  int delay = 5;

  BlocForCategory() : super() {
    setData();
    initTimer();
  }

  void setData() async {
    try {
      data.list = await ServerApi.serverGetCategory();
      data.isError = false;
    } catch (e) {
      print(e);
      if (data.loading) {
        data.isError = true;
      }
      data.error = BeruServerError();
    } finally {
      data.loading = false;
      notifyListeners();
      if (!data.isError) {
        disposeTimer();
        delay = 1000;
        initTimer();
      }
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
