import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wiki_space/features/auth/presentation/widgets/auth_form_header.dart';
import 'package:wiki_space/features/auth/presentation/widgets/space_logo.dart';

void main() {
  // Helper para montar el widget bajo un arbol Material completo.
  // Esto asegura que estilos/temas basados en Material funcionen en test.
  Widget _buildHeader({
    required String title,
    String? subtitle,
    bool compact = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AuthFormHeader(
          title: title,
          subtitle: subtitle,
          isDark: false,
          compact: compact,
        ),
      ),
    );
  }

  // Valida el render del encabezado reutilizable en login/registro.
  // Se cubren ambos caminos: con subtitulo visible y subtitulo omitido.
  group('AuthFormHeader', () {
    testWidgets(
        'muestra logo, titulo y subtitulo cuando el subtitulo no esta vacio', (
      tester,
    ) async {
      // Arrange + Act: render del encabezado con subtitulo valido.
      await tester.pumpWidget(
        _buildHeader(title: 'Iniciar sesion', subtitle: 'Bienvenido de vuelta'),
      );

      // Assert: deben verse logo, titulo y subtitulo exactamente una vez.
      expect(find.byType(SpaceLogo), findsOneWidget);
      expect(find.text('Iniciar sesion'), findsOneWidget);
      expect(find.text('Bienvenido de vuelta'), findsOneWidget);
    });

    testWidgets('oculta el subtitulo cuando llega nulo o en blanco',
        (tester) async {
      // Arrange + Act: render con subtitulo solo en espacios.
      await tester.pumpWidget(
        _buildHeader(title: 'Registro', subtitle: '   '),
      );

      // Assert: mantiene logo/titulo, pero no muestra texto de subtitulo vacio.
      expect(find.byType(SpaceLogo), findsOneWidget);
      expect(find.text('Registro'), findsOneWidget);
      expect(find.text('   '), findsNothing);
    });
  });
}
