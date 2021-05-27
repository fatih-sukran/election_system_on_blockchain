import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'transaction.dart';

class Block {
  int nonce = 0;
  int index = 0;
  String hash = '';
  String previousHash = '';
  String jsonOfTransaction = '';
  DateTime timeStamp = DateTime.now();
  final List<Transaction> transactions;

  Block(this.transactions);

  Block.fromJson(Map<String, dynamic> json)
      : transactions = [
          for (var i in json['transactions']) Transaction.fromJson(i)
        ],
        index = json['index'],
        nonce = json['nonce'],
        hash = json['hash'],
        previousHash = json['previousHash'],
        jsonOfTransaction = json['jsonOfTransaction'],
        timeStamp = DateTime.fromMicrosecondsSinceEpoch(json['timeStamp']);

  String calculateHash() {
    var input = '${nonce.toString()}-$jsonOfTransaction';
    return sha256.convert(utf8.encode(input)).toString();
  }

  void mineBlock(int difficulty) {
    var leadingZero = '0' * difficulty;
    jsonOfTransaction = toJson().toString();
    while (!hash.startsWith(leadingZero)) {
      nonce++;
      hash = calculateHash();
    }
  }

  String transactionToJson() {
    var sb = StringBuffer();
    sb.write('{');
    for (var transaction in transactions) {
      sb.write(jsonEncode(transaction.toJson()));
      sb.write(',');
    }
    sb.write('}');
    return sb.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'nonce': nonce,
      'hash': hash,
      'previousHash': previousHash,
      'jsonOfTransaction': jsonOfTransaction,
      'timeStamp': timeStamp.microsecondsSinceEpoch,
      'transactions': transactions,
    };
  }
}
