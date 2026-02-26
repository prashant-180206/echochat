class Conversation{
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;

  Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}