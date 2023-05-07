import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:reel_t/generated/abstract_service.dart';
import 'package:reel_t/generated/app_init.dart';
import 'package:reel_t/generated/app_store.dart';

class ServerConnection extends AbstractService {
  StreamSubscription<DatabaseEvent>? _connectionStream;
  final realtimeDatabase = FirebaseDatabase.instance;
  AppStore _appStore = AppInit.appStore;
  void Function(bool isConnected)? _connectionChangeCallBack;
  void setCallBack(void Function(bool isConnected) _connectionChangeCallBack) {
    this._connectionChangeCallBack = _connectionChangeCallBack;
  }

  void init() {
    _connectionStream = realtimeDatabase
        .ref(".info")
        .child("connected")
        .onValue
        .listen((event) {
      var isConnected = event.snapshot.value as bool;
      if (isConnected)
        print("connected");
      else
        print("disconnect");
        
      _connectionChangeCallBack?.call(isConnected);
    });
  }

  @override
  void dispose() {
    _connectionStream?.cancel();
  }
}
