import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/verification_request.dart';
import 'verification_notifier.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final String identifier;
  final VerificationType type;
  final VoidCallback? onVerificationSuccess;

  const VerificationScreen({
    super.key,
    required this.identifier,
    required this.type,
    this.onVerificationSuccess,
  });

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();
    // Send initial code
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = VerificationRequest(
        identifier: widget.identifier,
        type: widget.type,
      );
      ref.read(verificationProvider.notifier).sendCode(request);
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _code {
    return _controllers.map((c) => c.text).join();
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Auto-submit when all digits are entered
    if (_code.length == 6) {
      _verifyCode();
    }
  }

  Future<void> _verifyCode() async {
    final code = _code;
    if (code.length != 6) {
      _showError(AppLocalizations.of(context)!.pleaseEnterAllSixDigits);
      return;
    }

    final success = await ref.read(verificationProvider.notifier).verifyCode(code);
    
    if (success && mounted) {
      widget.onVerificationSuccess?.call();
    }
  }

  Future<void> _resendCode() async {
    final request = VerificationRequest(
      identifier: widget.identifier,
      type: widget.type,
    );
    await ref.read(verificationProvider.notifier).resendCode(request);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verificationProvider);
    final theme = Theme.of(context);

    // Show error if any
    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showError(state.error!);
        ref.read(verificationProvider.notifier).clearError();
      });
    }

    // Navigate on success
    if (state.isVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onVerificationSuccess?.call();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Account'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verification Code',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'We sent a verification code to\n${widget.identifier}',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // OTP Input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      enabled: !state.isLoading,
                      style: theme.textTheme.headlineMedium,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _onCodeChanged(index, value),
                      onTap: () {
                        _controllers[index].selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _controllers[index].text.length,
                        );
                      },
                      onEditingComplete: () {
                        if (index < 5 && _controllers[index].text.isNotEmpty) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Verify Button
              AppButton(
                onPressed: state.isLoading ? null : _verifyCode,
                text: state.isLoading ? 'Verifying...' : 'Verify',
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Resend Code Button
              TextButton(
                onPressed: state.canResend && !state.isLoading ? _resendCode : null,
                child: Text(
                  state.canResend
                      ? 'Resend Code'
                      : 'Resend in ${state.secondsUntilCanResend}s',
                ),
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Expiration Timer
              if (state.expiresAt != null)
                Text(
                  'Code expires at ${_formatTime(state.expiresAt!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
