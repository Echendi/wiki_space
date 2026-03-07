import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/global_top_bar.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/auth_service.dart';
import 'widgets/space_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.authService,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  final AuthService authService;
  final Locale locale;
  final ThemeMode themeMode;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isSocialLoading = false;
  bool _obscurePassword = true;

  bool get _isAnyLoading => _isLoading || _isSocialLoading;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }
      _showError(_firebaseMessageForCode(error.code));
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showError(AppLocalizations.of(context).signInUnexpectedError);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    await _runSocialSignIn(widget.authService.signInWithGoogle);
  }

  Future<void> _signInWithFacebook() async {
    await _runSocialSignIn(widget.authService.signInWithFacebook);
  }

  Future<void> _runSocialSignIn(Future<void> Function() action) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isSocialLoading = true;
    });

    try {
      await action();
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      _showError(_socialPlatformErrorMessage(error));
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }
      if (error.code != 'aborted-by-user') {
        _showError(_firebaseMessageForCode(error.code));
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showError(AppLocalizations.of(context).socialSignInUnavailable);
    } finally {
      if (mounted) {
        setState(() {
          _isSocialLoading = false;
        });
      }
    }
  }

  String _socialPlatformErrorMessage(PlatformException error) {
    final l10n = AppLocalizations.of(context);
    final details = (error.details ?? '').toString().toLowerCase();
    final code = error.code.toLowerCase();

    if (details.contains('apiexception: 10') ||
        details.contains('developer_error') ||
        code.contains('sign_in_failed')) {
      return l10n.googleSignInConfigError;
    }

    if (code.contains('network_error')) {
      return l10n.networkProviderError;
    }

    return l10n.socialSignInUnavailable;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppPalette.error,
          content: Text(message),
        ),
      );
  }

  String _firebaseMessageForCode(String code) {
    final l10n = AppLocalizations.of(context);
    switch (code) {
      case 'invalid-email':
        return l10n.firebaseInvalidEmail;
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return l10n.firebaseInvalidCredentials;
      case 'too-many-requests':
        return l10n.firebaseTooManyRequests;
      case 'network-request-failed':
        return l10n.firebaseNetworkError;
      case 'account-exists-with-different-credential':
        return l10n.firebaseAccountExistsDifferentProvider;
      case 'facebook-login-failed':
        return l10n.firebaseFacebookLoginFailed;
      case 'operation-not-allowed':
        return l10n.firebaseOperationNotAllowed;
      default:
        return l10n.firebaseAuthFallbackError;
    }
  }

  String? _validateEmail(String? value) {
    final l10n = AppLocalizations.of(context);
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return l10n.emailRequired;
    }

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(email)) {
      return l10n.emailInvalid;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context);
    final password = value ?? '';

    if (password.isEmpty) {
      return l10n.passwordRequired;
    }

    if (password.length < 8) {
      return l10n.passwordLengthError;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return l10n.passwordUppercaseError;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return l10n.passwordNumberError;
    }

    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      return l10n.passwordSpecialError;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: GlobalTopBar(
        locale: widget.locale,
        themeMode: widget.themeMode,
        onLocaleChanged: widget.onLocaleChanged,
        onThemeModeChanged: widget.onThemeModeChanged,
      ),
      body: Stack(
        children: [
          const _SpaceBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: (isDark
                              ? AppPalette.surfaceDark
                              : AppPalette.surfaceLight)
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppPalette.accent.withValues(alpha: 0.28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .shadow
                              .withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SpaceLogo(),
                            const SizedBox(height: 16),
                            Text(
                              l10n.loginTitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.screenTitle(isDark),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.subtitle(isDark)
                                  .copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 22),
                            _ThemedField(
                              controller: _emailController,
                              label: l10n.emailLabel,
                              icon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 14),
                            _ThemedField(
                              controller: _passwordController,
                              label: l10n.passwordLabel,
                              icon: Icons.lock_outline_rounded,
                              validator: _validatePassword,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: isDark
                                      ? AppPalette.onDarkMuted
                                      : AppPalette.onPrimary
                                          .withValues(alpha: 0.72),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.passwordRules,
                              style: AppTextStyles.caption(isDark),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _isAnyLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: AppPalette.primary,
                                  foregroundColor: AppPalette.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppPalette.onPrimary,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        l10n.loginButton,
                                        style: AppTextStyles.primaryCta(),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppPalette.accent
                                        .withValues(alpha: 0.35),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    l10n.continueWith,
                                    style: AppTextStyles.overline(isDark),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppPalette.accent
                                        .withValues(alpha: 0.35),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _SocialButton(
                              label: l10n.continueWithGoogle,
                              iconText: 'G',
                              iconBackground: AppPalette.googleBadgeBackground,
                              iconColor: AppPalette.googleBadgeForeground,
                              onPressed:
                                  _isAnyLoading ? null : _signInWithGoogle,
                            ),
                            const SizedBox(height: 10),
                            _SocialButton(
                              label: l10n.continueWithFacebook,
                              iconText: 'f',
                              iconBackground:
                                  AppPalette.facebookBadgeBackground,
                              iconColor: AppPalette.facebookBadgeForeground,
                              onPressed:
                                  _isAnyLoading ? null : _signInWithFacebook,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.iconText,
    required this.iconBackground,
    required this.iconColor,
    required this.onPressed,
  });

  final String label;
  final String iconText;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppPalette.accent.withValues(alpha: 0.35),
          ),
          backgroundColor:
              (isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLightAlt)
                  .withValues(alpha: isDark ? 0.72 : 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Text(
                iconText,
                style: AppTextStyles.socialBadgeGlyph(iconColor),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTextStyles.buttonLabel(isDark),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemedField extends StatelessWidget {
  const _ThemedField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: AppTextStyles.inputText(isDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.inputLabel(isDark),
        prefixIcon: Icon(icon, color: AppPalette.accent),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor:
            (isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLight)
                .withValues(alpha: isDark ? 0.82 : 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorStyle: AppTextStyles.errorStyle(),
      ),
    );
  }
}

class _SpaceBackground extends StatefulWidget {
  const _SpaceBackground();

  @override
  State<_SpaceBackground> createState() => _SpaceBackgroundState();
}

class _SpaceBackgroundState extends State<_SpaceBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  isDark
                      ? AppPalette.backgroundDark
                      : AppPalette.backgroundLight,
                  isDark
                      ? AppPalette.surfaceDarkAlt
                      : AppPalette.surfaceLightAlt,
                  _controller.value,
                )!,
                isDark ? AppPalette.surfaceDark : AppPalette.surfaceLight,
                Color.lerp(
                  isDark
                      ? AppPalette.surfaceDarkAlt
                      : AppPalette.surfaceLightAlt,
                  isDark ? AppPalette.secondary : AppPalette.accent,
                  _controller.value,
                )!,
              ],
            ),
          ),
          child: CustomPaint(
            painter: _StarfieldPainter(
              seed: 21,
              progress: _controller.value,
              isDark: isDark,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter({
    required this.seed,
    required this.progress,
    required this.isDark,
  });

  final int seed;
  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed);
    final starPaint = Paint()..color = AppPalette.star;

    for (var i = 0; i < 100; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final twinkle = 0.4 + (rng.nextDouble() * 0.6);
      final animated =
          (0.75 + math.sin((progress * math.pi * 2) + i) * 0.25) * twinkle;
      starPaint.color =
          AppPalette.star.withValues(alpha: animated.clamp(0.2, 1));
      canvas.drawCircle(Offset(x, y), rng.nextDouble() * 1.8 + 0.4, starPaint);
    }

    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDark ? AppPalette.primary : AppPalette.secondary)
              .withValues(alpha: isDark ? 0.25 : 0.17),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.82, size.height * 0.15),
          radius: size.width * 0.36,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.15),
      size.width * 0.36,
      nebulaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
