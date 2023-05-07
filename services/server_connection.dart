import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:reel_t/generated/abstract_service.dart';

class ServerConnection extends AbstractService {
  StreamSubscription<DatabaseEvent>? _connectionStream;
  final realtimeDatabase = FirebaseDatabase.instance;
  void init() {
    _connectionStream =
        realtimeDatabase.ref(".info/connected").onValue.listen((event) {
      if (event.snapshot.value != null) {
        print("connected");
        return;
      }
      print("disconnected");
    });
  }

  @override
  void dispose() {
    _connectionStream?.cancel();
  }
}
