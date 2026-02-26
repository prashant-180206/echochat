class Profile {
  final String id;
  final DateTime createdAt;
  final String email;
  final String bio;
  final String gender;
  final String avatarUrl;
  final String name;

  const Profile({
    required this.name,
    required this.id,
    required this.createdAt,
    required this.email,
    required this.bio,
    required this.gender,
     required this.avatarUrl,
  });

  /// Create Profile from Supabase JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      gender: json['gender'] ?? '',
      avatarUrl: json['avatar_url'] ?? "",
    );
  }

  /// Convert Profile to JSON (for insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'email': email,
      'bio': bio,
      'gender': gender,
      'avatar_url': avatarUrl,
      'name': name,
    };
  }

  /// Clone with modifications
  Profile copyWith({
    String? id,
    DateTime? createdAt,
    String? email,
    String? bio,
    String? gender,
    String? avatarUrl,
    String? name,
  }) {
    return Profile(
      name: name ?? this.name,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class ProfileDataUpload {
  const ProfileDataUpload({
    required this.name,
    required this.email,
    required this.password,
    required this.bio,
    required this.gender,
  });
  final String name;
  final String email;
  final String password;
  final String bio;
  final String gender;
}