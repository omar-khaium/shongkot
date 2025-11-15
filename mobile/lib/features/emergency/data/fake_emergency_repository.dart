import 'package:flutter/foundation.dart';
import '../domain/emergency_repository.dart';
import '../domain/rapid_emergency_request.dart';

/// Fake/stub implementation of EmergencyRepository for MVP
/// This logs the emergency request and stores it in memory
/// TODO: Replace with real backend implementation
class FakeEmergencyRepository implements EmergencyRepository {
  RapidEmergencyRequest? _lastEmergency;
  final List<RapidEmergencyRequest> _emergencyHistory = [];

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
    _emergencyHistory.add(request);

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

  /// Get all emergency history (useful for testing)
  List<RapidEmergencyRequest> getEmergencyHistory() {
    return List.unmodifiable(_emergencyHistory);
  }

  /// Clear history (useful for testing)
  void clearHistory() {
    _lastEmergency = null;
    _emergencyHistory.clear();
  }
}
