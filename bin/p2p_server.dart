import 'dart:io';

import 'main.dart';

class P2pServer {
  ServerSocket server;

  Future<void> start() async {
    var i;
    var host = [InternetAddress.anyIPv4, '127.0.0.1', 'localhost'];
    for (i = 0; i < 3; i++) {
      try {
        server = await ServerSocket.bind(host[i], port);
      } catch (e) {
        print('${host[i]} çalışmadı');
        continue;
      }
      break;
    }

    if (i == 3) exit(1);

    server.listen((client) {
      print('Connection from'
          ' ${client.remoteAddress.address}:${client.remotePort}');

      client.listen(
        (data) async {
          var message = String.fromCharCodes(data);
          //var json = jsonDecode(message);
          print('Server: message -> $message');
          //createBlocks(blockchain, transactionCount: 2, blockCount: 1);
          if (i < 10) {
            await Future.delayed(Duration(seconds: 3));
            client.write('${++i}');
          } else {
            await server.close();
          }
        },
        onError: () {
          print('error');
        },
        onDone: () {
          print('Client left');
          client.close();
        },
      );
    });
  }

  Future<void> close() async {
    await server.close();
  }
}
