import 'package:flutter/material.dart';

import '../../../../core/widgets/global_top_bar/global_top_bar.dart';

/// Pantalla minima de carga mientras se resuelve estado de autenticacion.
class AuthLoadingScreen extends StatelessWidget {
  const AuthLoadingScreen({super.key});

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
