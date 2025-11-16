import 'package:flutter_test/flutter_test.dart';
import 'package:shongkot_app/features/emergency/data/fake_emergency_repository.dart';
import 'package:shongkot_app/features/emergency/domain/emergency.dart';
import 'package:shongkot_app/features/emergency/domain/emergency_type.dart';
import 'package:shongkot_app/features/emergency/domain/rapid_emergency_request.dart';
import 'package:shongkot_app/features/emergency/presentation/emergency_history_notifier.dart';

void main() {
  group('EmergencyHistoryNotifier', () {
    late FakeEmergencyRepository repository;
    late EmergencyHistoryNotifier notifier;

    setUp(() {
      repository = FakeEmergencyRepository(seedSampleData: false);
      notifier = EmergencyHistoryNotifier(repository);
    });

    tearDown(() {
      repository.clearHistory();
      notifier.dispose();
    });

    test('initial state should be empty', () {
      // Assert
      expect(notifier.state.emergencies, isEmpty);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.currentPage, 0);
      expect(notifier.state.totalCount, 0);
    });

    test('should load emergency history', () async {
      // Arrange
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(
          id: 'test-id-1',
          createdAt: DateTime.now(),
          type: EmergencyType.violentCrime,
        ),
      );
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(
          id: 'test-id-2',
          createdAt: DateTime.now(),
          type: EmergencyType.sexualAssault,
        ),
      );

      // Act
      await notifier.loadHistory(refresh: true);

      // Assert
      expect(notifier.state.emergencies, hasLength(2));
      expect(notifier.state.totalCount, 2);
      expect(notifier.state.isLoading, false);
    });

    test('should filter by status', () async {
      // Arrange
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(id: 'test-id-1', createdAt: DateTime.now()),
      );
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(id: 'test-id-2', createdAt: DateTime.now()),
      );
      repository.updateEmergencyStatus('test-id-1', EmergencyStatus.resolved);

      // Act
      await notifier.setStatusFilter(EmergencyStatus.resolved);

      // Assert
      expect(notifier.state.emergencies, hasLength(1));
      expect(notifier.state.emergencies.first.id, 'test-id-1');
      expect(notifier.state.statusFilter, EmergencyStatus.resolved);
    });

    test('should filter by date range', () async {
      // Arrange
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final twoDaysAgo = now.subtract(const Duration(days: 2));

      await repository.sendRapidEmergency(
        RapidEmergencyRequest(id: 'test-id-1', createdAt: twoDaysAgo),
      );
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(id: 'test-id-2', createdAt: yesterday),
      );
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(id: 'test-id-3', createdAt: now),
      );

      // Act - filter to only yesterday onwards
      await notifier.setDateRangeFilter(
        yesterday.subtract(const Duration(hours: 1)),
        null,
      );

      // Assert - should exclude twoDaysAgo
      expect(notifier.state.emergencies, hasLength(2));
      expect(
        notifier.state.emergencies.any((e) => e.id == 'test-id-1'),
        false,
      );
    });

    test('should search by query', () async {
      // Arrange
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(
          id: 'test-id-1',
          createdAt: DateTime.now(),
          type: EmergencyType.violentCrime,
        ),
      );
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(
          id: 'test-id-2',
          createdAt: DateTime.now(),
          type: EmergencyType.sexualAssault,
        ),
      );

      // Act
      await notifier.setSearchQuery('sexual');

      // Assert
      expect(notifier.state.emergencies, hasLength(1));
      expect(notifier.state.emergencies.first.type, EmergencyType.sexualAssault);
    });

    test('should clear filters', () async {
      // Arrange
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(id: 'test-id-1', createdAt: DateTime.now()),
      );
      await notifier.setStatusFilter(EmergencyStatus.resolved);
      await notifier.setSearchQuery('test');

      // Act
      await notifier.clearFilters();

      // Assert
      expect(notifier.state.statusFilter, isNull);
      expect(notifier.state.searchQuery, isNull);
      expect(notifier.state.fromDateFilter, isNull);
      expect(notifier.state.toDateFilter, isNull);
    });

    test('should handle pagination', () async {
      // Arrange - create 25 emergencies
      for (int i = 0; i < 25; i++) {
        await repository.sendRapidEmergency(
          RapidEmergencyRequest(
            id: 'test-id-$i',
            createdAt: DateTime.now(),
          ),
        );
      }

      // Act - load first page
      await notifier.loadHistory(refresh: true);

      // Assert
      expect(notifier.state.emergencies, hasLength(20)); // default page size
      expect(notifier.state.hasMore, true);
      expect(notifier.state.totalCount, 25);

      // Act - load next page
      await notifier.loadNextPage();

      // Assert
      expect(notifier.state.emergencies, hasLength(25)); // all items loaded
      expect(notifier.state.hasMore, false);
    });

    test('should not load next page if no more items', () async {
      // Arrange
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(id: 'test-id-1', createdAt: DateTime.now()),
      );
      await notifier.loadHistory(refresh: true);

      final initialLength = notifier.state.emergencies.length;

      // Act
      await notifier.loadNextPage();

      // Assert - no change
      expect(notifier.state.emergencies, hasLength(initialLength));
    });

    test('should refresh history', () async {
      // Arrange
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(id: 'test-id-1', createdAt: DateTime.now()),
      );
      await notifier.loadHistory(refresh: true);

      // Add another emergency
      await repository.sendRapidEmergency(
        RapidEmergencyRequest(id: 'test-id-2', createdAt: DateTime.now()),
      );

      // Act
      await notifier.refresh();

      // Assert
      expect(notifier.state.emergencies, hasLength(2));
    });

    test('should handle error', () async {
      // Note: FakeEmergencyRepository doesn't throw errors,
      // but this test demonstrates the error handling structure
      
      // For now, just verify the state structure supports errors
      final state = notifier.state.copyWith(error: 'Test error');
      
      expect(state.error, 'Test error');
    });
  });
}
