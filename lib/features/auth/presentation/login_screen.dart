import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/auth_service.dart';
import 'widgets/space_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isSocialLoading = false;
  bool _obscurePassword = true;

  bool get _isAnyLoading => _isLoading || _isSocialLoading;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (error) {
      _showError(_firebaseMessageForCode(error.code));
    } catch (_) {
      _showError('Ocurrio un error inesperado al iniciar sesion.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    await _runSocialSignIn(widget.authService.signInWithGoogle);
  }

  Future<void> _signInWithFacebook() async {
    await _runSocialSignIn(widget.authService.signInWithFacebook);
  }

  Future<void> _runSocialSignIn(Future<void> Function() action) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isSocialLoading = true;
    });

    try {
      await action();
    } on PlatformException catch (error) {
      _showError(_socialPlatformErrorMessage(error));
    } on FirebaseAuthException catch (error) {
      if (error.code != 'aborted-by-user') {
        _showError(_firebaseMessageForCode(error.code));
      }
    } catch (_) {
      _showError(
          'No fue posible iniciar sesion con el proveedor seleccionado.');
    } finally {
      if (mounted) {
        setState(() {
          _isSocialLoading = false;
        });
      }
    }
  }

  String _socialPlatformErrorMessage(PlatformException error) {
    final details = (error.details ?? '').toString().toLowerCase();
    final code = error.code.toLowerCase();

    if (details.contains('apiexception: 10') ||
        details.contains('developer_error') ||
        code.contains('sign_in_failed')) {
      return 'Google Sign-In no esta bien configurado (SHA-1/SHA-256 u OAuth).';
    }

    if (code.contains('network_error')) {
      return 'No hay conexion de red para autenticar con el proveedor.';
    }

    return 'No fue posible iniciar sesion con el proveedor seleccionado.';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFD4495B),
          content: Text(message),
        ),
      );
  }

  String _firebaseMessageForCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'El correo electronico no es valido.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Credenciales invalidas. Verifica email y contrasena.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta nuevamente en unos minutos.';
      case 'network-request-failed':
        return 'Sin conexion. Verifica tu internet e intentalo de nuevo.';
      case 'account-exists-with-different-credential':
        return 'Esta cuenta ya existe con otro metodo de inicio de sesion.';
      case 'facebook-login-failed':
        return 'No se pudo iniciar sesion con Facebook.';
      case 'operation-not-allowed':
        return 'El metodo de autenticacion no esta habilitado.';
      default:
        return 'No fue posible autenticarte en este momento.';
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'El email es obligatorio.';
    }

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(email)) {
      return 'Ingresa un email valido.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'La contrasena es obligatoria.';
    }

    if (password.length < 8) {
      return 'Debe tener minimo 8 caracteres.';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Debe incluir al menos una letra mayuscula.';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Debe incluir al menos un numero.';
    }

    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      return 'Debe incluir al menos un caracter especial.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _SpaceBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E1F36).withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFF79D7C5).withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SpaceLogo(),
                            const SizedBox(height: 16),
                            Text(
                              'Inicia sesion y despega',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.orbitron(
                                color: const Color(0xFFEAF5FF),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Accede a tu bitacora estelar con seguridad reforzada.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.spaceGrotesk(
                                color: const Color(0xFFD3E4F7),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 22),
                            _ThemedField(
                              controller: _emailController,
                              label: 'Correo electronico',
                              icon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 14),
                            _ThemedField(
                              controller: _passwordController,
                              label: 'Contrasena',
                              icon: Icons.lock_outline_rounded,
                              validator: _validatePassword,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: const Color(0xFFC6DFFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'La contrasena debe tener 8+ caracteres, 1 mayuscula, 1 numero y 1 simbolo.',
                              style: GoogleFonts.spaceGrotesk(
                                color: const Color(0xFFA4C2E4),
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _isAnyLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: const Color(0xFF55D6BE),
                                  foregroundColor: const Color(0xFF06223C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color(0xFF06223C),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Entrar al espacio',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: const Color(0xFF79D7C5)
                                        .withValues(alpha: 0.35),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'o continua con',
                                    style: GoogleFonts.spaceGrotesk(
                                      color: const Color(0xFFAECBE8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: const Color(0xFF79D7C5)
                                        .withValues(alpha: 0.35),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _SocialButton(
                              label: 'Continuar con Google',
                              iconText: 'G',
                              iconBackground: const Color(0xFFFFE2CC),
                              iconColor: const Color(0xFF8F3A00),
                              onPressed:
                                  _isAnyLoading ? null : _signInWithGoogle,
                            ),
                            const SizedBox(height: 10),
                            _SocialButton(
                              label: 'Continuar con Facebook',
                              iconText: 'f',
                              iconBackground: const Color(0xFFD2E3FF),
                              iconColor: const Color(0xFF0B48B8),
                              onPressed:
                                  _isAnyLoading ? null : _signInWithFacebook,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.iconText,
    required this.iconBackground,
    required this.iconColor,
    required this.onPressed,
  });

  final String label;
  final String iconText;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: const Color(0xFF79D7C5).withValues(alpha: 0.35),
          ),
          backgroundColor: const Color(0xFF102A47).withValues(alpha: 0.72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Text(
                iconText,
                style: GoogleFonts.orbitron(
                  color: iconColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFFEAF5FF),
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemedField extends StatelessWidget {
  const _ThemedField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: GoogleFonts.spaceGrotesk(
        color: const Color(0xFFEAF5FF),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.spaceGrotesk(color: const Color(0xFFC6DFFF)),
        prefixIcon: Icon(icon, color: const Color(0xFF79D7C5)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF102A47).withValues(alpha: 0.82),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorStyle: GoogleFonts.spaceGrotesk(),
      ),
    );
  }
}

class _SpaceBackground extends StatefulWidget {
  const _SpaceBackground();

  @override
  State<_SpaceBackground> createState() => _SpaceBackgroundState();
}

class _SpaceBackgroundState extends State<_SpaceBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(const Color(0xFF08142A), const Color(0xFF0A2A3F),
                    _controller.value)!,
                const Color(0xFF0E1B35),
                Color.lerp(const Color(0xFF112C48), const Color(0xFF1F365A),
                    _controller.value)!,
              ],
            ),
          ),
          child: CustomPaint(
            painter: _StarfieldPainter(seed: 21, progress: _controller.value),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter({required this.seed, required this.progress});

  final int seed;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed);
    final starPaint = Paint()..color = const Color(0xFFE8F4FF);

    for (var i = 0; i < 100; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final twinkle = 0.4 + (rng.nextDouble() * 0.6);
      final animated =
          (0.75 + math.sin((progress * math.pi * 2) + i) * 0.25) * twinkle;
      starPaint.color =
          const Color(0xFFE8F4FF).withValues(alpha: animated.clamp(0.2, 1));
      canvas.drawCircle(Offset(x, y), rng.nextDouble() * 1.8 + 0.4, starPaint);
    }

    final nebulaPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x4443D9C6), Colors.transparent],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.82, size.height * 0.15),
          radius: size.width * 0.36,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.15),
      size.width * 0.36,
      nebulaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
