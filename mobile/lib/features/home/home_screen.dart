import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_button.dart';
import '../../l10n/app_localizations.dart';
import '../emergency/presentation/rapid_crime_sos_notifier.dart';
import '../emergency/presentation/rapid_crime_sos_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isPressed = false;
  double _progress = 0.0;

  void _onSOSPressed() {
    setState(() {
      _isPressed = true;
      _progress = 0.0;
    });

    // Simulate hold progress
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isPressed && mounted) {
        setState(() {
          _progress = 0.5;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_isPressed && mounted) {
        setState(() {
          _progress = 1.0;
        });
      }
    });
  }

  void _onSOSReleased() {
    if (_progress >= 1.0) {
      // Trigger emergency SOS
      _triggerEmergency();
    }
    setState(() {
      _isPressed = false;
      _progress = 0.0;
    });
  }

  void _triggerEmergency() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.sosButton),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _triggerRapidCrimeSos() async {
    // Trigger the rapid crime SOS
    await ref.read(rapidCrimeSosProvider.notifier).triggerRapidCrimeSos();

    // Show confirmation
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rapidSosSent,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(l10n.rapidSosDescription),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );

    // Show type selector sheet
    final sosState = ref.read(rapidCrimeSosProvider);
    if (sosState.showTypeSelector && mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const RapidCrimeSosSheet(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.tagline,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Emergency SOS Button
                SizedBox(
                  height: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.pressForEmergency,
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        GestureDetector(
                          onTapDown: (_) => _onSOSPressed(),
                          onTapUp: (_) => _onSOSReleased(),
                          onTapCancel: _onSOSReleased,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Progress ring
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: CircularProgressIndicator(
                                  value: _progress,
                                  strokeWidth: 8,
                                  backgroundColor: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                              // SOS Button
                              Container(
                                width: 170,
                                height: 170,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: _isPressed
                                      ? AppColors.primaryGradient
                                      : null,
                                  color: _isPressed ? null : AppColors.primary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.emergency,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      l10n.sos,
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          l10n.holdToActivate,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Rapid Crime SOS Button
                        AppButton(
                          text: l10n.crimeInProgress,
                          onPressed: _triggerRapidCrimeSos,
                          variant: ButtonVariant.secondary,
                          icon: Icons.warning_amber_rounded,
                          fullWidth: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Quick info cards
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.success,
                              size: 32,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.location,
                              style: theme.textTheme.labelLarge,
                            ),
                            Text(
                              l10n.active,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppCard(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.people,
                              color: AppColors.info,
                              size: 32,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.responders,
                              style: theme.textTheme.labelLarge,
                            ),
                            Text(
                              '12 nearby',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
