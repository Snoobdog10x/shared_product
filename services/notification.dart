import 'package:reel_t/events/message/stream_conversations/stream_conversations_event.dart';
import 'package:reel_t/models/conversation/conversation.dart';
import 'package:platform_local_notifications/platform_local_notifications.dart';

class Notification with StreamConversationsEvent {
  bool _isFirstConnect = true;
  Conversation? _latestConversation;
  bool _isShowNotify = true;
  Future<void> init(bool isWeb) async {
    if (!isWeb) {
      bool? isAccepted = await PlatformNotifier.I.requestPermissions();
      if (isAccepted == null) return;
      if (!isAccepted) return;
    }
  }

  void setNotificationStream(String userId) {
    disposeStreamConversationsEvent();
    _isFirstConnect = true;
    sendStreamConversationsEvent(userId);
  }

  void turnOffNotification() {
    _isShowNotify = false;
  }

  void turnOnNotification() {
    _isShowNotify = true;
  }

  bool hasNewNotification() {
    return _isShowNotify && _latestConversation != null;
  }

  @override
  Future<void> onStreamConversationsEventDone(
      List<Conversation> updatedConversations) async {
    if (updatedConversations.isEmpty) return;
    if (_isFirstConnect) {
      _isFirstConnect = false;
      return;
    }
    await PlatformNotifier.I.showChatNotification(
      model: ShowPluginNotificationModel(
        id: DateTime.now().second,
        title: "title",
        body: "body",
        payload: "test",
      ),
      userImage:
          "https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg",
      conversationTitle: "conversationTitle",
      userName: "userName",
    );
    _latestConversation = updatedConversations.last;
  }
}
