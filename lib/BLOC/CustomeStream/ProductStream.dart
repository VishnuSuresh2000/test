import 'dart:async';

import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Server/ServerWebSocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ProductSallesStream {
  bool dataOrError;
  List<Product> data;
  Exception error;

  StreamController<List<Product>> _controller =
      StreamController<List<Product>>.broadcast(
    sync: true,
  );
  BeruCategory category = BeruCategory();
  WebSocketChannel channel;

  ProductSallesStream({BeruCategory category}) {
    this.category = category;
    getDataFromServer();
    _controller.onListen = () {
      if (dataOrError != null) {
        dataOrError
            ? _controller.sink.add(data)
            : _controller.sink.addError(error);
      }
    };
    webSocketControl();
  }

  void getDataFromServer() async {
    try {
      var dataRes =
          await ServerApi.serverGetSallesProductByCategory(category.id);
      dataOrError = true;
      data = dataRes;
      _controller.sink.add(data);
    } on BeruNoProductForSalles catch (e) {
      dataOrError = false;
      error = e;
      _controller.sink.addError(e);
    } catch (e) {
      if (dataOrError == null) {
        dataOrError = false;
        error = BeruNoProductForSalles();
        _controller.sink.addError(error);
      }
      print("Error from Product ${e.toString()}");
    } finally {
      if (!dataOrError) {
        getDataFromServer();
      }
    }
  }

  Stream<List<Product>> get stream {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
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
      }, onDone: () {
        print("canceled the Stream in Listern");
        webSocketControl();
      });
    } catch (e) {
      print("From Stream outside error $e");
      webSocketControl();
    }
  }
}
