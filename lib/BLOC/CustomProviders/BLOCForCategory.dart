import 'dart:async';
import 'package:beru/BLOC/CustomProviders/BlocForFirbase.dart';
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
  Stream _channel;
  StreamSubscription _sub;
  FirebaseData _firebaseData = FirebaseData();

  update(FirebaseData data) {
    if (_firebaseData.state.toString() != data.state.toString()) {
      print("Data State Changed ${_firebaseData.state} ${data.state}");
      _firebaseData = data;
      setData();
    }
  }

  BlocForCategory() : super() {
    webSocketControl();
  }

  void setData() async {
    try {
      data.list = await ServerApi.serverGetCategory();
      data.isError = false;
    } on BeruNoProductForSalles {
      data.error = BeruNoProductForSalles();
      data.isError = true;
    } catch (e) {
      print("From setData error $e");
      if (data.loading) {
        data.isError = true;
      }
      data.error = BeruServerError();
    } finally {
      data.loading = false;
      if (data.isError && !(data.error is BeruNoProductForSalles)) {
        print("called the State from Cat");
        setData();
      }
      notifyListeners();
    }
  }

  void webSocketControl() {
    try {
      print("Category webSocketControl called");
      if (_sub != null) {
        print("Category Socket sub alredy exist");
        _sub.cancel();
      }
      _channel = ServerSocket.socketStream;
      _sub = _channel.listen((event) {
        if (event == ServerSocket.categorySec) {
          setData();
        }
      }, onError: (error) {
        print("From lisenetr Category error $error");
        webSocketControl();
      }, onDone: () {
        print("canceled the Stream in Listern Category");
        // webSocketControl();
      });
    } catch (e) {
      print("Category webSocketControl error $e");
      webSocketControl();
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
