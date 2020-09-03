import 'dart:async';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/Cart.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Server/ServerWebSocket.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartData {
  List<Cart> data;
  final bool hasError;
  Exception error;
  CartData({this.hasError, this.data, this.error});
}

class CartStream {
  StreamController<CartData> _controller =
      StreamController<CartData>(sync: true);
  Stream _channel;
  StreamSubscription _sub;

  CartStream() {
    webSocketControl();
    getDataFromServer();
  }

  void getDataFromServer() async {
    print("called get Data from server");
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        print("User Dectedt for load cart");
        var dataRes = await ServerApi.serverGetCart();
        print("got Data from Cart Data from server $dataRes");
        if (_controller.hasListener) {
          _controller.sink
              .add(CartData(hasError: false, data: dataRes, error: null));
        }
      } else {
        print("no User Dectedt for load cart");
        getDataFromServer();
      }
    } on BeruNoProductForSalles catch (e) {
      print("Error from No Product error Cart stream ${e.toString()}");
      if (_controller.hasListener) {
        _controller.sink.add(CartData(hasError: true, data: null, error: e));
      }
    } catch (e) {
      print("Error from Cart stream ${e.toString()}");
      if (_controller.hasListener) {
        _controller.sink.add(CartData(
            hasError: true,
            data: null,
            error: e is Exception ? e : BeruUnKnownError(error: e.toString())));
        getDataFromServer();
      }
    }
  }

  Stream<CartData> get stream {
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
        if (event == ServerSocket.cartSec) {
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
