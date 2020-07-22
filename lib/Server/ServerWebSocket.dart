import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String url = "ws://192.168.43.220:80";

Stream serverSocket(String section) {
  try {
    WebSocketChannel websocket = IOWebSocketChannel.connect("$url/$section");
    return websocket.stream;
  } catch (e) {
    throw e;
  }
}
