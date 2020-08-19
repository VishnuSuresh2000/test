import 'package:beru/Server/ServerApi.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String url = ServerApi.offlineOnline
    ? "ws://${ServerApi.dns}"
    : "wss://${ServerApi.dns}";
const String categorySec = "catogoryTrue";
const String sallesSec = "sallesTrue";
WebSocketChannel serverSocket(String section) {
  try {
    return WebSocketChannel.connect(Uri.parse("$url/$section"));
  } catch (e) {
    print("Error from Websocket Creation $e");
    throw e;
  }
}
