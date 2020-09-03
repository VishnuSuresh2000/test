import 'dart:async';

import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Server/ServerWebSocket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SallesData {
  List<Product> data;
  final bool hasError;
  Exception error;

  SallesData({this.hasError, this.data, this.error});
}

class ProductSallesStream {
  StreamController<SallesData> _controller =
      StreamController<SallesData>(sync: true);
  Stream _channel;
  StreamSubscription _sub;

  ProductSallesStream() {
    webSocketControl();
    getDataFromServer();
  }

  void getDataFromServer() async {
    print("called get Data from server");
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        print("User Dectedt for load product");
        var dataRes = await ServerApi.serverGetSallesProduct();
        if (_controller.hasListener) {
          _controller.sink
              .add(SallesData(hasError: false, data: dataRes, error: null));
        }
      } else {
         print("No User Dectedt for load product");
        getDataFromServer();
      }
    } on BeruNoProductForSalles catch (e) {
      print("Error from Product stream ${e.toString()}");
      if (_controller.hasListener) {
        _controller.sink..add(SallesData(hasError: true, data: null, error: e));
      }
    } catch (e) {
      print("Error from Product stream ${e.toString()}");
      if (_controller.hasListener) {
        _controller.sink.add(SallesData(
            hasError: true,
            data: null,
            error: e is Exception ? e : BeruUnKnownError(error: e.toString())));
        getDataFromServer();
      }
    }
  }

  Stream<SallesData> get stream {
    return _controller.stream;
  }

  void dispose() async {
    _controller.sink.close();
    _controller.close();
    if (_sub != null) {
      _sub.cancel();
    }
  }

  void webSocketControl() {
    try {
      print("Product webSocketControl called");
      if (_sub != null) {
        print("Product Socket sub alredy exist");
        _sub.cancel();
      }
      _channel = ServerSocket.socketStream;
      _sub = _channel.listen((event) {
        if (event == ServerSocket.sallesSec) {
          print("Socket Product get Data");
          getDataFromServer();
        }
      }, onError: (error) {
        print("From lisenetr error $error");
        webSocketControl();
      }, onDone: () {
        print("On done the Stream in Listern product");
        // webSocketControl();
      });
    } catch (e) {
      print("From webSocketControl product error $e");
      webSocketControl();
    }
  }
}
