import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/emergency_repository.dart';
import 'fake_emergency_repository.dart';

/// Provider for the emergency repository
/// This can be overridden in tests or when switching to real implementation
final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return FakeEmergencyRepository();
});
