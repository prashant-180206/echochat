import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';

class ConversationService {
  /// create a conversation between current user and another user
  static Future<void> connectUser(Profile p) async {
    final currentUserId = supabase.auth.currentUser!.id;

    try {
      // 1. Create the conversation record
      // We select it back to get the ID
      final convo = await supabase
          .from("conversation")
          .insert({
            'unread': 0,
            'last_message_content': 'Started a new conversation',
          })
          .select()
          .single();

      final conversationId = convo["id"];

      // 2. Insert both participants at once
      // This triggers our 'trigger_refresh_members' SQL function automatically
      await supabase.from("conversation_participants").insert([
        {"user_id": currentUserId, "conversation_id": conversationId},
        {"user_id": p.id, "conversation_id": conversationId},
      ]);

      logger.d(
        "ConversationService: Successfully connected with ${p.name}. ID: $conversationId",
      );
    } catch (e) {
      logger.e("ConversationService: Failed to connect user: $e");
      rethrow;
    }
  }

  /// REALTIME STREAM
  /// Listens to the physical 'conversation' table.
  /// RLS handles the security so the user only sees their own chats.
  static Stream<List<Conversation>> streamConversations({int limit = 20}) {
    return supabase
        .from('conversation') // Use the table, not the view
        .stream(primaryKey: ['id'])
        .order('last_time', ascending: false)
        .limit(limit)
        .map((rows) => rows.map((row) => Conversation.fromJson(row)).toList());
  }

  /// INITIAL FETCH
  /// Gets the latest conversations (no time cutoff needed usually,
  /// as the stream takes over for real-time updates).
  static Future<List<Conversation>> getInitialConversations({
    int limit = 20,
  }) async {
    final response = await supabase
        .from('conversation')
        .select()
        .order('last_time', ascending: false)
        .limit(limit);

    return response.map((row) => Conversation.fromJson(row)).toList();
  }

  /// PAGINATION
  /// Fetches conversations older than the oldest one currently in the list.
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
