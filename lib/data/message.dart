class Message {
  final int id;
  final DateTime createdAt;
  final String content;
  final String type;
  final String senderId;
  final int? conversationId;

  const Message({
    required this.id,
    required this.createdAt,
    required this.content,
    required this.type,
    required this.senderId,
    required this.conversationId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
      senderId: json['sender_id'] as String,
      conversationId: json['conversation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'content': content,
      'type': type,
      'sender_id': senderId,
      'conversation_id': conversationId,
    };
  }

  Message copyWith({
    int? id,
    DateTime? createdAt,
    String? content,
    String? type,
    String? senderId,
    int? conversationId,
  }) {
    return Message(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      conversationId: conversationId ?? this.conversationId,
    );
  }

  bool get isText => type == 'text';
  bool get isImage => type == 'image';
  bool get isFile => type == 'file';
}