import 'dart:convert';

import 'package:crypto/crypto.dart';

class Security {
  String hashPassword(String inputPassword) {
    var bytes = utf8.encode(inputPassword);
    var digest = sha256.convert(bytes);
    print(digest);
    return digest.toString();
  }
}
