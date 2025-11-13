import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../shared/widgets/app_card.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentTheme = ref.watch(themeProvider);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // Profile section
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 35,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.profilePlaceholderName,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.profilePlaceholderEmail,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Edit profile
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Appearance section
          Text(l10n.appearance, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.brightness_6,
                  title: l10n.theme,
                  trailing: DropdownButton<AppThemeMode>(
                    value: currentTheme,
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(
                        value: AppThemeMode.light,
                        child: Text(l10n.light),
                      ),
                      DropdownMenuItem(
                        value: AppThemeMode.dark,
                        child: Text(l10n.dark),
                      ),
                      DropdownMenuItem(
                        value: AppThemeMode.system,
                        child: Text(l10n.system),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(themeProvider.notifier).setTheme(value);
                      }
                    },
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _SettingsTile(
                  icon: Icons.language,
                  title: l10n.language,
                  trailing: DropdownButton<Locale>(
                    value: currentLocale,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: Locale('bn'),
                        child: Text('বাংলা'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(localeProvider.notifier).setLocale(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Emergency settings
          Text(l10n.emergencySettings, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.location_on,
                  title: l10n.location,
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle location
                    },
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _SettingsTile(
                  icon: Icons.people,
                  title: l10n.emergencyContacts,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to contacts
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // About section
          Text(l10n.about, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: l10n.version,
                  trailing: Text(
                    '1.0.0',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.privacyPolicy,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Show privacy policy
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: l10n.termsOfService,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Show terms
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(title, style: theme.textTheme.bodyLarge)),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
