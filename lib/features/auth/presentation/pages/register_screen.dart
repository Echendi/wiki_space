import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/global_top_bar/global_top_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../models/password_rule.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../utils/auth_password_policy.dart';
import '../widgets/widgets.dart';

/// Pantalla de registro de usuario con validaciones de seguridad basicas.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final AuthCubit _authCubit;

  /// Obtiene una instancia de [AuthCubit] desde DI al iniciar pantalla.
  @override
  void initState() {
    super.initState();
    _authCubit = serviceLocator<AuthCubit>();
  }

  /// Libera controladores y cierra recursos locales del flujo de auth.
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _authCubit.close();
    super.dispose();
  }

  /// Valida formulario y ejecuta registro por email.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _authCubit.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      displayName: _nameController.text.trim(),
    );
  }

  /// Muestra feedback de exito/error para la accion de registro.
  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state.action != AuthAction.signUpEmail) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    if (state.status == AuthViewStatus.success) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.registerSuccess)),
        );
      return;
    }

    if (state.status == AuthViewStatus.failure) {
      final code = state.errorCode ?? 'unknown';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: AppPalette.error,
            content: Text(_errorMessageForCode(code)),
          ),
        );
    }
  }

  /// Traduce codigos de error de registro a mensajes localizados.
  String _errorMessageForCode(String code) {
    final l10n = AppLocalizations.of(context);
    switch (code) {
      case 'invalid-email':
        return l10n.firebaseInvalidEmail;
      case 'network-request-failed':
        return l10n.firebaseNetworkError;
      case 'too-many-requests':
        return l10n.firebaseTooManyRequests;
      case 'unknown':
        return l10n.registerError;
      default:
        return l10n.registerError;
    }
  }

  /// Valida formato basico de correo para registro.
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

  /// Valida que el nombre no sea vacio.
  String? _validateName(String? value) {
    final l10n = AppLocalizations.of(context);
    if ((value ?? '').trim().isEmpty) {
      return l10n.registerNameRequired;
    }
    return null;
  }

  /// Valida politica de contrasena para alta de cuenta.
  String? _validatePassword(String? value) {
    return AuthPasswordPolicy.validatePassword(
      AppLocalizations.of(context),
      value,
    );
  }

  /// Construye reglas visuales para checklist de password.
  List<PasswordRule> _passwordRules(AppLocalizations l10n, String password) {
    return AuthPasswordPolicy.buildRules(l10n, password);
  }

  /// Verifica coincidencia entre password y confirmacion.
  String? _validateConfirmPassword(String? value) {
    final l10n = AppLocalizations.of(context);
    if ((value ?? '') != _passwordController.text) {
      return l10n.passwordMismatch;
    }
    return null;
  }

  /// Crea decoracion consistente de campos con soporte de tema.
  InputDecoration _fieldDecoration(
    BuildContext context,
    String label,
    bool isDark,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppPalette.onDarkMuted
                : AppPalette.onPrimary.withValues(alpha: 0.72),
          ),
      filled: true,
      fillColor: (isDark ? AppPalette.surfaceDarkAlt : AppPalette.surfaceLight)
          .withValues(alpha: isDark ? 0.82 : 1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  /// Construye la UI del formulario de registro.
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppPalette.onDark : AppPalette.onPrimary;

    return Scaffold(
      appBar: const GlobalTopBar(showBackButton: true),
      body: BlocProvider<AuthCubit>.value(
        value: _authCubit,
        child: BlocListener<AuthCubit, AuthState>(
          listener: _onAuthStateChanged,
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final isLoading = authState.isLoading;

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: (isDark
                                ? AppPalette.surfaceDark
                                : AppPalette.surfaceLight)
                            .withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppPalette.accent.withValues(alpha: 0.28),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthFormHeader(
                                title: l10n.registerTitle,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _nameController,
                                validator: _validateName,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(color: titleColor),
                                decoration: _fieldDecoration(
                                  context,
                                  l10n.profileDisplayNameLabel,
                                  isDark,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _emailController,
                                validator: _validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(color: titleColor),
                                decoration: _fieldDecoration(
                                  context,
                                  l10n.emailLabel,
                                  isDark,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordController,
                                validator: _validatePassword,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(color: titleColor),
                                decoration: _fieldDecoration(
                                  context,
                                  l10n.passwordLabel,
                                  isDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              PasswordChecks(
                                controller: _passwordController,
                                isDark: isDark,
                                rulesBuilder: (password) =>
                                    _passwordRules(l10n, password),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _confirmPasswordController,
                                validator: _validateConfirmPassword,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(),
                                style: TextStyle(color: titleColor),
                                decoration: _fieldDecoration(
                                  context,
                                  l10n.confirmPasswordLabel,
                                  isDark,
                                ),
                              ),
                              const SizedBox(height: 18),
                              ElevatedButton(
                                onPressed: isLoading ? null : _submit,
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(l10n.registerButton),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
