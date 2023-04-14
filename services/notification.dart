import 'package:reel_t/events/message/stream_conversations/stream_conversations_event.dart';
import 'package:reel_t/events/user/retrieve_user_profile/retrieve_user_profile_event.dart';
import 'package:reel_t/generated/app_init.dart';
import 'package:reel_t/generated/app_store.dart';
import 'package:reel_t/models/conversation/conversation.dart';
import 'package:platform_local_notifications/platform_local_notifications.dart';
import 'package:reel_t/models/message/message.dart' as ms;
import 'package:reel_t/models/user_profile/user_profile.dart';

class Notification with StreamConversationsEvent, RetrieveUserProfileEvent {
  bool _isFirstConnect = true;
  String _currentUserId = "";
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
    _currentUserId = userId;
    sendStreamConversationsEvent(_currentUserId);
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

    _latestConversation = updatedConversations.last;
    var message = ms.Message.fromStringJson(_latestConversation!.latestMessage);
    sendRetrieveUserProfileEvent(message.userId);
  }

  @override
  Future<void> onRetrieveUserProfileEventDone(e, UserProfile? userProfile,
      [String? ConversationId]) async {
    if (e != null) return;

    var conversation = _latestConversation;
    var message;
    if (conversation!.latestMessage.isNotEmpty)
      message = ms.Message.fromStringJson(conversation.latestMessage);
    if (message == null) return;
    if (message.userId == _currentUserId) return;

    await PlatformNotifier.I.showPluginNotification(
      ShowPluginNotificationModel(
        id: DateTime.now().second,
        title: "${userProfile!.fullName} send you message",
        body: message.content,
      ),
    );
  }
}
