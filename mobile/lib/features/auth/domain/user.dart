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
/// User model
class User {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String? name;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;

  const User({
    required this.id,
    this.email,
    this.phoneNumber,
    this.name,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      name: json['name'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

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
      'phoneNumber': phoneNumber,
      'name': name,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? name,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
