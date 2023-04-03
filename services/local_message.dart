import 'package:hive/hive.dart';
import 'package:reel_t/models/conversation/conversation.dart';
import 'package:reel_t/models/message/message.dart';

class LocalMessenger {
  late Box<Conversation> localConversation;
  late Box<Message> localMessage;
  Future<void> init() async {
    Hive.registerAdapter(ConversationAdapter());
    Hive.registerAdapter(MessageAdapter());
    localConversation = await Hive.openBox(Conversation.PATH);
    localMessage = await Hive.openBox(Message.PATH);
  }

  bool isExistsConversations() {
    return localConversation.isEmpty;
  }

  Future<void> saveConversation(Conversation conversation) async {
    await localConversation.put(conversation.id, conversation);
  }

  Future<void> saveConversations(List<Conversation> conversations) async {
    Map<String, Conversation> putMap = {};
    for (var conversation in conversations) {
      putMap[conversation.id] = conversation;
    }
    await localConversation.putAll(putMap);
  }

  List<Conversation> getConversations() {
    return localConversation.values.toList();
  }
}
