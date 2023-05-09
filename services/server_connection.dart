import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reel_t/generated/abstract_service.dart';
import 'package:reel_t/generated/app_init.dart';
import 'package:reel_t/generated/app_store.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ServerConnection extends AbstractService {
  AppStore _appStore = AppInit.appStore;
  StreamSubscription<DatabaseEvent>? _connectionStream;
  final connectedRef = FirebaseDatabase.instance;
  void Function(bool isConnected)? _connectionChangeCallBack;
  void setCallBack(void Function(bool isConnected) _connectionChangeCallBack) {
    this._connectionChangeCallBack = _connectionChangeCallBack;
  }

  Timer? _connectionTimer;
  void init() {
    dispose();
    try {
      _connectionStream =
          connectedRef.ref(".info/connected").onValue.listen((event) {
        final connected = event.snapshot.value as bool? ?? false;
        if (connected) {
          debugPrint("Connected.");
        } else {
          debugPrint("Not connected.");
        }

        _connectionChangeCallBack?.call(connected);
      });

      _connectionTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
        var deviceId = _appStore.deviceInfo.getDeviceId();
        Map<String, String> connectionState = {};

        if (_appStore.localUser.isLogin()) {
          connectionState = {
            _appStore.localUser.getCurrentUser().id: "connected"
          };
        } else {
          connectionState = {deviceId: "connected"};
        }

        connectedRef.ref("/user_connection").set(connectionState);
      });
      isInitialized = true;
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _connectionStream?.cancel();
    _connectionTimer?.cancel();
  }
}
