import 'package:flutter/foundation.dart';
import '../domain/emergency.dart';
import '../domain/emergency_repository.dart';
import '../domain/emergency_type.dart';
import '../domain/rapid_emergency_request.dart';

/// Fake/stub implementation of EmergencyRepository for MVP
/// This logs the emergency request and stores it in memory
/// TODO: Replace with real backend implementation
class FakeEmergencyRepository implements EmergencyRepository {
  RapidEmergencyRequest? _lastEmergency;
  final List<Emergency> _emergencyHistory = [];

  @override
  Future<void> sendRapidEmergency(RapidEmergencyRequest request) async {
    // Log the emergency for debugging
    debugPrint('🚨 RAPID EMERGENCY SENT 🚨');
    debugPrint('Request: $request');
    debugPrint('Type: ${request.type?.displayName ?? "Not specified"}');
    debugPrint('Location: ${request.location}');
    debugPrint('Priority: ${request.isHighPriority ? "HIGH" : "NORMAL"}');
    debugPrint('Timestamp: ${request.createdAt}');

    // Store in memory
    _lastEmergency = request;
    
    // Convert to Emergency and add to history
    final emergency = Emergency.fromRequest(request);
    _emergencyHistory.add(emergency);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: In production, this would:
    // - Call backend API
    // - Send SMS to trusted contacts
    // - Trigger local notifications
    // - Start evidence capture
    // - Contact emergency services if configured
  }

  @override
  RapidEmergencyRequest? getLastEmergency() {
    return _lastEmergency;
  }

  @override
  Future<EmergencyHistoryResult> getEmergencyHistory({
    EmergencyStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
    int page = 0,
    int pageSize = 20,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Filter emergencies
    var filtered = _emergencyHistory.where((emergency) {
      // Filter by status
      if (status != null && emergency.status != status) {
        return false;
      }

      // Filter by date range
      if (fromDate != null && emergency.createdAt.isBefore(fromDate)) {
        return false;
      }
      if (toDate != null && emergency.createdAt.isAfter(toDate)) {
        return false;
      }

      // Filter by search query (search in type name and location)
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final typeName = emergency.type?.displayName.toLowerCase() ?? '';
        final location = emergency.location?.toString().toLowerCase() ?? '';
        
        if (!typeName.contains(query) && !location.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort by date (newest first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Calculate pagination
    final totalCount = filtered.length;
    final totalPages = (totalCount / pageSize).ceil();
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalCount);

    // Get page data
    final pageData = startIndex < totalCount
        ? filtered.sublist(startIndex, endIndex)
        : <Emergency>[];

    return EmergencyHistoryResult(
      emergencies: pageData,
      page: page,
      totalPages: totalPages,
      totalCount: totalCount,
    );
  }

  /// Get all emergency history (useful for testing)
  List<Emergency> getAllEmergencies() {
    return List.unmodifiable(_emergencyHistory);
  }

  /// Update emergency status (useful for testing)
  void updateEmergencyStatus(String id, EmergencyStatus status) {
    final index = _emergencyHistory.indexWhere((e) => e.id == id);
    if (index != -1) {
      _emergencyHistory[index] = _emergencyHistory[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Clear history (useful for testing)
  void clearHistory() {
    _lastEmergency = null;
    _emergencyHistory.clear();
  }
}
