import 'emergency.dart';
import 'rapid_emergency_request.dart';

/// Abstract repository interface for emergency operations
/// This provides a clean abstraction that can be implemented
/// with real backend calls, local storage, or fake implementations
abstract class EmergencyRepository {
  /// Send a rapid emergency request
  /// This should be non-blocking and fast
  /// In production, this would trigger:
  /// - Backend API call
  /// - SMS to trusted contacts
  /// - Local notification
  /// - Evidence capture setup
  Future<void> sendRapidEmergency(RapidEmergencyRequest request);

  /// Get the last sent rapid emergency (for testing/debugging)
  RapidEmergencyRequest? getLastEmergency();

  /// Get emergency history with optional filters
  /// [status] - Filter by emergency status
  /// [fromDate] - Filter emergencies from this date (inclusive)
  /// [toDate] - Filter emergencies to this date (inclusive)
  /// [searchQuery] - Search by location or type
  /// [page] - Page number for pagination (0-based)
  /// [pageSize] - Number of items per page
  Future<EmergencyHistoryResult> getEmergencyHistory({
    EmergencyStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
    int page = 0,
    int pageSize = 20,
  });
}

/// Result of an emergency history query
class EmergencyHistoryResult {
  /// List of emergencies for current page
  final List<Emergency> emergencies;

  /// Current page number (0-based)
  final int page;

  /// Total number of pages
  final int totalPages;

  /// Total number of emergencies matching the filter
  final int totalCount;

  /// Whether there are more pages
  bool get hasMore => page < totalPages - 1;

  const EmergencyHistoryResult({
    required this.emergencies,
    required this.page,
    required this.totalPages,
    required this.totalCount,
  });

  /// Empty result
  static const empty = EmergencyHistoryResult(
    emergencies: [],
    page: 0,
    totalPages: 0,
    totalCount: 0,
  );
}
