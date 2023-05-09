import 'package:reel_t/generated/app_init.dart';
import 'package:reel_t/generated/app_store.dart';

import '../../generated/abstract_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

// e.g. "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
class DeviceInfo extends AbstractService {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppStore _appStore = AppInit.appStore;
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;
  WebBrowserInfo? webBrowserInfo;

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<void> init() async {
    if (_appStore.isAndroid()) {
      androidInfo = await deviceInfo.androidInfo;
      return;
    }
    if (_appStore.isIOS()) {
      iosInfo = await deviceInfo.iosInfo;
      return;
    }

    webBrowserInfo = await deviceInfo.webBrowserInfo;
  }

  String getDeviceId() {
    if (_appStore.isAndroid()) {
      return androidInfo?.id ?? "";
    }
    if (_appStore.isIOS()) {
      return iosInfo?.identifierForVendor ?? "";
    }

    return webBrowserInfo?.userAgent ?? "";
  }
}
