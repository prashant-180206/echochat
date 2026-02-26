class Conversation {
  final int id;
  final DateTime createdAt;
  final int unread;
  final DateTime lastTime;
  final int? lastMessageId;
  final List<String> participantIds;

  const Conversation({
    required this.id,
    required this.createdAt,
    required this.unread,
    required this.lastTime,
    required this.lastMessageId,
    required this.participantIds,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final participants = (json['conversation_participants'] as List<dynamic>?)
            ?.map((e) => e['user_id'] as String)
            .toList() ??
        [];

    return Conversation(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      unread: json['unread'] ?? 0,
      lastTime: DateTime.parse(json['last_time'] as String),
      lastMessageId: json['last_message'],
      participantIds: participants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'unread': unread,
      'last_time': lastTime.toIso8601String(),
      'last_message': lastMessageId,
    };
  }

  Conversation copyWith({
    int? id,
    DateTime? createdAt,
    int? unread,
    DateTime? lastTime,
    int? lastMessageId,
    List<String>? participantIds,
  }) {
    return Conversation(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      unread: unread ?? this.unread,
      lastTime: lastTime ?? this.lastTime,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      participantIds: participantIds ?? this.participantIds,
    );
  }
}