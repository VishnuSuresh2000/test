import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String url = "ws://192.168.43.220:80";
const String categorySec = "catogoryTrue";
const String sallesSec = "sallesTrue";
WebSocketChannel serverSocket(String section) {
  try {
    WebSocketChannel websocket = IOWebSocketChannel.connect("$url/$section");
  
    return websocket;
  } catch (e) {
    throw e;
  }
}
