import 'dart:io';

class P2pClient {
  Socket client;

  Future<void> connect(int port) async {
    var i;
    var host = [InternetAddress.anyIPv4, '127.0.0.1', 'localhost'];
    for (i = 0; i < 3; i++) {
      try {
        client = await Socket.connect(host[i], port);
      } catch (e) {
        print('${host[i]} çalışmadı');
        continue;
      }
      break;
    }

    if (i == 3) exit(1);

    client.listen((message) {
      var data = String.fromCharCodes(message);
      print('Client: gelenData: $data');
      Future.delayed(Duration(seconds: 3));
      if (i < 10) {
        client.write('Client: ${++i}');
      } else {
        client.destroy();
        print('Client: destroy edildi');
        Future.delayed(Duration(seconds: 3));
      }
    }, onDone: () {
      print('Server left');
      client.destroy();
    });
  }

  Future<void> close() async {
    await client.close();
  }
}
