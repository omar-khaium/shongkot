import 'emergency_type.dart';

/// Entity representing a rapid emergency request
/// This is used for urgent crime reports that need immediate attention
class RapidEmergencyRequest {
  /// Unique identifier for this request
  final String id;

  /// Type of emergency (optional at creation, can be refined later)
  final EmergencyType? type;

  /// Timestamp when the request was created
  final DateTime createdAt;

  /// Location coordinates (latitude, longitude)
  /// Can be null if location is unavailable
  final EmergencyLocation? location;

  /// Whether this is a high priority emergency
  /// Defaults to true for rapid crime SOS
  final bool isHighPriority;

  const RapidEmergencyRequest({
    required this.id,
    this.type,
    required this.createdAt,
    this.location,
    this.isHighPriority = true,
  });

  /// Create a copy with updated fields
  RapidEmergencyRequest copyWith({
    String? id,
    EmergencyType? type,
    DateTime? createdAt,
    EmergencyLocation? location,
    bool? isHighPriority,
  }) {
    return RapidEmergencyRequest(
      id: id ?? this.id,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      isHighPriority: isHighPriority ?? this.isHighPriority,
    );
  }

  @override
  String toString() {
    return 'RapidEmergencyRequest(id: $id, type: $type, createdAt: $createdAt, '
        'location: $location, isHighPriority: $isHighPriority)';
  }
}

/// Value object for location coordinates
class EmergencyLocation {
  final double latitude;
  final double longitude;

  const EmergencyLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'EmergencyLocation(lat: $latitude, lng: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmergencyLocation &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
