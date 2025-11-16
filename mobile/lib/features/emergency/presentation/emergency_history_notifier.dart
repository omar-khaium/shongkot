import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/emergency.dart';
import '../domain/emergency_repository.dart';
import '../data/emergency_repository_provider.dart';

/// State for emergency history
class EmergencyHistoryState {
  final List<Emergency> emergencies;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final EmergencyStatus? statusFilter;
  final DateTime? fromDateFilter;
  final DateTime? toDateFilter;
  final String? searchQuery;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool hasMore;

  const EmergencyHistoryState({
    this.emergencies = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.statusFilter,
    this.fromDateFilter,
    this.toDateFilter,
    this.searchQuery,
    this.currentPage = 0,
    this.totalPages = 0,
    this.totalCount = 0,
    this.hasMore = false,
  });

  EmergencyHistoryState copyWith({
    List<Emergency>? emergencies,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    EmergencyStatus? statusFilter,
    DateTime? fromDateFilter,
    DateTime? toDateFilter,
    String? searchQuery,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    bool? hasMore,
  }) {
    return EmergencyHistoryState(
      emergencies: emergencies ?? this.emergencies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      statusFilter: statusFilter ?? this.statusFilter,
      fromDateFilter: fromDateFilter ?? this.fromDateFilter,
      toDateFilter: toDateFilter ?? this.toDateFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// Create a copy with nullable fields explicitly set to null
  EmergencyHistoryState copyWithNullable({
    List<Emergency>? emergencies,
    bool? isLoading,
    bool? isLoadingMore,
    bool clearError = false,
    bool clearStatusFilter = false,
    bool clearFromDateFilter = false,
    bool clearToDateFilter = false,
    bool clearSearchQuery = false,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    bool? hasMore,
  }) {
    return EmergencyHistoryState(
      emergencies: emergencies ?? this.emergencies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error,
      statusFilter: clearStatusFilter ? null : statusFilter,
      fromDateFilter: clearFromDateFilter ? null : fromDateFilter,
      toDateFilter: clearToDateFilter ? null : toDateFilter,
      searchQuery: clearSearchQuery ? null : searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Notifier for managing emergency history state
class EmergencyHistoryNotifier extends StateNotifier<EmergencyHistoryState> {
  final EmergencyRepository _repository;

  EmergencyHistoryNotifier(this._repository)
      : super(const EmergencyHistoryState());

  /// Load emergency history with current filters
  Future<void> loadHistory({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: refresh,
      isLoadingMore: !refresh && state.currentPage > 0,
    );

    try {
      final result = await _repository.getEmergencyHistory(
        status: state.statusFilter,
        fromDate: state.fromDateFilter,
        toDate: state.toDateFilter,
        searchQuery: state.searchQuery,
        page: refresh ? 0 : state.currentPage,
      );

      state = state.copyWithNullable(
        emergencies: refresh
            ? result.emergencies
            : [...state.emergencies, ...result.emergencies],
        isLoading: false,
        isLoadingMore: false,
        clearError: true,
        currentPage: result.page,
        totalPages: result.totalPages,
        totalCount: result.totalCount,
        hasMore: result.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(currentPage: state.currentPage + 1);
    await loadHistory(refresh: false);
  }

  /// Set status filter
  Future<void> setStatusFilter(EmergencyStatus? status) async {
    state = state.copyWithNullable(
      statusFilter: status,
      clearStatusFilter: status == null,
      currentPage: 0,
    );
    await loadHistory(refresh: true);
  }

  /// Set date range filter
  Future<void> setDateRangeFilter(DateTime? from, DateTime? to) async {
    state = state.copyWithNullable(
      fromDateFilter: from,
      clearFromDateFilter: from == null,
      toDateFilter: to,
      clearToDateFilter: to == null,
      currentPage: 0,
    );
    await loadHistory(refresh: true);
  }

  /// Set search query
  Future<void> setSearchQuery(String? query) async {
    state = state.copyWithNullable(
      searchQuery: query,
      clearSearchQuery: query == null,
      currentPage: 0,
    );
    await loadHistory(refresh: true);
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    state = state.copyWithNullable(
      clearStatusFilter: true,
      clearFromDateFilter: true,
      clearToDateFilter: true,
      clearSearchQuery: true,
      currentPage: 0,
    );
    await loadHistory(refresh: true);
  }

  /// Refresh history
  Future<void> refresh() async {
    await loadHistory(refresh: true);
  }
}

/// Provider for emergency history notifier
final emergencyHistoryProvider =
    StateNotifierProvider<EmergencyHistoryNotifier, EmergencyHistoryState>(
  (ref) {
    final repository = ref.watch(emergencyRepositoryProvider);
    return EmergencyHistoryNotifier(repository);
  },
);
