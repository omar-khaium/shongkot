import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final ContactRelationship relationship;
  final bool isPrimary;
  final DateTime createdAt;

  const Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    required this.relationship,
    this.isPrimary = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        email,
        relationship,
        isPrimary,
        createdAt,
      ];

  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    ContactRelationship? relationship,
    bool? isPrimary,
    DateTime? createdAt,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      relationship: relationship ?? this.relationship,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum ContactRelationship {
  family,
  friend,
  colleague,
  neighbor,
  other,
}
