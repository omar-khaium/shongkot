import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shongkot_app/features/emergency/domain/emergency_type.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/emergency.dart';
import 'emergency_history_notifier.dart';

class EmergencyHistoryScreen extends ConsumerStatefulWidget {
  const EmergencyHistoryScreen({super.key});

  @override
  ConsumerState<EmergencyHistoryScreen> createState() =>
      _EmergencyHistoryScreenState();
}

class _EmergencyHistoryScreenState
    extends ConsumerState<EmergencyHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load history on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(emergencyHistoryProvider.notifier).loadHistory(refresh: true);
    });

    // Listen to scroll for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(emergencyHistoryProvider.notifier).loadNextPage();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(emergencyHistoryProvider.notifier).refresh();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(emergencyHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emergencyHistory),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, _) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchEmergencies,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(emergencyHistoryProvider.notifier)
                                  .setSearchQuery(null);
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    ref
                        .read(emergencyHistoryProvider.notifier)
                        .setSearchQuery(value.isEmpty ? null : value);
                  },
                );
              },
            ),
          ),

          // Active filters indicator
          if (state.statusFilter != null ||
              state.fromDateFilter != null ||
              state.toDateFilter != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (state.statusFilter != null)
                          Chip(
                            label: Text(state.statusFilter!.displayName),
                            onDeleted: () {
                              ref
                                  .read(emergencyHistoryProvider.notifier)
                                  .setStatusFilter(null);
                            },
                          ),
                        if (state.fromDateFilter != null ||
                            state.toDateFilter != null)
                          Chip(
                            label: Text(_getDateRangeText(
                              state.fromDateFilter,
                              state.toDateFilter,
                            )),
                            onDeleted: () {
                              ref
                                  .read(emergencyHistoryProvider.notifier)
                                  .setDateRangeFilter(null, null);
                            },
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(emergencyHistoryProvider.notifier).clearFilters();
                      _searchController.clear();
                    },
                    child: Text(l10n.clearFilters),
                  ),
                ],
              ),
            ),

          // List
          Expanded(
            child: Builder(
              builder: (context) {
                if (state.isLoading && state.emergencies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: AppSpacing.md),
                        Text(l10n.loadingEmergencies),
                      ],
                    ),
                  );
                }

                if (state.error != null && state.emergencies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(state.error!),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: _onRefresh,
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (state.emergencies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.noEmergencies,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.noEmergenciesDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    itemCount: state.emergencies.length +
                        (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.emergencies.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final emergency = state.emergencies[index];
                      return _EmergencyListItem(emergency: emergency);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getDateRangeText(DateTime? from, DateTime? to) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMd();
    if (from != null && to != null) {
      return '${dateFormat.format(from)} - ${dateFormat.format(to)}';
    } else if (from != null) {
      return '${l10n.from} ${dateFormat.format(from)}';
    } else if (to != null) {
      return '${l10n.to} ${dateFormat.format(to)}';
    }
    return '';
  }
}

class _EmergencyListItem extends StatelessWidget {
  final Emergency emergency;

  const _EmergencyListItem({required this.emergency});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: () {
          // TODO: Navigate to emergency details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(emergency.status).withOpacity(30 / 255),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    emergency.status.displayName.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(emergency.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                // High priority badge
                if (emergency.isHighPriority)
                  const Icon(
                    Icons.priority_high,
                    color: AppColors.error,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Emergency type
            Text(
              emergency.type?.displayName ?? l10n.noTypeSpecified,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Date and time
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  DateFormat.yMMMd().add_jm().format(emergency.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),

            // Location if available
            if (emergency.location != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${emergency.location!.latitude.toStringAsFixed(4)}, ${emergency.location!.longitude.toStringAsFixed(4)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],

            // Notes if available
            if (emergency.notes != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                emergency.notes!,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(EmergencyStatus status) {
    switch (status) {
      case EmergencyStatus.pending:
        return AppColors.warning;
      case EmergencyStatus.active:
        return AppColors.error;
      case EmergencyStatus.resolved:
        return AppColors.success;
      case EmergencyStatus.cancelled:
        return AppColors.lightTextSecondary;
    }
  }
}

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(emergencyHistoryProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightTextSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Text(
                l10n.filterByStatus,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Status filter
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _StatusChip(
                    label: l10n.allStatuses,
                    isSelected: state.statusFilter == null,
                    onTap: () {
                      ref
                          .read(emergencyHistoryProvider.notifier)
                          .setStatusFilter(null);
                    },
                  ),
                  _StatusChip(
                    label: l10n.pending,
                    isSelected: state.statusFilter == EmergencyStatus.pending,
                    onTap: () {
                      ref
                          .read(emergencyHistoryProvider.notifier)
                          .setStatusFilter(EmergencyStatus.pending);
                    },
                  ),
                  _StatusChip(
                    label: l10n.active,
                    isSelected: state.statusFilter == EmergencyStatus.active,
                    onTap: () {
                      ref
                          .read(emergencyHistoryProvider.notifier)
                          .setStatusFilter(EmergencyStatus.active);
                    },
                  ),
                  _StatusChip(
                    label: l10n.resolved,
                    isSelected: state.statusFilter == EmergencyStatus.resolved,
                    onTap: () {
                      ref
                          .read(emergencyHistoryProvider.notifier)
                          .setStatusFilter(EmergencyStatus.resolved);
                    },
                  ),
                  _StatusChip(
                    label: l10n.cancelled,
                    isSelected:
                        state.statusFilter == EmergencyStatus.cancelled,
                    onTap: () {
                      ref
                          .read(emergencyHistoryProvider.notifier)
                          .setStatusFilter(EmergencyStatus.cancelled);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Done button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.confirm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.lightBorder,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
