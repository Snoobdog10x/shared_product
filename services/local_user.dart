import 'package:hive/hive.dart';

import '../../models/user_profile/user_profile.dart';

class LocalUser {
  late Box<UserProfile> _userBox;
  String USER_PATH = UserProfile.PATH;
  String LOCAL_USER_KEY = "local_user_key";
  Future<void> init() async {
    var userAdapter = UserProfileAdapter();
    if (!Hive.isAdapterRegistered(userAdapter.typeId)) {
      Hive.registerAdapter(userAdapter);
    }

    _userBox = await Hive.openBox(USER_PATH);
  }

  UserProfile getCurrentUser() {
    if (!isLogin()) {
      return UserProfile(fullName: "Guest");
    }

    var currentUser = _userBox.get(LOCAL_USER_KEY)!;
    return currentUser;
  }

  void clearUser() {
    _userBox.clear();
  }

  bool isLogin() {
    return _userBox.get(LOCAL_USER_KEY) != null;
  }

  Future<void> login(UserProfile userProfile) async {
    await _userBox.put(LOCAL_USER_KEY, userProfile);
  }

  Future<void> logout() async {
    clearUser();
  }
}
