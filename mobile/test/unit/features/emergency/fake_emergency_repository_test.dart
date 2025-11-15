import 'package:flutter_test/flutter_test.dart';
import 'package:shongkot_app/features/emergency/data/fake_emergency_repository.dart';
import 'package:shongkot_app/features/emergency/domain/emergency_type.dart';
import 'package:shongkot_app/features/emergency/domain/rapid_emergency_request.dart';

void main() {
  group('FakeEmergencyRepository', () {
    late FakeEmergencyRepository repository;

    setUp(() {
      repository = FakeEmergencyRepository();
    });

    tearDown(() {
      repository.clearHistory();
    });

    test('should send and store emergency request', () async {
      // Arrange
      final request = RapidEmergencyRequest(
        id: 'test-id',
        createdAt: DateTime.now(),
        type: EmergencyType.violentCrime,
      );

      // Act
      await repository.sendRapidEmergency(request);

      // Assert
      expect(repository.getLastEmergency(), request);
      expect(repository.getEmergencyHistory(), contains(request));
    });

    test('should store multiple emergencies in history', () async {
      // Arrange
      final request1 = RapidEmergencyRequest(
        id: 'test-id-1',
        createdAt: DateTime.now(),
      );
      final request2 = RapidEmergencyRequest(
        id: 'test-id-2',
        createdAt: DateTime.now(),
      );

      // Act
      await repository.sendRapidEmergency(request1);
      await repository.sendRapidEmergency(request2);

      // Assert
      final history = repository.getEmergencyHistory();
      expect(history.length, 2);
      expect(history, contains(request1));
      expect(history, contains(request2));
      expect(repository.getLastEmergency(), request2);
    });

    test('should clear history', () async {
      // Arrange
      final request = RapidEmergencyRequest(
        id: 'test-id',
        createdAt: DateTime.now(),
      );
      await repository.sendRapidEmergency(request);

      // Act
      repository.clearHistory();

      // Assert
      expect(repository.getLastEmergency(), isNull);
      expect(repository.getEmergencyHistory(), isEmpty);
    });

    test('should return null when no emergency sent', () {
      // Assert
      expect(repository.getLastEmergency(), isNull);
    });

    test('should simulate network delay', () async {
      // Arrange
      final request = RapidEmergencyRequest(
        id: 'test-id',
        createdAt: DateTime.now(),
      );
      final stopwatch = Stopwatch()..start();

      // Act
      await repository.sendRapidEmergency(request);
      stopwatch.stop();

      // Assert
      // Should take at least 200ms (fake delay is 300ms but test can be faster)
      expect(stopwatch.elapsedMilliseconds, greaterThan(100));
    });
  });
}
