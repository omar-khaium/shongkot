import 'package:flutter_test/flutter_test.dart';
import 'package:shongkot_app/features/emergency/domain/emergency.dart';
import 'package:shongkot_app/features/emergency/domain/emergency_type.dart';
import 'package:shongkot_app/features/emergency/domain/rapid_emergency_request.dart';

void main() {
  group('Emergency', () {
    test('should create Emergency from RapidEmergencyRequest', () {
      // Arrange
      final request = RapidEmergencyRequest(
        id: 'test-id',
        type: EmergencyType.violentCrime,
        createdAt: DateTime(2024, 1, 1),
        location: const EmergencyLocation(latitude: 23.8103, longitude: 90.4125),
        isHighPriority: true,
      );

      // Act
      final emergency = Emergency.fromRequest(request);

      // Assert
      expect(emergency.id, request.id);
      expect(emergency.type, request.type);
      expect(emergency.createdAt, request.createdAt);
      expect(emergency.location, request.location);
      expect(emergency.isHighPriority, request.isHighPriority);
      expect(emergency.status, EmergencyStatus.pending);
    });

    test('should create Emergency with custom status', () {
      // Arrange
      final request = RapidEmergencyRequest(
        id: 'test-id',
        createdAt: DateTime.now(),
      );

      // Act
      final emergency = Emergency.fromRequest(
        request,
        status: EmergencyStatus.resolved,
      );

      // Assert
      expect(emergency.status, EmergencyStatus.resolved);
    });

    test('should copy emergency with updated fields', () {
      // Arrange
      final emergency = Emergency(
        id: 'test-id',
        createdAt: DateTime(2024, 1, 1),
        status: EmergencyStatus.pending,
      );

      // Act
      final updated = emergency.copyWith(
        status: EmergencyStatus.resolved,
        updatedAt: DateTime(2024, 1, 2),
      );

      // Assert
      expect(updated.id, emergency.id);
      expect(updated.status, EmergencyStatus.resolved);
      expect(updated.updatedAt, DateTime(2024, 1, 2));
    });

    test('should have correct equality', () {
      // Arrange
      final emergency1 = Emergency(
        id: 'test-id',
        createdAt: DateTime(2024, 1, 1),
        type: EmergencyType.violentCrime,
        status: EmergencyStatus.pending,
      );

      final emergency2 = Emergency(
        id: 'test-id',
        createdAt: DateTime(2024, 1, 1),
        type: EmergencyType.violentCrime,
        status: EmergencyStatus.pending,
      );

      final emergency3 = Emergency(
        id: 'test-id-2',
        createdAt: DateTime(2024, 1, 1),
        type: EmergencyType.violentCrime,
        status: EmergencyStatus.pending,
      );

      // Assert
      expect(emergency1, equals(emergency2));
      expect(emergency1, isNot(equals(emergency3)));
    });
  });

  group('EmergencyStatus', () {
    test('should have correct display names', () {
      expect(EmergencyStatus.pending.displayName, 'Pending');
      expect(EmergencyStatus.active.displayName, 'Active');
      expect(EmergencyStatus.resolved.displayName, 'Resolved');
      expect(EmergencyStatus.cancelled.displayName, 'Cancelled');
    });
  });

  group('EmergencyLocation', () {
    test('should have correct equality', () {
      // Arrange
      const location1 = EmergencyLocation(latitude: 23.8103, longitude: 90.4125);
      const location2 = EmergencyLocation(latitude: 23.8103, longitude: 90.4125);
      const location3 = EmergencyLocation(latitude: 23.8104, longitude: 90.4125);

      // Assert
      expect(location1, equals(location2));
      expect(location1, isNot(equals(location3)));
    });

    test('should have correct string representation', () {
      // Arrange
      const location = EmergencyLocation(latitude: 23.8103, longitude: 90.4125);

      // Assert
      expect(location.toString(), 'EmergencyLocation(lat: 23.8103, lng: 90.4125)');
    });
  });
}
