import 'package:flutter/material.dart';

import '../../home/presentation/pages/pages.dart';
import '../domain/entities/app_user.dart';
import '../domain/usecases/auth_use_cases.dart';
import 'pages.dart';
import 'widgets/auth_loading_screen.dart';

/// Punto de entrada de autenticacion.
///
/// Decide entre login u home segun sesion persistida y stream de auth.
class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    required this.authUseCases,
  });

  final AuthUseCases authUseCases;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  /// Ejecuta una sola validacion inicial de sesion persistida.
  late final Future<bool> _sessionCheck =
      widget.authUseCases.hasPersistedSession();

  /// Renderiza loading, login u home segun resolucion de sesion y stream auth.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _sessionCheck,
      builder: (context, sessionSnapshot) {
        if (sessionSnapshot.connectionState != ConnectionState.done) {
          return const AuthLoadingScreen();
        }

        return StreamBuilder<AppUser?>(
          stream: widget.authUseCases.watchAuthState(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const AuthLoadingScreen();
            }

            final user = authSnapshot.data;
            if (user == null) {
              return const LoginScreen();
            }

            return const HomeScreen();
          },
        );
      },
    );
  }
}
