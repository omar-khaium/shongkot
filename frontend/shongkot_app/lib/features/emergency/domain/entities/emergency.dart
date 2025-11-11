import 'package:equatable/equatable.dart';

class Emergency extends Equatable {
  final String id;
  final String userId;
  final EmergencyType type;
  final EmergencyStatus status;
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime timestamp;
  final List<String> notifiedContacts;
  final List<String> respondersAlerted;
  final String? notes;

  const Emergency({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.timestamp,
    this.notifiedContacts = const [],
    this.respondersAlerted = const [],
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        status,
        latitude,
        longitude,
        address,
        timestamp,
        notifiedContacts,
        respondersAlerted,
        notes,
      ];

  Emergency copyWith({
    String? id,
    String? userId,
    EmergencyType? type,
    EmergencyStatus? status,
    double? latitude,
    double? longitude,
    String? address,
    DateTime? timestamp,
    List<String>? notifiedContacts,
    List<String>? respondersAlerted,
    String? notes,
  }) {
    return Emergency(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      timestamp: timestamp ?? this.timestamp,
      notifiedContacts: notifiedContacts ?? this.notifiedContacts,
      respondersAlerted: respondersAlerted ?? this.respondersAlerted,
      notes: notes ?? this.notes,
    );
  }
}

enum EmergencyType {
  medical,
  accident,
  fire,
  assault,
  other,
}

enum EmergencyStatus {
  active,
  responding,
  resolved,
  cancelled,
}
