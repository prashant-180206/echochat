import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';

class ConversationService {
  static DateTime get _thresholdTime =>
      DateTime.now().toUtc().subtract(const Duration(minutes: 10));

  static Future<void> connectUser(Profile p) async {
    try {
      final result = await supabase.rpc(
        'create_new_conversation',
        params: {'other_user_id': p.id},
      );

      logger.d("ConversationService: Success! New ID: $result");
    } catch (e) {
      logger.e("ConversationService: Failed to connect user: $e");
      rethrow;
    }
  }

  static Stream<List<Conversation>> streamConversations({int limit = 20}) {
    final tenMinutesAgo = _thresholdTime.toIso8601String();

    return supabase
        .from('conversation')
        .stream(primaryKey: ['id'])
        .gte('last_time', tenMinutesAgo)
        .order('last_time', ascending: false)
        .map((rows) => rows.map((row) => Conversation.fromJson(row)).toList());
  }

  static Future<void> markAsRead(int conversationId) async {
    try {
      logger.d(
        "ConversationService: Marking conversation $conversationId as read",
      );
      await supabase
          .from('conversation')
          .update({'unread': 0})
          .eq('id', conversationId);
      logger.d(
        "ConversationService: Marked conversation $conversationId as read",
      );
    } catch (e) {
      logger.e("ConversationService: Failed to mark conversation as read: $e");
      rethrow;
    }
  }

  static Future<List<Conversation>> getInitialConversations({
    int limit = 20,
  }) async {
    final tenMinutesAgo = _thresholdTime.toIso8601String();

    final response = await supabase
        .from('conversation')
        .select()
        .lt('last_time', tenMinutesAgo)
        .order('last_time', ascending: false)
        .limit(limit);

    return response.map((row) => Conversation.fromJson(row)).toList();
  }

  static Future<List<Conversation>> getMoreConversations({
    required DateTime lastFetchedTime,
    int limit = 20,
  }) async {
    final response = await supabase
        .from('conversation')
        .select()
        .lt('last_time', lastFetchedTime.toIso8601String())
        .order('last_time', ascending: false)
        .limit(limit);

    return response.map((row) => Conversation.fromJson(row)).toList();
  }
}
