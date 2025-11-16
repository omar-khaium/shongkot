import 'package:flutter_test/flutter_test.dart';
import 'package:shongkot_app/features/emergency/domain/rapid_emergency_request.dart';

void main() {
  group('EmergencyLocation - Enhanced', () {
    test('should create location with basic coordinates', () {
      // Act
      const location = EmergencyLocation(
        latitude: 23.8103,
        longitude: 90.4125,
      );

      // Assert
      expect(location.latitude, 23.8103);
      expect(location.longitude, 90.4125);
      expect(location.accuracy, isNull);
      expect(location.altitude, isNull);
      expect(location.timestamp, isNull);
      expect(location.accuracyLevel, isNull);
    });

    test('should create location with all fields', () {
      // Arrange
      final timestamp = DateTime.now();

      // Act
      final location = EmergencyLocation(
        latitude: 23.8103,
        longitude: 90.4125,
        accuracy: 5.0,
        altitude: 10.0,
        timestamp: timestamp,
        accuracyLevel: LocationAccuracy.high,
      );

      // Assert
      expect(location.latitude, 23.8103);
      expect(location.longitude, 90.4125);
      expect(location.accuracy, 5.0);
      expect(location.altitude, 10.0);
      expect(location.timestamp, timestamp);
      expect(location.accuracyLevel, LocationAccuracy.high);
    });

    test('should have equality with all fields', () {
      // Arrange
      final timestamp = DateTime.now();
      final location1 = EmergencyLocation(
        latitude: 1.0,
        longitude: 2.0,
        accuracy: 5.0,
        altitude: 10.0,
        timestamp: timestamp,
        accuracyLevel: LocationAccuracy.high,
      );
      final location2 = EmergencyLocation(
        latitude: 1.0,
        longitude: 2.0,
        accuracy: 5.0,
        altitude: 10.0,
        timestamp: timestamp,
        accuracyLevel: LocationAccuracy.high,
      );
      final location3 = EmergencyLocation(
        latitude: 1.0,
        longitude: 3.0,
        accuracy: 5.0,
        altitude: 10.0,
        timestamp: timestamp,
        accuracyLevel: LocationAccuracy.high,
      );

      // Assert
      expect(location1, equals(location2));
      expect(location1, isNot(equals(location3)));
    });

    test('should have different hash codes for different locations', () {
      // Arrange
      const location1 = EmergencyLocation(latitude: 1.0, longitude: 2.0);
      const location2 = EmergencyLocation(latitude: 1.0, longitude: 3.0);

      // Assert
      expect(location1.hashCode, isNot(equals(location2.hashCode)));
    });

    test('should format toString with all fields', () {
      // Arrange
      final timestamp = DateTime.now();
      final location = EmergencyLocation(
        latitude: 23.8103,
        longitude: 90.4125,
        accuracy: 5.5,
        altitude: 10.5,
        timestamp: timestamp,
        accuracyLevel: LocationAccuracy.high,
      );

      // Act
      final str = location.toString();

      // Assert
      expect(str, contains('23.8103'));
      expect(str, contains('90.4125'));
      expect(str, contains('5.5m'));
      expect(str, contains('10.5m'));
      expect(str, contains('high'));
    });
  });

  group('LocationAccuracy', () {
    test('should classify high accuracy correctly', () {
      // Act
      final accuracy = LocationAccuracy.fromAccuracyValue(5.0);

      // Assert
      expect(accuracy, LocationAccuracy.high);
    });

    test('should classify medium accuracy correctly', () {
      // Act
      final accuracy = LocationAccuracy.fromAccuracyValue(25.0);

      // Assert
      expect(accuracy, LocationAccuracy.medium);
    });

    test('should classify low accuracy correctly', () {
      // Act
      final accuracy = LocationAccuracy.fromAccuracyValue(100.0);

      // Assert
      expect(accuracy, LocationAccuracy.low);
    });

    test('should classify unknown accuracy for null', () {
      // Act
      final accuracy = LocationAccuracy.fromAccuracyValue(null);

      // Assert
      expect(accuracy, LocationAccuracy.unknown);
    });

    test('should classify boundary values correctly', () {
      // Act & Assert
      expect(
        LocationAccuracy.fromAccuracyValue(9.9),
        LocationAccuracy.high,
      );
      expect(
        LocationAccuracy.fromAccuracyValue(10.0),
        LocationAccuracy.medium,
      );
      expect(
        LocationAccuracy.fromAccuracyValue(49.9),
        LocationAccuracy.medium,
      );
      expect(
        LocationAccuracy.fromAccuracyValue(50.0),
        LocationAccuracy.low,
      );
    });
  });
}
