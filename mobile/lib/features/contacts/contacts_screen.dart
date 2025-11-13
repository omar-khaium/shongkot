import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_button.dart';
import '../../l10n/app_localizations.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Sample contacts data
    final contacts = [
      {'name': 'Emergency Services', 'phone': '999', 'isPrimary': true},
      {
        'name': 'Family Doctor',
        'phone': '+880 1700-000000',
        'isPrimary': false,
      },
      {'name': 'Close Friend', 'phone': '+880 1800-000000', 'isPrimary': false},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.emergencyContacts)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.emergencyContacts, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'These contacts will be notified during an emergency',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Add contact button
            AppButton(
              text: l10n.addContact,
              icon: Icons.add,
              variant: ButtonVariant.secondary,
              fullWidth: true,
              onPressed: () {
                // TODO: Navigate to add contact screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l10n.addContact} - Coming soon')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Contacts list
            Expanded(
              child: ListView.separated(
                itemCount: contacts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  final isPrimary = contact['isPrimary'] as bool;

                  return AppCard(
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isPrimary
                                ? AppColors.primary.withOpacity(0.1)
                                : (isDark
                                      ? AppColors.darkSurfaceVariant
                                      : AppColors.lightSurfaceVariant),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: isPrimary ? AppColors.primary : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      contact['name'] as String,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                  if (isPrimary)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.sm,
                                        vertical: AppSpacing.xs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusSm,
                                        ),
                                      ),
                                      child: Text(
                                        l10n.primaryLabel,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: AppColors.primary,
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                contact['phone'] as String,
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
                          icon: const Icon(Icons.phone),
                          color: AppColors.success,
                          onPressed: () {
                            // TODO: Make phone call
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            // TODO: Show options menu
                          },
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
}
