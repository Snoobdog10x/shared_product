import 'package:hive/hive.dart';
import 'package:reel_t/events/setting/retrieve_user_setting/retrieve_user_setting_event.dart';
import 'package:reel_t/models/setting/setting.dart';

class LocalSetting with RetrieveUserSettingEvent {
  late Box<Setting> _settingBox;
  String SETTING_PATH = Setting.PATH;
  String LOCAL_SETTING_USER = "local_setting_user";
  Future<void> init(String userId) async {
    var settingAdapter = SettingAdapter();
    if (!Hive.isAdapterRegistered(settingAdapter.typeId)) {
      Hive.registerAdapter(settingAdapter);
    }

    _settingBox = await Hive.openBox(SETTING_PATH);
    if (userId != "") syncUserSetting(userId);
  }

  void syncUserSetting(String userId) {
    sendRetrieveUserSettingEvent(userId);
  }

  Future<void> clearSetting() async {
    await _settingBox.clear();
  }

  Future<void> setUserSetting(Setting userSetting) async {
    await _settingBox.put(LOCAL_SETTING_USER, userSetting);
  }

  Future<Setting?> getUserSetting() async {
    var userSetting = _settingBox.get(LOCAL_SETTING_USER);

    return userSetting;
  }

  @override
  void onRetrieveUserSettingEventDone(Setting? setting) {
    if (setting != null) setUserSetting(setting);
  }
}
