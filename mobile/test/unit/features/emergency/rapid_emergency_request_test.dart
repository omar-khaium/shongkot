import 'package:flutter_test/flutter_test.dart';
import 'package:shongkot_app/features/emergency/domain/emergency_type.dart';
import 'package:shongkot_app/features/emergency/domain/rapid_emergency_request.dart';

void main() {
  group('RapidEmergencyRequest', () {
    test('should create a valid emergency request', () {
      // Arrange
      final location = const EmergencyLocation(
        latitude: 23.8103,
        longitude: 90.4125,
      );
      final now = DateTime.now();

      // Act
      final request = RapidEmergencyRequest(
        id: 'test-id',
        createdAt: now,
        location: location,
        isHighPriority: true,
        type: EmergencyType.violentCrime,
      );

      // Assert
      expect(request.id, 'test-id');
      expect(request.createdAt, now);
      expect(request.location, location);
      expect(request.isHighPriority, true);
      expect(request.type, EmergencyType.violentCrime);
    });

    test('should create request with null type', () {
      // Act
      final request = RapidEmergencyRequest(
        id: 'test-id',
        createdAt: DateTime.now(),
        location: null,
        isHighPriority: true,
      );

      // Assert
      expect(request.type, isNull);
      expect(request.location, isNull);
    });

    test('should default isHighPriority to true', () {
      // Act
      final request = RapidEmergencyRequest(
        id: 'test-id',
        createdAt: DateTime.now(),
      );

      // Assert
      expect(request.isHighPriority, true);
    });

    test('should create copy with updated fields', () {
      // Arrange
      final original = RapidEmergencyRequest(
        id: 'test-id',
        createdAt: DateTime.now(),
        location: null,
      );

      // Act
      final updated = original.copyWith(
        type: EmergencyType.sexualAssault,
      );

      // Assert
      expect(updated.id, original.id);
      expect(updated.createdAt, original.createdAt);
      expect(updated.type, EmergencyType.sexualAssault);
      expect(original.type, isNull); // Original unchanged
    });

    test('should explicitly set nullable fields to null with copyWith', () {
      // Arrange
      final location = const EmergencyLocation(latitude: 1.0, longitude: 2.0);
      final original = RapidEmergencyRequest(
        id: 'test-id',
        createdAt: DateTime.now(),
        location: location,
        type: EmergencyType.violentCrime,
      );

      // Act - explicitly set nullable fields to null
      final updated = original.copyWith(
        type: null,
        location: null,
      );

      // Assert
      expect(updated.type, isNull);
      expect(updated.location, isNull);
      expect(original.type, EmergencyType.violentCrime); // Original unchanged
      expect(original.location, location); // Original unchanged
    });
  });

  group('EmergencyLocation', () {
    test('should create a valid location', () {
      // Act
      const location = EmergencyLocation(
        latitude: 23.8103,
        longitude: 90.4125,
      );

      // Assert
      expect(location.latitude, 23.8103);
      expect(location.longitude, 90.4125);
    });

    test('should have equality', () {
      // Arrange
      const location1 = EmergencyLocation(latitude: 1.0, longitude: 2.0);
      const location2 = EmergencyLocation(latitude: 1.0, longitude: 2.0);
      const location3 = EmergencyLocation(latitude: 1.0, longitude: 3.0);

      // Assert
      expect(location1, equals(location2));
      expect(location1, isNot(equals(location3)));
    });
  });

  group('EmergencyType', () {
    test('should have correct display names', () {
      expect(
        EmergencyType.violentCrime.displayName,
        'Violent Crime',
      );
      expect(
        EmergencyType.sexualAssault.displayName,
        'Sexual Assault / Rape',
      );
      expect(
        EmergencyType.physicalAssault.displayName,
        'Physical Assault / Beating',
      );
      expect(
        EmergencyType.kidnapping.displayName,
        'Kidnapping / Abduction',
      );
      expect(
        EmergencyType.otherViolentCrime.displayName,
        'Other Violent Crime',
      );
    });
  });
}
