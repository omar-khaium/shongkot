import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/auth_models.dart';
import '../domain/auth_validators.dart';
import 'register_notifier.dart';
import 'registration_success_screen.dart';

/// Registration screen for new users
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Clear any previous errors
    ref.read(registerProvider.notifier).clearError();

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate terms acceptance
    if (!_acceptedTerms) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.termsRequired)),
      );
      return;
    }

    // Create registration request
    final request = RegisterRequest(
      emailOrPhone: _emailOrPhoneController.text.trim(),
      password: _passwordController.text,
      acceptedTerms: _acceptedTerms,
    );

    // Attempt registration
    final success = await ref.read(registerProvider.notifier).register(request);

    if (!mounted) return;

    if (success) {
      // Navigate to success screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RegistrationSuccessScreen(),
        ),
      );
    } else {
      // Show error from state
      final error = ref.read(registerProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final registerState = ref.watch(registerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.register),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                
                // Title
                Text(
                  l10n.registerTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Subtitle
                Text(
                  l10n.registerSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Email or Phone field
                AppTextField(
                  label: l10n.emailOrPhone,
                  controller: _emailOrPhoneController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) => AuthValidators.validateEmailOrPhone(
                    value,
                    emailRequiredMsg: l10n.emailRequired,
                    emailInvalidMsg: l10n.emailInvalid,
                    phoneInvalidMsg: l10n.phoneInvalid,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Password field
                AppTextField(
                  label: l10n.password,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) => AuthValidators.validatePassword(
                    value,
                    passwordRequiredMsg: l10n.passwordRequired,
                    passwordTooShortMsg: l10n.passwordTooShort,
                    passwordNoUppercaseMsg: l10n.passwordNoUppercase,
                    passwordNoLowercaseMsg: l10n.passwordNoLowercase,
                    passwordNoNumberMsg: l10n.passwordNoNumber,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Confirm Password field
                AppTextField(
                  label: l10n.confirmPassword,
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) =>
                      AuthValidators.validatePasswordConfirmation(
                    value,
                    _passwordController.text,
                    passwordRequiredMsg: l10n.passwordRequired,
                    passwordsDoNotMatchMsg: l10n.passwordsDoNotMatch,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Terms and Privacy Policy acceptance
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptedTerms = !_acceptedTerms;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text.rich(
                            TextSpan(
                              text: '${l10n.iAgreeToThe} ',
                              style: theme.textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: l10n.termsOfService,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: ' ${l10n.and} '),
                                TextSpan(
                                  text: l10n.privacyPolicy,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Register button
                AppButton(
                  text: l10n.register,
                  onPressed: registerState.isLoading ? null : _handleRegister,
                  isLoading: registerState.isLoading,
                  fullWidth: true,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(l10n.login),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
