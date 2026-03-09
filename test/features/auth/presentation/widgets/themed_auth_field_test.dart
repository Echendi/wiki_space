import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wiki_space/features/auth/presentation/widgets/themed_auth_field.dart';

void main() {
  group('ThemedAuthField', () {
    testWidgets(
      'muestra error de validacion cuando el formulario se valida con el campo vacio',
      (tester) async {
        final formKey = GlobalKey<FormState>();
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: ThemedAuthField(
                  controller: controller,
                  label: 'Correo',
                  icon: Icons.email_outlined,
                  isCompact: true,
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Campo obligatorio'), findsOneWidget);
      },
    );

    testWidgets(
      'respeta obscureText y renderiza el suffixIcon configurado',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ThemedAuthField(
                controller: controller,
                label: 'Contrasena',
                icon: Icons.lock_outline,
                isCompact: false,
                obscureText: true,
                suffixIcon: const Icon(Icons.visibility_off),
                validator: (_) => null,
              ),
            ),
          ),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));

        expect(editableText.obscureText, isTrue);
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      },
    );
  });
}
