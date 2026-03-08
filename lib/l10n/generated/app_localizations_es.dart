// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Espacio Wiki';

  @override
  String get helloWorld => 'Hola Mundo';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get themeLabel => 'Tema';

  @override
  String get spanishOption => 'Español';

  @override
  String get englishOption => 'Inglés';

  @override
  String get offlineStatusLabel => 'Offline';

  @override
  String get themeSystemLabel => 'Sistema';

  @override
  String get themeLightLabel => 'Claro';

  @override
  String get themeDarkLabel => 'Oscuro';

  @override
  String get genericUser => 'usuario';

  @override
  String get loginTitle => 'Inicia sesión y despega';

  @override
  String get loginSubtitle =>
      'Accede a tu bitácora estelar con seguridad reforzada.';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordRules =>
      'La contraseña debe tener 8+ caracteres, 1 mayúscula, 1 número y 1 símbolo.';

  @override
  String get loginButton => 'Entrar al espacio';

  @override
  String get continueWith => 'o continúa con';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithFacebook => 'Continuar con Facebook';

  @override
  String get emailRequired => 'El email es obligatorio.';

  @override
  String get emailInvalid => 'Ingresa un email válido.';

  @override
  String get passwordRequired => 'La contraseña es obligatoria.';

  @override
  String get passwordLengthError => 'Debe tener mínimo 8 caracteres.';

  @override
  String get passwordUppercaseError =>
      'Debe incluir al menos una letra mayúscula.';

  @override
  String get passwordNumberError => 'Debe incluir al menos un número.';

  @override
  String get passwordSpecialError =>
      'Debe incluir al menos un carácter especial.';

  @override
  String get socialSignInUnavailable =>
      'No fue posible iniciar sesión con el proveedor seleccionado.';

  @override
  String get googleSignInConfigError =>
      'Google Sign-In no está bien configurado (SHA-1/SHA-256 u OAuth).';

  @override
  String get networkProviderError =>
      'No hay conexión de red para autenticar con el proveedor.';

  @override
  String get signInUnexpectedError =>
      'Ocurrió un error inesperado al iniciar sesión.';

  @override
  String get firebaseInvalidEmail => 'El correo electrónico no es válido.';

  @override
  String get firebaseInvalidCredentials =>
      'Credenciales inválidas. Verifica email y contraseña.';

  @override
  String get firebaseTooManyRequests =>
      'Demasiados intentos. Intenta nuevamente en unos minutos.';

  @override
  String get firebaseNetworkError =>
      'Sin conexión. Verifica tu internet e inténtalo de nuevo.';

  @override
  String get firebaseAccountExistsDifferentProvider =>
      'Esta cuenta ya existe con otro método de inicio de sesión.';

  @override
  String get firebaseFacebookLoginFailed =>
      'No se pudo iniciar sesión con Facebook.';

  @override
  String get firebaseOperationNotAllowed =>
      'El método de autenticación no está habilitado.';

  @override
  String get firebaseAuthFallbackError =>
      'No fue posible autenticarte en este momento.';

  @override
  String get signOutSuccess => 'Sesión cerrada correctamente.';

  @override
  String get signOutButton => 'Cerrar sesión';

  @override
  String get signOutConfirmTitle => 'Confirmar cierre de sesión';

  @override
  String get signOutConfirmMessage => '¿Seguro que quieres cerrar sesión?';

  @override
  String get cancelAction => 'Cancelar';

  @override
  String get loadingLabel => 'Cargando...';

  @override
  String get registerTitle => 'Crea tu cuenta';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get goToRegisterButton => 'Crear cuenta';

  @override
  String get registerSuccess => 'Cuenta creada correctamente.';

  @override
  String get registerError => 'No se pudo completar el registro.';

  @override
  String get registerNameRequired => 'El nombre es obligatorio.';

  @override
  String get optionalLabel => 'opcional';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get detailTitle => 'Detalle';

  @override
  String get detailLoadError =>
      'No fue posible cargar el detalle del artículo.';

  @override
  String get detailOfflineNoCache =>
      'No hay conexión y este artículo no está cacheado.';

  @override
  String get articleIdLabel => 'ID del artículo';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get navHome => 'Inicio';

  @override
  String get navProfile => 'Perfil';

  @override
  String get profileEmailLabel => 'Correo';

  @override
  String get profileUidLabel => 'ID de usuario';

  @override
  String get profileDisplayNameLabel => 'Nombre';

  @override
  String get profilePhoneLabel => 'Teléfono';

  @override
  String get profileLastConnectionLabel => 'Última conexión';

  @override
  String get profileProvidersLabel => 'Proveedores';

  @override
  String get profileEmailVerifiedLabel => 'Correo verificado';

  @override
  String get profileVersionLabel => 'Versión de la aplicación';

  @override
  String get profileNotAvailable => 'No disponible';

  @override
  String get profileYesValue => 'Sí';

  @override
  String get profileNoValue => 'No';

  @override
  String get goToDetailButton => 'Ir a detalle';

  @override
  String get goToProfileButton => 'Ir a perfil';

  @override
  String homeWelcome(String email) {
    return 'Bienvenido a tu estación, $email';
  }

  @override
  String get homeSubtitle =>
      'Tu autenticación está activa y la sesión se guarda de forma segura.';

  @override
  String get cardNavigationTitle => 'Navegación';

  @override
  String get cardNavigationBody =>
      'Acceso inmediato al panel principal después del login.';

  @override
  String get cardSecurityTitle => 'Seguridad';

  @override
  String get cardSecurityBody => 'Token y UID almacenados en secure storage.';

  @override
  String get cardSessionTitle => 'Sesión';

  @override
  String get cardSessionBody =>
      'Persistencia de usuario entre reinicios de la app.';

  @override
  String get cardStatusTitle => 'Estado';

  @override
  String get cardStatusBody =>
      'Flujo conectado a FirebaseAuth para autenticación real.';

  @override
  String get homeSpaceFeedTitle => 'Novedades del Espacio';

  @override
  String get homeSpaceFeedSubtitle =>
      'Descubre artículos y recursos visuales obtenidos con MediaWiki Action API.';

  @override
  String get homeSearchHint => 'Buscar en artículos del espacio';

  @override
  String get homeSearchAction => 'Buscar';

  @override
  String get homeLoading => 'Cargando recursos del espacio...';

  @override
  String get homeLoadError => 'No fue posible cargar los recursos del espacio.';

  @override
  String get homeOfflineNoCache =>
      'No hay conexión y no existen datos guardados en este dispositivo.';

  @override
  String get homeOfflineBanner =>
      'Estás sin conexión. Mostrando datos guardados.';

  @override
  String get homeReconnectBanner =>
      'Conexión restablecida. Puedes sincronizar los datos.';

  @override
  String get homeSyncAction => 'Sincronizar';

  @override
  String get backPressExitHint => 'Presiona atrás nuevamente para salir';

  @override
  String get homeEmptyResults =>
      'No se encontraron resultados visuales para la categoría Espacio.';

  @override
  String get homeRetry => 'Reintentar';

  @override
  String get homeImageUnavailable => 'Imagen no disponible';

  @override
  String get homeSummaryFallback =>
      'Sin resumen disponible para este artículo.';

  @override
  String homeSlideCounter(int current, int total) {
    return '$current de $total';
  }
}
