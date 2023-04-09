import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../models/user_profile/user_profile.dart';
import 'package:reel_t/shared_product/services/local_storage.dart';

class LocalUser {
  late Box<UserProfile> _userBox;
  String USER_PATH = UserProfile.PATH;
  String LOCAL_USER_KEY = "local_user_key";
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProfileAdapter());
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

  void login(UserProfile userProfile) {
    if (isLogin()) return;
    _userBox.put(LOCAL_USER_KEY, userProfile);
  }

  void logout() {
    if (!isLogin()) return;
    _userBox.get(LOCAL_USER_KEY)!.delete();
  }
}
