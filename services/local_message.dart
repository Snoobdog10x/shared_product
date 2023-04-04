import 'package:hive/hive.dart';
import 'package:reel_t/models/conversation/conversation.dart';
import 'package:reel_t/models/message/message.dart';

class LocalMessenger {
  late Box<Conversation> _localConversation;
  // late Box<Message> localMessage;
  void clearMessage() {
    _localConversation.clear();
  }

  Future<void> init() async {
    Hive.registerAdapter(ConversationAdapter());
    Hive.registerAdapter(MessageAdapter());
    _localConversation = await Hive.openBox(Conversation.PATH);
    // localMessage = await Hive.openBox(Message.PATH);
  }

  bool isExistsConversations() {
    return _localConversation.values.isNotEmpty;
  }

  Future<void> saveConversation(Conversation conversation) async {
    await _localConversation.put(conversation.id, conversation);
  }

  Future<void> saveConversations(List<Conversation> conversations) async {
    Map<String, Conversation> putMap = {};
    for (var conversation in conversations) {
      putMap[conversation.id] = conversation;
    }
    await _localConversation.putAll(putMap);
  }

  List<Conversation> getConversations() {
    return _localConversation.values.toList();
  }
}
