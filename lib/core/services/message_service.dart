import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/singleton.dart';

class MessageService {
  static Stream<List<Message>> streamMessagesForConversation(
    int conversationId, {
    int limit = 30,
  }) {
    return supabase
        .from('message')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .limit(limit)
        .map((rows) => rows.map((row) => Message.fromJson(row)).toList());
  }

  static Future<List<Message>> getInitialMessagesForConversation(
    int conversationId, {
    int limit = 30,
  }) async {
    final response = await supabase
        .from('message')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .limit(limit);

    return response.map<Message>((row) => Message.fromJson(row)).toList();
  }

  static Future<List<Message>> getNextMessages({
    required int conversationId,
    required DateTime oldestMessageTime,
    int limit = 30,
  }) async {
    final response = await supabase
        .from('message')
        .select()
        .eq('conversation_id', conversationId)
        .lt('created_at', oldestMessageTime.toIso8601String())
        .order('created_at', ascending: false)
        .limit(limit);

    final messages = response
        .map<Message>((row) => Message.fromJson(row))
        .toList();

    // Reverse to maintain ascending order in UI
    return messages.reversed.toList();
  }

  static Future<Message> sendMessage({
    required int conversationId,
    required String content,
    String type = "text",
  }) async {
    final currentUserId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('message')
        .insert({
          'conversation_id': conversationId,
          'content': content,
          'sender_id': currentUserId,
          'type': type,
        })
        .select()
        .single();

    return Message.fromJson(response);
  }

  static Future<void> deleteMessage(int messageId) async {
    await supabase.from('message').delete().eq('id', messageId);
  }

  static Future<void> editMessage(int messageId, String newContent) async {
    await supabase
        .from('message')
        .update({'content': newContent})
        .eq('id', messageId);
  }
}
