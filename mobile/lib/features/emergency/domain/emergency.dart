import 'emergency_type.dart';
import 'rapid_emergency_request.dart';

/// Status of an emergency
enum EmergencyStatus {
  /// Emergency is pending response
  pending,

  /// Emergency is currently active and being handled
  active,

  /// Emergency has been resolved
  resolved,

  /// Emergency was cancelled by user
  cancelled,
}

/// Extension to provide human-readable labels for emergency status
extension EmergencyStatusExtension on EmergencyStatus {
  /// Get display name for the emergency status
  String get displayName {
    switch (this) {
      case EmergencyStatus.pending:
        return 'Pending';
      case EmergencyStatus.active:
        return 'Active';
      case EmergencyStatus.resolved:
        return 'Resolved';
      case EmergencyStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Entity representing an emergency with full details including status
class Emergency {
  /// Unique identifier for this emergency
  final String id;

  /// Type of emergency
  final EmergencyType? type;

  /// Timestamp when the emergency was created
  final DateTime createdAt;

  /// Timestamp when the emergency was last updated
  final DateTime? updatedAt;

  /// Location coordinates
  final EmergencyLocation? location;

  /// Whether this is a high priority emergency
  final bool isHighPriority;

  /// Current status of the emergency
  final EmergencyStatus status;

  /// Optional notes or description
  final String? notes;

  const Emergency({
    required this.id,
    this.type,
    required this.createdAt,
    this.updatedAt,
    this.location,
    this.isHighPriority = true,
    this.status = EmergencyStatus.pending,
    this.notes,
  });

  /// Create Emergency from RapidEmergencyRequest
  factory Emergency.fromRequest(
    RapidEmergencyRequest request, {
    EmergencyStatus status = EmergencyStatus.pending,
  }) {
    return Emergency(
      id: request.id,
      type: request.type,
      createdAt: request.createdAt,
      location: request.location,
      isHighPriority: request.isHighPriority,
      status: status,
    );
  }

  /// Create a copy with updated fields
  Emergency copyWith({
    String? id,
    EmergencyType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    EmergencyLocation? location,
    bool? isHighPriority,
    EmergencyStatus? status,
    String? notes,
  }) {
    return Emergency(
      id: id ?? this.id,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      isHighPriority: isHighPriority ?? this.isHighPriority,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'Emergency(id: $id, type: $type, status: $status, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Emergency &&
        other.id == id &&
        other.type == type &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.location == location &&
        other.isHighPriority == isHighPriority &&
        other.status == status &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      type,
      createdAt,
      updatedAt,
      location,
      isHighPriority,
      status,
      notes,
    );
  }
}
