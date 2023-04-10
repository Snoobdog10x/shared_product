import 'package:reel_t/events/message/stream_conversations/stream_conversations_event.dart';
import 'package:reel_t/models/conversation/conversation.dart';
import 'package:platform_local_notifications/platform_local_notifications.dart';

class Notification with StreamConversationsEvent {
  late Function _notifyDataChanged;
  bool _isFirstConnect = true;
  Conversation? _latestConversation;
  bool _isShowNotify = true;
  Future<void> init(String userId) async {
    if (userId.isEmpty) return;
    await PlatformNotifier.I.init(appName: "Reel T");
    bool? isAccepted = await PlatformNotifier.I.requestPermissions();

    if (isAccepted == null) return;
    if (!isAccepted) return;

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

  Conversation? getLatestConversation() {
    if (hasNewNotification()) {
      var tempConversation = _latestConversation;
      _latestConversation = null;
      return tempConversation;
    }
    return null;
  }

  @override
  Future<void> onStreamConversationsEventDone(
      List<Conversation> updatedConversations) async {
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
