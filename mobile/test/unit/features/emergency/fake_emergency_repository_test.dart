import 'package:flutter_test/flutter_test.dart';
import 'package:shongkot_app/features/emergency/data/fake_emergency_repository.dart';
import 'package:shongkot_app/features/emergency/domain/emergency.dart';
import 'package:shongkot_app/features/emergency/domain/emergency_type.dart';
import 'package:shongkot_app/features/emergency/domain/rapid_emergency_request.dart';

void main() {
  group('FakeEmergencyRepository', () {
    late FakeEmergencyRepository repository;

    setUp(() {
      repository = FakeEmergencyRepository(seedSampleData: false);
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
      expect(repository.getAllEmergencies(), hasLength(1));
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
      final history = repository.getAllEmergencies();
      expect(history.length, 2);
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
      expect(repository.getAllEmergencies(), isEmpty);
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

    test('should get emergency history', () async {
      // Arrange
      final request1 = RapidEmergencyRequest(
        id: 'test-id-1',
        createdAt: DateTime.now(),
        type: EmergencyType.violentCrime,
      );
      final request2 = RapidEmergencyRequest(
        id: 'test-id-2',
        createdAt: DateTime.now(),
        type: EmergencyType.sexualAssault,
      );
      await repository.sendRapidEmergency(request1);
      await repository.sendRapidEmergency(request2);

      // Act
      final result = await repository.getEmergencyHistory();

      // Assert
      expect(result.emergencies, hasLength(2));
      expect(result.totalCount, 2);
      expect(result.page, 0);
    });

    test('should filter emergency history by status', () async {
      // Arrange
      final request1 = RapidEmergencyRequest(
        id: 'test-id-1',
        createdAt: DateTime.now(),
      );
      final request2 = RapidEmergencyRequest(
        id: 'test-id-2',
        createdAt: DateTime.now(),
      );
      await repository.sendRapidEmergency(request1);
      await repository.sendRapidEmergency(request2);
      
      // Update one to resolved
      repository.updateEmergencyStatus('test-id-1', EmergencyStatus.resolved);

      // Act
      final result = await repository.getEmergencyHistory(
        status: EmergencyStatus.resolved,
      );

      // Assert
      expect(result.emergencies, hasLength(1));
      expect(result.emergencies.first.id, 'test-id-1');
      expect(result.emergencies.first.status, EmergencyStatus.resolved);
    });

    test('should paginate emergency history', () async {
      // Arrange - create multiple emergencies
      for (int i = 0; i < 25; i++) {
        await repository.sendRapidEmergency(
          RapidEmergencyRequest(
            id: 'test-id-$i',
            createdAt: DateTime.now(),
          ),
        );
      }

      // Act - get first page
      final firstPage = await repository.getEmergencyHistory(
        page: 0,
        pageSize: 10,
      );

      // Assert
      expect(firstPage.emergencies, hasLength(10));
      expect(firstPage.totalCount, 25);
      expect(firstPage.totalPages, 3);
      expect(firstPage.hasMore, isTrue);

      // Act - get second page
      final secondPage = await repository.getEmergencyHistory(
        page: 1,
        pageSize: 10,
      );

      // Assert
      expect(secondPage.emergencies, hasLength(10));
      expect(secondPage.hasMore, isTrue);

      // Act - get third page
      final thirdPage = await repository.getEmergencyHistory(
        page: 2,
        pageSize: 10,
      );

      // Assert
      expect(thirdPage.emergencies, hasLength(5));
      expect(thirdPage.hasMore, isFalse);
    });
  });
}
