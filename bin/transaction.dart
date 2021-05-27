import 'package:crypto/crypto.dart';

class Transaction {
  final String fromAddress;
  final String toAddress;
  final int amount;

  Transaction(this.fromAddress, this.toAddress, this.amount);

  Transaction.fromJson(Map<String, dynamic> json)
      : fromAddress = json['fromAddress'],
        toAddress = json['toAddress'],
        amount = json['amount'];

  Map<String, dynamic> toJson() {
    return {
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'amount': amount
    };
  }

  String calculateHash() {
    return sha256.convert('$fromAddress-$toAddress-$amount'.codeUnits).toString();
  }

  void sign( keyPair) {
    //if (keyPair)
  }
}
