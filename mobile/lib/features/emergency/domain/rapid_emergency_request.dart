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
  
  /// Accuracy of the location in meters
  final double? accuracy;
  
  /// Altitude in meters above sea level
  final double? altitude;
  
  /// Timestamp when the location was captured
  final DateTime? timestamp;
  
  /// Indicates the quality of the location data
  final LocationAccuracy? accuracyLevel;

  const EmergencyLocation({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.timestamp,
    this.accuracyLevel,
  });

  @override
  String toString() {
    final buffer = StringBuffer('EmergencyLocation(lat: $latitude, lng: $longitude');
    if (accuracy != null) {
      buffer.write(', accuracy: ${accuracy!.toStringAsFixed(1)}m');
    }
    if (accuracyLevel != null) {
      buffer.write(', accuracyLevel: $accuracyLevel');
    }
    if (altitude != null) {
      buffer.write(', altitude: ${altitude!.toStringAsFixed(1)}m');
    }
    if (timestamp != null) {
      buffer.write(', timestamp: $timestamp');
    }
    buffer.write(')');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmergencyLocation &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.accuracy == accuracy &&
        other.altitude == altitude &&
        other.timestamp == timestamp &&
        other.accuracyLevel == accuracyLevel;
  }

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      accuracy.hashCode ^
      altitude.hashCode ^
      timestamp.hashCode ^
      accuracyLevel.hashCode;
}

/// Enum representing the accuracy level of a location reading
enum LocationAccuracy {
  /// High accuracy (< 10 meters)
  high,
  
  /// Medium accuracy (10-50 meters)
  medium,
  
  /// Low accuracy (> 50 meters)
  low,
  
  /// Unknown or unavailable accuracy
  unknown;
  
  /// Create LocationAccuracy from accuracy value in meters
  static LocationAccuracy fromAccuracyValue(double? accuracy) {
    if (accuracy == null) return LocationAccuracy.unknown;
    if (accuracy < 10) return LocationAccuracy.high;
    if (accuracy < 50) return LocationAccuracy.medium;
    return LocationAccuracy.low;
  }
}
