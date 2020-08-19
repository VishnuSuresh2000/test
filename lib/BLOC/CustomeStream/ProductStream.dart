import 'dart:async';

import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Server/ServerWebSocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ProductSallesStream {
  StreamController<List<Product>> _controller = StreamController<List<Product>>(
    onCancel: () {},
  );
  BeruCategory category;
  WebSocketChannel channel;

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
    if (channel != null) {
      channel.sink.close();
    }
  }

  void webSocketControl() {
    try {
      channel = serverSocket('sync');
      channel.stream.listen((event) {
        if (event == sallesSec) {
          print("Salles Web Socket get Data");
          getDataFromServer();
        }
      }, onError: (error) {
        print("From lisenetr error $error");
        // _controller.sink.addError(Exception("Error from websocket $error"));
      }, onDone: () {
        print("canceled the Stream in Listern product");
        webSocketControl();
      });
    } catch (e) {
      print("From Stream outside error $e");
      // _controller.sink.addError(Exception("Error from websocket outside $e"));
      webSocketControl();
    }
  }
}
