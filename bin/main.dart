import 'dart:io';
import 'dart:math';
import 'package:pretty_json/pretty_json.dart';

import 'blockchain.dart';
import 'p2p_client.dart';
import 'p2p_server.dart';
import 'transaction.dart';

var blockchain = Blockchain();
var port = 0;
var choise;
var name;
Future<void> main(List<String> args) async {
  createBlocks(blockchain, blockCount: 2, transactionCount: 3);
  if (args.isEmpty) {
    print('Your Name: ');
    name = stdin.readLineSync();
    print('Your Port: ');
    port = int.parse(stdin.readLineSync());
  } else {
    name = args[0];
    port = int.parse(args[1]);
  }

  final client = P2pClient();
  final server = P2pServer();
  await server.start();
  print(':::Server Başlatıldı..');

  while (true) {
    choise = menu();
    if (choise == 4) {
      //await server.close();
      //await client.close();
      break;
    }

    switch (choise) {
      case 1:
        print('Port: ');
        var serverPort = int.parse(stdin.readLineSync());
        await client.connect(serverPort);
        break;
      case 2:
        print('To');
        var to = stdin.readLineSync();
        print('Amount: ');
        var amount = int.parse(stdin.readLineSync());
        blockchain.createTransaction(Transaction(name, to, amount));
        blockchain.processPendingTransaction(name);
        //serverdan broadcast yapılmalı
        break;
      case 3:
        printPrettyJson(blockchain.toJson());
        break;
      default:
        print('Hatalı giriş');
        break;
    }
  }
  print('isValid2: ${blockchain.isValid()}');
}

void createBlocks(Blockchain blockchain,
    {int blockCount = 1, int transactionCount = 1}) {
  var address = ['ismail', 'fatih', 'kutsal', 'sistem'];
  var amount = [10, 20, 30, 40, 50, 60, 80, 90, 100];
  var random = Random();
  for (var i = 0; i < blockCount; i++) {
    for (var j = 0; j < transactionCount; j++) {
      blockchain.createTransaction(Transaction(
          address[random.nextInt(address.length)],
          address[random.nextInt(address.length)],
          amount[random.nextInt(amount.length)]));
    }
    blockchain.processPendingTransaction(name);
  }
}

int menu() {
  print('=========================');
  print('1. Server a Baglan');
  print('2. Transaction Ekle');
  print('3. Blockchain i Goster');
  print('4. Cikis');
  print('=========================');
  print('Choise: ');
  return int.parse(stdin.readLineSync());
}
