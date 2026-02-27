import 'package:echochat/data/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationService {
  final supabase = Supabase.instance.client;

  Future<void> connectUser  (Profile p) async{
   final convo = await supabase.from("conversation").insert({}).select();
   await supabase.from("conversation_participants").insert([
    {
      "user_id":supabase.auth.currentUser!.id,
      "conversation_id":convo[0]["id"]
    },
    {
      "user_id":p.id,
      "conversation_id":convo[0]["id"]
    }
   ]);

  }
}
