import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/models/conversation_list_view.dart';
import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';

class ConversationListData {
  final Conversation conversation;
  final Profile otherUser;
  final Message? lastMessage;
  ConversationListData({
    required this.conversation,
    required this.otherUser,
    this.lastMessage,
  });
}

class ConversationService {
  static Future<void> connectUser(Profile p) async {
    final convo = await supabase.from("conversation").insert({}).select();
    await supabase.from("conversation_participants").insert([
      {
        "user_id": supabase.auth.currentUser!.id,
        "conversation_id": convo[0]["id"],
      },
      {"user_id": p.id, "conversation_id": convo[0]["id"]},
    ]);
    logger.d(
      "ConversationService: connectUser: Connected ${p.name} with current user in conversation ${convo[0]["id"]}",
    );
  }

  static Stream<List<ConversationListView>> streamUserConversations({
    int limit = 20,
  }) {
    final currentUser = supabase.auth.currentUser!;
    final currentUserId = currentUser.id;

    return supabase
        .from('conversation_list_view')
        .stream(primaryKey: ['conversation_id'])
        .eq('current_user_id', currentUserId) // adjust if column name differs
        .order('last_time', ascending: false)
        .limit(limit)
        .map(
          (rows) =>
              rows.map((row) => ConversationListView.fromJson(row)).toList(),
        );
  }

  static Future<List<ConversationListView>> getMoreConversations({
    required DateTime lastFetchedLastTime,
    int limit = 20,
  }) async {
    final currentUser = supabase.auth.currentUser!;
    final currentUserId = currentUser.id;

    final response = await supabase
        .from('conversation_list_view')
        .select()
        .eq('current_user_id', currentUserId) // adjust if needed
        .lt('last_time', lastFetchedLastTime.toIso8601String())
        .order('last_time', ascending: false)
        .limit(limit);

    return response
        .map<ConversationListView>((row) => ConversationListView.fromJson(row))
        .toList();
  }
  
}
