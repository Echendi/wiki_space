import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home/presentation/home_screen.dart';
import '../data/auth_service.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.authService});

  final AuthService authService;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<bool> _sessionCheck =
      widget.authService.hasPersistedSession();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _sessionCheck,
      builder: (context, sessionSnapshot) {
        if (sessionSnapshot.connectionState != ConnectionState.done) {
          return const _AuthLoadingScreen();
        }

        return StreamBuilder<User?>(
          stream: widget.authService.authStateChanges,
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const _AuthLoadingScreen();
            }

            final user = authSnapshot.data;
            if (user == null) {
              return LoginScreen(authService: widget.authService);
            }

            return HomeScreen(authService: widget.authService);
          },
        );
      },
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF08142A),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF55D6BE)),
      ),
    );
  }
}
