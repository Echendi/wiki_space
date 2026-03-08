/// Regla visual de validacion de contrasena para checklists de UI.
class PasswordRule {
  const PasswordRule({
    required this.label,
    required this.passed,
  });

  final String label;
  final bool passed;
}
