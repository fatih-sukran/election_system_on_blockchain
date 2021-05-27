import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() {
  var key = utf8.encode('p@ssw0rd');
  var bytes = utf8.encode('foobar');

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);

  print('HMAC digest as bytes: ${digest.bytes}');
  print('HMAC digest as hex string: $digest');
}