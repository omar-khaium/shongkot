import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/navigation/app_navigation.dart';

/// Screen shown after successful registration
class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Success title
              Text(
                l10n.registrationSuccess,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Success message
              Text(
                l10n.registrationSuccessMessage,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Continue to app button
              AppButton(
                text: l10n.continueToApp,
                onPressed: () {
                  // Navigate to main app
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AppNavigation(),
                    ),
                    (route) => false,
                  );
                },
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
