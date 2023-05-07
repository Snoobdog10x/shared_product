import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:reel_t/generated/abstract_service.dart';

import '../../models/user_profile/user_profile.dart';

class LocalUser extends AbstractService{
  UserProfile? _currentProfile;
  late Box<UserProfile> _userBox;
  String USER_PATH = UserProfile.PATH;
  String CURRENT_LOGGED_USER = "current_logged_user";
  Future<void> init() async {
    var userAdapter = UserProfileAdapter();
    if (!Hive.isAdapterRegistered(userAdapter.typeId)) {
      Hive.registerAdapter(userAdapter);
    }

    _userBox = await Hive.openBox(USER_PATH);
  }

  UserProfile getCurrentUser() {
    if (!isLogin()) {
      _currentProfile = UserProfile(fullName: "Guest");
      return _currentProfile!;
    }

    _currentProfile = _userBox.get(CURRENT_LOGGED_USER)!;
    return _currentProfile!;
  }

  Future<int> clearUser() async {
    var currentUser = getCurrentUser();
    var userNums = await _userBox.clear();

    if (currentUser.id.isNotEmpty) {
      await login(currentUser);
      return userNums - 1;
    }

    return userNums;
  }

  bool isLogin() {
    return _userBox.containsKey(CURRENT_LOGGED_USER);
  }

  Future<void> switchAccount(UserProfile userProfile) async {
    await logout();
    await _userBox.delete(userProfile.id);
    await login(userProfile);
  }

  Future<void> login(UserProfile userProfile) async {
    await _userBox.put(CURRENT_LOGGED_USER, userProfile);
    var clonedUser = UserProfile.fromJson(userProfile.toJson());
    await _addLoggedAccount(clonedUser);
  }

  List<UserProfile> getSwitchAccounts() {
    var users = _userBox.toMap();
    if (isLogin()) {
      var currentUser = getCurrentUser();
      users.remove(CURRENT_LOGGED_USER);
      users.remove(currentUser.id);
    }

    return users.values.toList();
  }

  Future<void> _addLoggedAccount(UserProfile userProfile) async {
    await _userBox.put(userProfile.id, userProfile);
  }

  Future<void> logout() async {
    _userBox.delete(CURRENT_LOGGED_USER);
    FirebaseAuth.instance.signOut();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
  }
}
