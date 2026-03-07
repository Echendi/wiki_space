import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/data/auth_service.dart';
import '../../auth/presentation/widgets/space_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.authService});

  final AuthService authService;

  Future<void> _signOut(BuildContext context) async {
    await authService.signOut();
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Sesion cerrada correctamente.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final email = authService.currentUser?.email ?? 'usuario';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF09172D), Color(0xFF10375A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SpaceLogo(size: 80),
                    FilledButton.tonalIcon(
                      onPressed: () => _signOut(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF224569),
                        foregroundColor: const Color(0xFFEAF5FF),
                      ),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Cerrar sesion'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Bienvenido a tu estacion, $email',
                  style: GoogleFonts.orbitron(
                    color: const Color(0xFFEAF5FF),
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tu autenticacion esta activa y la sesion se guarda de forma segura.',
                  style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFFCDE2F6),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: GridView.count(
                    crossAxisCount:
                        MediaQuery.sizeOf(context).width > 780 ? 3 : 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    children: const [
                      _InfoCard(
                        title: 'Navegacion',
                        body:
                            'Acceso inmediato al panel principal despues del login.',
                        icon: Icons.rocket_launch_rounded,
                      ),
                      _InfoCard(
                        title: 'Seguridad',
                        body: 'Token y UID almacenados en secure storage.',
                        icon: Icons.shield_moon_rounded,
                      ),
                      _InfoCard(
                        title: 'Sesion',
                        body:
                            'Persistencia de usuario entre reinicios de la app.',
                        icon: Icons.lock_clock_rounded,
                      ),
                      _InfoCard(
                        title: 'Estado',
                        body:
                            'Flujo conectado a FirebaseAuth para autenticacion real.',
                        icon: Icons.hub_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0x1AF4FBFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x4D7BD4C7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF80E2CF), size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.orbitron(
                color: const Color(0xFFEAF5FF),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFFD4E8FA),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
