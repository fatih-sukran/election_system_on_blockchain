import 'dart:convert';

import 'package:crypton/crypton.dart';

class Key {
  PublicKey publicKey;
  PrivateKey _privateKey;

  Key() {
    var keyPair = ECKeypair.fromRandom();
    publicKey = keyPair.publicKey;
    _privateKey = keyPair.privateKey;
  }

  Key.fromPrivateKey(String privateKey) {
    var keyPair = ECKeypair(ECPrivateKey.fromString(privateKey));
    publicKey = keyPair.publicKey;
    _privateKey = keyPair.privateKey;
  }

  String sign(String data) {
    return String.fromCharCodes(_privateKey
        .createSHA256Signature(utf8.encode(data)));
  }

  bool verify(String data, String signature) {
    return publicKey.verifySHA256Signature(
        utf8.encode(data), utf8.encode(signature));
  }
}
