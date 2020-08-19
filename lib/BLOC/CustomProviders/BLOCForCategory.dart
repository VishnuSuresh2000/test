import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Server/ServerWebSocket.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  WebSocketChannel channel;

  BlocForCategory() : super() {
    setData();
    webSocketControl();
  }

  void setData() async {
    try {
      data.list = await ServerApi.serverGetCategory();
      data.isError = false;
    } catch (e) {
      print("From setData error $e");
      if (data.loading) {
        data.isError = true;
      }
      data.error = BeruServerError();
    } finally {
      data.loading = false;
      if (data.isError) {
        print("called the State from Cat");
        setData();
      }
      notifyListeners();
    }
  }

  void webSocketControl() {
    try {
      channel = serverSocket('sync');
      channel.stream.listen((event) {
        if (event == categorySec) {
          setData();
        }
      }, onError: (error) {
        print("From lisenetr error $error");
      }, onDone: () {
        print("canceled the Stream in Listern Category");
        webSocketControl();
      });
    } catch (e) {
      print("From Stream Category outside error $e");
      webSocketControl();
    }
  }



  @override
  void dispose() {
    if (channel != null) {
      channel.sink.close();
    }
    super.dispose();
  }
}
