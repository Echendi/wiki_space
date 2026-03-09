import 'package:flutter/material.dart';

/// Etiqueta visual de cada segmento del selector de tema.
class ProfileThemeSegmentLabel extends StatelessWidget {
  /// Crea una etiqueta con icono y texto para `SegmentedButton`.
  const ProfileThemeSegmentLabel({
    super.key,
    required this.icon,
    required this.text,
    required this.selected,
  });

  /// Icono base del modo de tema.
  final IconData icon;

  /// Texto localizado del modo de tema.
  final String text;

  /// Indica si el segmento esta actualmente seleccionado.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(selected ? Icons.check_rounded : icon, size: 18),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}
