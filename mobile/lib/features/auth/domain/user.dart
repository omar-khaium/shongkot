/// User model representing an authenticated user
class User {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final String? photoUrl;
  final String token;
  final String refreshToken;

  const User({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    this.photoUrl,
    required this.token,
    required this.refreshToken,
  });

  /// Create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'photoUrl': photoUrl,
      'token': token,
      'refreshToken': refreshToken,
    };
  }

  /// Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? photoUrl,
    String? token,
    String? refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
