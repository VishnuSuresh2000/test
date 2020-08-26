import 'dart:async';

import 'package:beru/Server/ServerApi.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerSocket {
  static StreamController<String> _streamController =
      StreamController.broadcast(sync: true);
  static WebSocketChannel _channel;
  static String _url = ServerApi.offlineOnline
      ? "ws://${ServerApi.dns}"
      : "wss://${ServerApi.dns}";
  static const String categorySec = "catogoryTrue";
  static const String sallesSec = "sallesTrue";
  static StreamSubscription _sub;
  static void serverSocket() {
    print("WS chnnel $_url");
    try {
      if (_sub != null) {
        print("WS Sub Inited");
        _sub.cancel();
      }
      if (_channel != null) {
        print("WS Channel Inited");
        _channel.sink.close();
      }
      _channel = WebSocketChannel.connect(Uri.parse("$_url/sync"));

      _controller();
    } catch (e) {
      print("Error from Websocket Creation $e");
      throw e;
    }
  }

  static Stream get socketStream {
    if (_channel == null) {
      serverSocket();
    }
    return _streamController.stream;
  }

  static void _controller() {
    print("WS init controller");
    if (_channel == null) {
      serverSocket();
    }
    _sub = _channel.stream.listen((event) {
      print("Global listern WS : $event");
      if (_streamController.hasListener) {
        _streamController.add("$event");
      }
    }, onDone: () {
      print("Global listern WS : onDone");
      serverSocket();
    }, onError: (error) {
      print("Global listern WS : onError : $error");
      serverSocket();
    });
  }

  static void dispose() {
    print("WS init Clossed all stream");
    _streamController.sink.close();
    _streamController.close();
    _channel.sink.close();
  }
}
