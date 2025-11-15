import 'emergency_type.dart';

/// Sentinel value for copyWith to distinguish between null and not provided
const _undefined = Object();

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
  /// To explicitly set nullable fields to null, use the provided wrapper:
  /// - Pass `type: null` directly (not wrapped) to set type to null
  /// - Same for `location`
  RapidEmergencyRequest copyWith({
    String? id,
    Object? type = _undefined,
    DateTime? createdAt,
    Object? location = _undefined,
    bool? isHighPriority,
  }) {
    return RapidEmergencyRequest(
      id: id ?? this.id,
      type: type == _undefined ? this.type : type as EmergencyType?,
      createdAt: createdAt ?? this.createdAt,
      location: location == _undefined
          ? this.location
          : location as EmergencyLocation?,
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
