import 'dart:async';
import 'dart:convert';
import 'package:reel_t/events/notification/stream_user_notification/stream_user_notification_event.dart';
import 'package:reel_t/events/notification/update_notification/update_notification_event.dart';
import 'package:platform_local_notifications/platform_local_notifications.dart';
import 'package:reel_t/generated/abstract_service.dart';
import 'package:reel_t/generated/app_init.dart';
import 'package:reel_t/models/conversation/conversation.dart';
import 'package:reel_t/models/user_profile/user_profile.dart';

import '../../generated/app_store.dart';
import '../../models/notification/notification.dart';
import '../../models/message/message.dart' as ms;

class ReceiveNotification extends AbstractService
    with StreamUserNotificationEvent, UpdateNotificationEvent {
  static String CONTACT_USER_KEY = "contact_user_key";
  static String NEW_MESSAGE_KEY = "new_message_key";
  static String PUSH_CONVERSATION_KEY = "push_conversation_key";
  bool? _isGrantPermission = false;
  String _currentConversation = "";
  bool isTurnOffNotification = false;

  Future<void> init() async {
    if (appStore.isWeb()) return;

    _isGrantPermission = await PlatformNotifier.I.requestPermissions();
  }

  void turnOnNotification(String conversationId) {
    _currentConversation = conversationId;
  }

  void turnOffNotification() {
    _currentConversation = "";
  }

  void setNotificationStream(String userId) {
    disposeStreamUserNotificationEvent();
    if (userId == "" || _isGrantPermission == null || !_isGrantPermission!)
      return;
    sendStreamUserNotificationEvent(userId);
  }

  @override
  Future<void> onStreamUserNotificationEventDone(
      List<Notification> userNotifications) async {
    for (var notification in userNotifications) {
      if (notification.hasPushed) continue;
      _showMessage(notification);

      notification.hasPushed = true;
      await sendUpdateNotificationEvent(notification);
    }
  }

  String _getContent(Notification notification) {
    if (notification.notificationType == NotificationType.NEW_MESSAGE.name) {
      Map<String, dynamic> detailMessage =
          json.decode(notification.notificationContent);
      var message =
          ms.Message.fromStringJson(detailMessage[NEW_MESSAGE_KEY] ?? "");
      return message.content;
    }
    return "";
  }

  String _getTitle(Notification notification) {
    if (notification.notificationType == NotificationType.NEW_MESSAGE.name) {
      Map<String, dynamic> detailMessage =
          json.decode(notification.notificationContent);
      var user =
          UserProfile.fromStringJson(detailMessage[CONTACT_USER_KEY] ?? "");
      return "${user.fullName} send you new message";
    }
    return "";
  }

  Future<void> _showMessage(Notification notification) async {
    var title = _getTitle(notification);
    var content = _getContent(notification);
    Map<String, dynamic> detailMessage =
        json.decode(notification.notificationContent);
    var conversation =
        Conversation.fromStringJson(detailMessage[PUSH_CONVERSATION_KEY] ?? "");

    if (conversation.id == _currentConversation) return;

    await PlatformNotifier.I.showPluginNotification(
      ShowPluginNotificationModel(
        id: DateTime.now().second,
        title: title,
        body: content,
        payload: notification.toStringJson(),
      ),
    );
  }

  @override
  void onUpdateNotificationEventDone(Notification updatedNotification) {
    // TODO: implement onUpdateNotificationEventDone
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
