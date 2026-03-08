import '../../../../l10n/generated/app_localizations.dart';
import '../models/password_rule.dart';

/// Politica comun de contrasena para login y registro.
class AuthPasswordPolicy {
  const AuthPasswordPolicy._();

  /// Valida formato y complejidad minima para autenticar al usuario.
  static String? validatePassword(AppLocalizations l10n, String? value) {
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

  /// Construye reglas para renderizar su estado en tiempo real.
  static List<PasswordRule> buildRules(AppLocalizations l10n, String password) {
    return [
      PasswordRule(
        label: l10n.passwordLengthError,
        passed: password.length >= 8,
      ),
      PasswordRule(
        label: l10n.passwordUppercaseError,
        passed: RegExp(r'[A-Z]').hasMatch(password),
      ),
      PasswordRule(
        label: l10n.passwordNumberError,
        passed: RegExp(r'[0-9]').hasMatch(password),
      ),
      PasswordRule(
        label: l10n.passwordSpecialError,
        passed: RegExp(r'[^A-Za-z0-9]').hasMatch(password),
      ),
    ];
  }
}
