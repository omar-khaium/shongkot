import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/emergency_type.dart';
import 'rapid_crime_sos_notifier.dart';

/// Bottom sheet for selecting emergency type
/// This is shown after the initial rapid SOS is sent
/// It's optional and can be dismissed
class RapidCrimeSosSheet extends ConsumerWidget {
  const RapidCrimeSosSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                l10n.rapidCrimeTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              Text(
                l10n.rapidCrimeSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Emergency type options
              _EmergencyTypeButton(
                type: EmergencyType.sexualAssault,
                label: l10n.sexualAssault,
                icon: Icons.warning_rounded,
              ),
              const SizedBox(height: AppSpacing.sm),
              _EmergencyTypeButton(
                type: EmergencyType.physicalAssault,
                label: l10n.physicalAssault,
                icon: Icons.personal_injury_rounded,
              ),
              const SizedBox(height: AppSpacing.sm),
              _EmergencyTypeButton(
                type: EmergencyType.kidnapping,
                label: l10n.kidnapping,
                icon: Icons.directions_run_rounded,
              ),
              const SizedBox(height: AppSpacing.sm),
              _EmergencyTypeButton(
                type: EmergencyType.otherViolentCrime,
                label: l10n.otherViolentCrime,
                icon: Icons.emergency_rounded,
              ),
              const SizedBox(height: AppSpacing.md),

              // Skip button
              TextButton(
                onPressed: () {
                  ref.read(rapidCrimeSosProvider.notifier).dismissTypeSelector();
                  Navigator.of(context).pop();
                },
                child: Text(l10n.skipThisStep),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

/// Button for selecting emergency type
class _EmergencyTypeButton extends ConsumerWidget {
  final EmergencyType type;
  final String label;
  final IconData icon;

  const _EmergencyTypeButton({
    required this.type,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: () async {
          // Update the emergency type
          await ref.read(rapidCrimeSosProvider.notifier).updateEmergencyType(type);
          
          // Close the sheet
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
