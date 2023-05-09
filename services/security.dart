import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:reel_t/generated/abstract_service.dart';

class Security extends AbstractService {
  String hashPassword(String inputPassword) {
    var bytes = utf8.encode(inputPassword);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() {
    isInitialized = true;
  }
}
