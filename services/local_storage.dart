import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final String SIGNED_IN_USER_CACHE_KEY = "sign_in_user";
  static final String CONVERSATIONS_KEY = "conversations_key";
  SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> setCache(String key, String value) async {
    if (_preferences == null) return false;

    bool isSet = await _preferences!.setString(key, value);
    return isSet;
  }

  Future<bool> setListCache(String key, List<String> values) async {
    if (_preferences == null) return false;
    bool isSet = await _preferences!.setStringList(key, values);
    return isSet;
  }

  List<String> getListStringCache(String key) {
    if (_preferences == null) return [];

    var data = _preferences!.getStringList(key);
    if (data == null) return [];

    return data;
  }

  String getCache(String key) {
    if (_preferences == null) return "";

    var data = _preferences!.getString(key);
    if (data == null) return "";

    return data;
  }

  void removeCache(String key) {
    if (_preferences == null) return;
    _preferences!.remove(key);
  }
}
