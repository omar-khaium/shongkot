import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/login_credentials.dart';
import 'auth_notifier.dart';

/// Login screen with email/phone and password authentication
/// plus biometric login support
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _biometricAvailable = false;
  bool _hasSavedCredentials = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometric() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final available = await authNotifier.isBiometricAvailable();
    final credentialsAvailable = await authNotifier.hasSavedCredentials();
    
    if (mounted) {
      setState(() {
        _biometricAvailable = available;
        _hasSavedCredentials = credentialsAvailable;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final credentials = LoginCredentials(
      emailOrPhone: _emailOrPhoneController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    try {
      await ref.read(authNotifierProvider.notifier).login(credentials);
      // Navigation will be handled by the main app based on auth state
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _handleBiometricLogin() async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      await ref.read(authNotifierProvider.notifier).loginWithBiometric(
        localizedReason: l10n.biometricReason,
      );
      // Navigation will be handled by the main app based on auth state
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                
                // Logo/Icon
                Icon(
                  Icons.emergency,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Title
                Text(
                  l10n.loginTitle,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                
                // Subtitle
                Text(
                  l10n.loginSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                
                // Email/Phone Field
                AppTextField(
                  label: l10n.emailOrPhone,
                  controller: _emailOrPhoneController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.fieldRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Password Field
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.fieldRequired;
                    }
                    if (value.length < 6) {
                      return l10n.passwordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Remember Me and Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        Text(l10n.rememberMe),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.forgotPassword),
                          ),
                        );
                      },
                      child: Text(l10n.forgotPassword),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Login Button
                AppButton(
                  text: l10n.login,
                  onPressed: authState.isLoading ? null : _handleLogin,
                  isLoading: authState.isLoading,
                  fullWidth: true,
                ),
                
                // Biometric Login Button
                if (_biometricAvailable && _hasSavedCredentials) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    text: l10n.loginWithBiometric,
                    onPressed: authState.isLoading ? null : _handleBiometricLogin,
                    variant: ButtonVariant.secondary,
                    icon: Icons.fingerprint,
                    fullWidth: true,
                  ),
                ],
                
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
