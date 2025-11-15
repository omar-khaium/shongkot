import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/emergency_repository_provider.dart';
import '../data/location_service_provider.dart';
import '../domain/emergency_type.dart';
import '../domain/rapid_emergency_request.dart';

/// State for Rapid Crime SOS
class RapidCrimeSosState {
  final RapidEmergencyRequest? lastRequest;
  final bool isLoading;
  final String? errorMessage;
  final bool showTypeSelector;

  const RapidCrimeSosState({
    this.lastRequest,
    this.isLoading = false,
    this.errorMessage,
    this.showTypeSelector = false,
  });

  RapidCrimeSosState copyWith({
    RapidEmergencyRequest? lastRequest,
    bool? isLoading,
    String? errorMessage,
    bool? showTypeSelector,
  }) {
    return RapidCrimeSosState(
      lastRequest: lastRequest ?? this.lastRequest,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      showTypeSelector: showTypeSelector ?? this.showTypeSelector,
    );
  }
}

/// Notifier for Rapid Crime SOS state management
class RapidCrimeSosNotifier extends StateNotifier<RapidCrimeSosState> {
  final Ref _ref;
  final _uuid = const Uuid();

  RapidCrimeSosNotifier(this._ref) : super(const RapidCrimeSosState());

  /// Trigger a rapid crime SOS
  /// This is the main entry point - fast, non-blocking
  Future<void> triggerRapidCrimeSos() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Get location (non-blocking, can be null)
      final locationService = _ref.read(locationServiceProvider);
      final location = await locationService.getCurrentLocation();

      // Create emergency request
      final request = RapidEmergencyRequest(
        id: _uuid.v4(),
        createdAt: DateTime.now(),
        location: location,
        isHighPriority: true,
        // Type is null initially, can be refined later
      );

      // Send to repository (this logs and stores for now)
      final repository = _ref.read(emergencyRepositoryProvider);
      await repository.sendRapidEmergency(request);

      // Update state
      state = state.copyWith(
        lastRequest: request,
        isLoading: false,
        showTypeSelector: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send emergency: $e',
      );
    }
  }

  /// Update the emergency type after initial send
  /// This is optional and non-blocking
  Future<void> updateEmergencyType(EmergencyType type) async {
    final lastRequest = state.lastRequest;
    if (lastRequest == null) return;

    try {
      // Update the request with the selected type
      final updatedRequest = lastRequest.copyWith(type: type);

      // Send updated request
      final repository = _ref.read(emergencyRepositoryProvider);
      await repository.sendRapidEmergency(updatedRequest);

      // Update state
      state = state.copyWith(
        lastRequest: updatedRequest,
        showTypeSelector: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update emergency type: $e',
      );
    }
  }

  /// Dismiss the type selector without updating
  void dismissTypeSelector() {
    state = state.copyWith(showTypeSelector: false);
  }

  /// Reset state (useful for testing)
  void reset() {
    state = const RapidCrimeSosState();
  }
}

/// Provider for Rapid Crime SOS state
final rapidCrimeSosProvider =
    StateNotifierProvider<RapidCrimeSosNotifier, RapidCrimeSosState>((ref) {
  return RapidCrimeSosNotifier(ref);
});
