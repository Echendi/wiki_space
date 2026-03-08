import 'package:flutter/material.dart';

import '../../../core/widgets/global_top_bar.dart';
import '../../home/presentation/pages/pages.dart';
import '../domain/entities/app_user.dart';
import '../domain/usecases/auth_use_cases.dart';
import 'pages.dart';

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
  late final Future<bool> _sessionCheck =
      widget.authUseCases.hasPersistedSession();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _sessionCheck,
      builder: (context, sessionSnapshot) {
        if (sessionSnapshot.connectionState != ConnectionState.done) {
          return const _AuthLoadingScreen();
        }

        return StreamBuilder<AppUser?>(
          stream: widget.authUseCases.watchAuthState(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const _AuthLoadingScreen();
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

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalTopBar(),
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
