import 'package:echochat/core/models/conversation_list_view.dart';
import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';

class ConversationService {
  /// create a conversation between current user and another user
  static Future<void> connectUser(Profile p) async {
    final convo = await supabase
        .from("conversation")
        .insert({})
        .select()
        .single();

    final conversationId = convo["id"];
    final currentUserId = supabase.auth.currentUser!.id;

    await supabase.from("conversation_participants").insert([
      {"user_id": currentUserId, "conversation_id": conversationId},
      {"user_id": p.id, "conversation_id": conversationId},
    ]);

    logger.d(
      "ConversationService: Connected ${p.name} with current user in conversation $conversationId",
    );
  }

  /// realtime stream of conversations updated in last 10 minutes
  static Stream<List<ConversationListView>> streamRecentChanges({
    int limit = 20,
  }) {
    final currentUserId = supabase.auth.currentUser!.id;

    return supabase
        .from('conversation_list_view')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUserId)
        .order('last_time', ascending: false)
        .limit(limit)
        .map((rows) {
          final cutoff = DateTime.now().subtract(const Duration(minutes: 10));

          return rows
              .map((row) => ConversationListView.fromJson(row))
              .where((c) => c.lastTime.isAfter(cutoff))
              .toList();
        });
  }

  /// initial fetch for conversation list
  static Future<List<ConversationListView>> getStaticConversations({
    int limit = 20,
  }) async {
    final currentUserId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('conversation_list_view')
        .select()
        .eq('user_id', currentUserId)
        .lt(
          "last_time",
          DateTime.now()
              .subtract(const Duration(minutes: 10))
              .toIso8601String(),
        )
        .order('last_time', ascending: false)
        .limit(limit);

    return response
        .map<ConversationListView>((row) => ConversationListView.fromJson(row))
        .toList();
  }

  /// pagination - fetch older conversations
  static Future<List<ConversationListView>> getMoreConversations({
    required DateTime lastFetchedLastTime,
    int limit = 20,
  }) async {
    final currentUserId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from('conversation_list_view')
        .select()
        .eq('user_id', currentUserId)
        .lt('last_time', lastFetchedLastTime.toIso8601String())
        .order('last_time', ascending: false)
        .limit(limit);

    return response
        .map<ConversationListView>((row) => ConversationListView.fromJson(row))
        .toList();
  }
}
