import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';

class ConversationService {
  static final thresholdTime = DateTime.now().subtract(
    const Duration(minutes: 10),
  );

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
    return supabase
        .from('conversation')
        .stream(primaryKey: ['id', 'last_message'])
        .gt('last_time', thresholdTime)
        .order('last_time', ascending: false)
        .map((rows) => rows.map((row) => Conversation.fromJson(row)).toList());
  }

  static Future<List<Conversation>> getInitialConversations({
    int limit = 20,
  }) async {
    final response = await supabase
        .from('conversation')
        .select()
        .lt('last_time', thresholdTime)
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
