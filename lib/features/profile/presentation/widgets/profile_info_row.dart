import 'package:flutter/material.dart';

/// Fila de informacion etiqueta/valor usada en tarjetas de perfil.
class ProfileInfoRow extends StatelessWidget {
  /// Crea una fila de informacion con fallback para valores vacios.
  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.fallback,
    required this.labelColor,
    required this.valueColor,
  });

  /// Etiqueta descriptiva del dato mostrado.
  final String label;

  /// Valor principal; puede ser nulo o vacio.
  final String? value;

  /// Texto mostrado cuando [value] no tiene contenido util.
  final String fallback;

  /// Color del texto de la etiqueta.
  final Color labelColor;

  /// Color del texto del valor.
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final displayValue =
        (value == null || value!.trim().isEmpty) ? fallback : value!.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextSpan(
              text: displayValue,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
