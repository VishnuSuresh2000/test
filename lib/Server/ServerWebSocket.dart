import 'dart:async';

import 'package:beru/Server/ServerApi.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerSocket {
  static WebSocketChannel _channel;
  static Stream _stream;
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
      _stream = _channel.stream;
      _controller();
    } catch (e) {
      print("Error from Websocket Creation $e");
      throw e;
    }
  }

  static Stream get socketStream {
    if (_stream == null) {
      serverSocket();
    }
    return _stream;
  }

  static void _controller() {
    print("WS init controller");
    if (_stream == null) {
      serverSocket();
    }
    _sub = _stream.listen((event) {
      print("Global listern WS : $event");
    }, onDone: () {
      print("Global listern WS : onDone");
      serverSocket();
    }, onError: (error) {
      print("Global listern WS : onError : $error");
      serverSocket();
    });
  }
}
