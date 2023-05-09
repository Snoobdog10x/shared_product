import 'package:hive/hive.dart';
import 'package:reel_t/events/setting/retrieve_user_setting/retrieve_user_setting_event.dart';
import 'package:reel_t/generated/abstract_service.dart';
import 'package:reel_t/generated/app_init.dart';
import 'package:reel_t/generated/app_store.dart';
import 'package:reel_t/models/setting/setting.dart';

class LocalSetting extends AbstractService with RetrieveUserSettingEvent {
  late Box<Setting> _settingBox;
  String SETTING_PATH = Setting.PATH;
  AppStore appStore = AppInit.appStore;

  Future<void> init() async {
    var userId = appStore.localUser.getCurrentUser().id;
    var settingAdapter = SettingAdapter();
    if (!Hive.isAdapterRegistered(settingAdapter.typeId)) {
      Hive.registerAdapter(settingAdapter);
    }

    _settingBox = await Hive.openBox(SETTING_PATH);
    if (userId != "") syncUserSetting(userId);
    isInitialized = true;
  }

  Future<void> syncUserSetting(String userId) async {
    if (!isInitialized) return;

    await sendRetrieveUserSettingEvent(userId);
  }

  Future<void> clearSetting({String? userId}) async {
    if (!isInitialized) return;
    if (userId == null) {
      await _settingBox.clear();
      return;
    }

    await _settingBox.delete(userId);
  }

  Future<void> setUserSetting(Setting userSetting) async {
    if (!isInitialized) return;
    await _settingBox.put(userSetting.userId, userSetting);
  }

  Future<Setting?> getUserSetting(String userId) async {
    if (!isInitialized) return null;
    var userSetting = _settingBox.get(userId);

    return userSetting;
  }

  @override
  void onRetrieveUserSettingEventDone(Setting? setting) {
    if (!isInitialized) return;
    if (setting != null) setUserSetting(setting);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
