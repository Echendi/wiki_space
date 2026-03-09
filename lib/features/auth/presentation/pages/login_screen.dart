import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/global_top_bar/global_top_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../models/password_rule.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../utils/auth_password_policy.dart';
import '../widgets/widgets.dart';

/// Pantalla de inicio de sesion con email y proveedores sociales.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthCubit _authCubit;

  bool _obscurePassword = true;

  /// Obtiene una instancia de [AuthCubit] desde el contenedor DI.
  @override
  void initState() {
    super.initState();
    _authCubit = serviceLocator<AuthCubit>();
  }

  /// Libera controladores y cierra el cubit local de pantalla.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authCubit.close();
    super.dispose();
  }

  /// Valida formulario y ejecuta login por email.
  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    await _authCubit.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  /// Ejecuta login social con Google.
  Future<void> _signInWithGoogle() async {
    FocusScope.of(context).unfocus();
    await _authCubit.signInWithGoogle();
  }

  /// Ejecuta login social con Facebook.
  Future<void> _signInWithFacebook() async {
    FocusScope.of(context).unfocus();
    _showError(AppLocalizations.of(context).facebookNotImplemented);
  }

  /// Muestra un `SnackBar` de error reemplazando el actual si existe.
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

  /// Traduce `errorCode` tecnico de auth a mensaje localizado para UI.
  String _errorMessageForCode(String code) {
    final l10n = AppLocalizations.of(context);
    switch (code) {
      case 'google-config-error':
        return l10n.googleSignInConfigError;
      case 'social-sign-in-unavailable':
        return l10n.socialSignInUnavailable;
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
      case 'facebook-not-implemented':
        return l10n.facebookNotImplemented;
      case 'operation-not-allowed':
        return l10n.firebaseOperationNotAllowed;
      case 'unknown':
        return l10n.signInUnexpectedError;
      default:
        return l10n.firebaseAuthFallbackError;
    }
  }

  /// Reacciona a fallos de autenticacion y muestra feedback en pantalla.
  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state.status != AuthViewStatus.failure) {
      return;
    }

    final code = state.errorCode ?? 'unknown';
    if (code == 'aborted-by-user') {
      return;
    }

    _showError(_errorMessageForCode(code));
  }

  /// Valida formato basico de correo.
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

  /// Valida politica de contrasena usada en autenticacion.
  String? _validatePassword(String? value) {
    return AuthPasswordPolicy.validatePassword(
      AppLocalizations.of(context),
      value,
    );
  }

  /// Construye lista de reglas para renderizar checks dinamicos de password.
  List<PasswordRule> _passwordRules(AppLocalizations l10n, String password) {
    return AuthPasswordPolicy.buildRules(l10n, password);
  }

  /// Construye la UI de login y enlaza listeners/blocs del flujo auth.
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const GlobalTopBar(),
      body: BlocProvider<AuthCubit>.value(
        value: _authCubit,
        child: BlocListener<AuthCubit, AuthState>(
          listener: _onAuthStateChanged,
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final isAnyLoading = authState.isLoading;
              final isEmailLoading =
                  isAnyLoading && authState.action == AuthAction.signInEmail;

              return Stack(
                children: [
                  const AuthSpaceBackground(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxHeight < 760;
                      final horizontalPadding = isCompact ? 16.0 : 24.0;
                      final verticalPadding = isCompact ? 12.0 : 20.0;

                      return SafeArea(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalPadding,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 440),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: (isDark
                                          ? AppPalette.surfaceDark
                                          : AppPalette.surfaceLight)
                                      .withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppPalette.accent
                                        .withValues(alpha: 0.28),
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
                                  padding: EdgeInsets.fromLTRB(
                                    isCompact ? 16 : 24,
                                    isCompact ? 18 : 30,
                                    isCompact ? 16 : 24,
                                    isCompact ? 16 : 24,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        AuthFormHeader(
                                          title: l10n.loginTitle,
                                          subtitle: l10n.loginSubtitle,
                                          isDark: isDark,
                                          compact: isCompact,
                                        ),
                                        SizedBox(height: isCompact ? 14 : 22),
                                        ThemedAuthField(
                                          controller: _emailController,
                                          label: l10n.emailLabel,
                                          icon: Icons.alternate_email_rounded,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: _validateEmail,
                                          textInputAction: TextInputAction.next,
                                          isCompact: isCompact,
                                        ),
                                        SizedBox(height: isCompact ? 10 : 14),
                                        ThemedAuthField(
                                          controller: _passwordController,
                                          label: l10n.passwordLabel,
                                          icon: Icons.lock_outline_rounded,
                                          validator: _validatePassword,
                                          obscureText: _obscurePassword,
                                          textInputAction: TextInputAction.done,
                                          onFieldSubmitted: (_) => _submit(),
                                          isCompact: isCompact,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_rounded
                                                  : Icons
                                                      .visibility_off_rounded,
                                              color: isDark
                                                  ? AppPalette.onDarkMuted
                                                  : AppPalette.onPrimary
                                                      .withValues(alpha: 0.72),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: isCompact ? 6 : 10),
                                        PasswordChecks(
                                          controller: _passwordController,
                                          isDark: isDark,
                                          rulesBuilder: (password) =>
                                              _passwordRules(l10n, password),
                                        ),
                                        SizedBox(height: isCompact ? 14 : 20),
                                        SizedBox(
                                          height: isCompact ? 48 : 54,
                                          child: ElevatedButton(
                                            onPressed:
                                                isAnyLoading ? null : _submit,
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  AppPalette.primary,
                                              foregroundColor:
                                                  AppPalette.onPrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: isEmailLoading
                                                ? const SizedBox(
                                                    width: 22,
                                                    height: 22,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        AppPalette.onPrimary,
                                                      ),
                                                    ),
                                                  )
                                                : Text(
                                                    l10n.loginButton,
                                                    style: AppTextStyles
                                                        .primaryCta(),
                                                  ),
                                          ),
                                        ),
                                        SizedBox(height: isCompact ? 10 : 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                color: AppPalette.accent
                                                    .withValues(alpha: 0.35),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Text(
                                                l10n.continueWith,
                                                style: AppTextStyles.overline(
                                                    isDark),
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
                                        SizedBox(height: isCompact ? 10 : 14),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SocialIconButton(
                                                semanticLabel:
                                                    l10n.continueWithGoogle,
                                                iconAssetPath:
                                                    'assets/images/google.png',
                                                onPressed: isAnyLoading
                                                    ? null
                                                    : _signInWithGoogle,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: SocialIconButton(
                                                semanticLabel:
                                                    l10n.continueWithFacebook,
                                                iconAssetPath:
                                                    'assets/images/facebook.png',
                                                onPressed: isAnyLoading
                                                    ? null
                                                    : _signInWithFacebook,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: isCompact ? 10 : 14),
                                        TextButton(
                                          onPressed: isAnyLoading
                                              ? null
                                              : () => context
                                                  .push(AppRoutes.register),
                                          child: Text(l10n.goToRegisterButton),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
