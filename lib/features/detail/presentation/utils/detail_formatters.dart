import 'package:intl/intl.dart';

/// Utilidades de formato para la experiencia de detalle.
class DetailFormatters {
  const DetailFormatters._();

  /// Formatea fecha/hora de actualizacion al locale de la pantalla.
  static String formatLastUpdated(DateTime? value, String languageCode) {
    if (value == null) {
      return '--';
    }

    final locale = languageCode == 'es' ? 'es' : 'en';
    return DateFormat('dd/MM/yyyy HH:mm', locale).format(value);
  }
}
