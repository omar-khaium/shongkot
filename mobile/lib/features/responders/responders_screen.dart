import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../l10n/app_localizations.dart';

class RespondersScreen extends ConsumerWidget {
  const RespondersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Sample responders data
    final responders = [
      {
        'name': 'Dr. Ahmed Rahman',
        'type': 'Medical',
        'distance': '0.5 km',
        'rating': 4.8,
        'available': true,
      },
      {
        'name': 'Fire Station 12',
        'type': 'Fire Service',
        'distance': '1.2 km',
        'rating': 4.9,
        'available': true,
      },
      {
        'name': 'Police Station',
        'type': 'Police',
        'distance': '2.1 km',
        'rating': 4.5,
        'available': true,
      },
      {
        'name': 'Ambulance Service',
        'type': 'Medical',
        'distance': '0.8 km',
        'rating': 4.7,
        'available': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nearbyResponders),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: AppColors.success, size: 20),
                const SizedBox(width: AppSpacing.sm),
                // TODO: Replace with user's actual location. This is sample data.
                Text(
                  'Dhaka, Bangladesh',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.respondersNearbyCount(responders.length),
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Responders list
            Expanded(
              child: ListView.separated(
                itemCount: responders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final responder = responders[index];
                  final isAvailable = responder['available'] as bool;

                  return AppCard(
                    onTap: () {
                      // TODO: Show responder details
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: _getResponderTypeColor(
                                  responder['type'] as String,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd,
                                ),
                              ),
                              child: Icon(
                                _getResponderTypeIcon(
                                  responder['type'] as String,
                                ),
                                color: _getResponderTypeColor(
                                  responder['type'] as String,
                                ),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    responder['name'] as String,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    responder['type'] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: (isAvailable
                                        ? AppColors.success
                                        : AppColors.lightTextMuted)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusSm,
                                ),
                              ),
                              child: Text(
                                isAvailable ? l10n.available : l10n.busy,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isAvailable
                                      ? AppColors.success
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Icon(
                              Icons.navigation,
                              size: 16,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              responder['distance'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${responder['rating']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: isAvailable
                                  ? () {
                                      // TODO: Contact responder
                                    }
                                  : null,
                              icon: const Icon(Icons.phone, size: 16),
                              label: Text(l10n.contact),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getResponderTypeColor(String type) {
    switch (type) {
      case 'Medical':
        return AppColors.success;
      case 'Fire Service':
        return AppColors.warning;
      case 'Police':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  IconData _getResponderTypeIcon(String type) {
    switch (type) {
      case 'Medical':
        return Icons.medical_services;
      case 'Fire Service':
        return Icons.local_fire_department;
      case 'Police':
        return Icons.local_police;
      default:
        return Icons.emergency;
    }
  }
}
