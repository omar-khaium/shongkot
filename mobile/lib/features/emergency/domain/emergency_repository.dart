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
}
