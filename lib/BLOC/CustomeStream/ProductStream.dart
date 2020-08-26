import 'dart:async';

import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Server/ServerWebSocket.dart';

class ProductSallesStream {
  StreamController<List<Product>> _controller = StreamController<List<Product>>(
    onCancel: () {},
  );
  BeruCategory category;
  Stream _channel;
  StreamSubscription _sub;

  ProductSallesStream() {
    webSocketControl();
  }

  void init({BeruCategory category}) {
    this.category = category;
    getDataFromServer();
  }

  void getDataFromServer() async {
    print("called get Data from server");
    try {
      var dataRes =
          await ServerApi.serverGetSallesProductByCategory(category.id);
      _controller.sink.add(dataRes);
    } on BeruNoProductForSalles catch (e) {
      print("Error from Product stream ${e.toString()}");
      _controller.sink.addError(e);
    } catch (e) {
      _controller.sink.addError(e);
      print("Error from Product stream ${e.toString()}");
      getDataFromServer();
    }
  }

  Stream<List<Product>> get stream {
    return _controller.stream;
  }

  void dispose() async {
    await _controller.close();
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
        webSocketControl();
      });
    } catch (e) {
      print("From webSocketControl product error $e");
      webSocketControl();
    }
  }
}
