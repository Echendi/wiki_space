import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Espacio Wiki'**
  String get appTitle;

  /// No description provided for @helloWorld.
  ///
  /// In es, this message translates to:
  /// **'Hola Mundo'**
  String get helloWorld;

  /// No description provided for @languageLabel.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageLabel;

  /// No description provided for @themeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get themeLabel;

  /// No description provided for @spanishOption.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanishOption;

  /// No description provided for @englishOption.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get englishOption;

  /// No description provided for @offlineStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Offline'**
  String get offlineStatusLabel;

  /// No description provided for @themeSystemLabel.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get themeSystemLabel;

  /// No description provided for @themeLightLabel.
  ///
  /// In es, this message translates to:
  /// **'Tema claro'**
  String get themeLightLabel;

  /// No description provided for @themeDarkLabel.
  ///
  /// In es, this message translates to:
  /// **'Tema oscuro'**
  String get themeDarkLabel;

  /// No description provided for @genericUser.
  ///
  /// In es, this message translates to:
  /// **'usuario'**
  String get genericUser;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión y despega'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Accede a tu bitácora estelar con seguridad reforzada.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordLabel;

  /// No description provided for @passwordRules.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener 8+ caracteres, 1 mayúscula, 1 número y 1 símbolo.'**
  String get passwordRules;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Entrar al espacio'**
  String get loginButton;

  /// No description provided for @continueWith.
  ///
  /// In es, this message translates to:
  /// **'o continúa con'**
  String get continueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Facebook'**
  String get continueWithFacebook;

  /// No description provided for @emailRequired.
  ///
  /// In es, this message translates to:
  /// **'El email es obligatorio.'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un email válido.'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In es, this message translates to:
  /// **'La contraseña es obligatoria.'**
  String get passwordRequired;

  /// No description provided for @passwordLengthError.
  ///
  /// In es, this message translates to:
  /// **'Debe tener mínimo 8 caracteres.'**
  String get passwordLengthError;

  /// No description provided for @passwordUppercaseError.
  ///
  /// In es, this message translates to:
  /// **'Debe incluir al menos una letra mayúscula.'**
  String get passwordUppercaseError;

  /// No description provided for @passwordNumberError.
  ///
  /// In es, this message translates to:
  /// **'Debe incluir al menos un número.'**
  String get passwordNumberError;

  /// No description provided for @passwordSpecialError.
  ///
  /// In es, this message translates to:
  /// **'Debe incluir al menos un carácter especial.'**
  String get passwordSpecialError;

  /// No description provided for @socialSignInUnavailable.
  ///
  /// In es, this message translates to:
  /// **'No fue posible iniciar sesión con el proveedor seleccionado.'**
  String get socialSignInUnavailable;

  /// No description provided for @googleSignInConfigError.
  ///
  /// In es, this message translates to:
  /// **'Google Sign-In no está bien configurado (SHA-1/SHA-256 u OAuth).'**
  String get googleSignInConfigError;

  /// No description provided for @networkProviderError.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión de red para autenticar con el proveedor.'**
  String get networkProviderError;

  /// No description provided for @signInUnexpectedError.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado al iniciar sesión.'**
  String get signInUnexpectedError;

  /// No description provided for @firebaseInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'El correo electrónico no es válido.'**
  String get firebaseInvalidEmail;

  /// No description provided for @firebaseInvalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Credenciales inválidas. Verifica email y contraseña.'**
  String get firebaseInvalidCredentials;

  /// No description provided for @firebaseTooManyRequests.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Intenta nuevamente en unos minutos.'**
  String get firebaseTooManyRequests;

  /// No description provided for @firebaseNetworkError.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Verifica tu internet e inténtalo de nuevo.'**
  String get firebaseNetworkError;

  /// No description provided for @firebaseAccountExistsDifferentProvider.
  ///
  /// In es, this message translates to:
  /// **'Esta cuenta ya existe con otro método de inicio de sesión.'**
  String get firebaseAccountExistsDifferentProvider;

  /// No description provided for @firebaseFacebookLoginFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar sesión con Facebook.'**
  String get firebaseFacebookLoginFailed;

  /// No description provided for @firebaseOperationNotAllowed.
  ///
  /// In es, this message translates to:
  /// **'El método de autenticación no está habilitado.'**
  String get firebaseOperationNotAllowed;

  /// No description provided for @firebaseAuthFallbackError.
  ///
  /// In es, this message translates to:
  /// **'No fue posible autenticarte en este momento.'**
  String get firebaseAuthFallbackError;

  /// No description provided for @signOutSuccess.
  ///
  /// In es, this message translates to:
  /// **'Sesión cerrada correctamente.'**
  String get signOutSuccess;

  /// No description provided for @signOutButton.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOutButton;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'Confirmar cierre de sesión'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres cerrar sesión?'**
  String get signOutConfirmMessage;

  /// No description provided for @cancelAction.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelAction;

  /// No description provided for @loadingLabel.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loadingLabel;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get registerTitle;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registerButton;

  /// No description provided for @goToRegisterButton.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get goToRegisterButton;

  /// No description provided for @registerSuccess.
  ///
  /// In es, this message translates to:
  /// **'Cuenta creada correctamente.'**
  String get registerSuccess;

  /// No description provided for @registerError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar el registro.'**
  String get registerError;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden.'**
  String get passwordMismatch;

  /// No description provided for @detailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle'**
  String get detailTitle;

  /// No description provided for @detailLoadError.
  ///
  /// In es, this message translates to:
  /// **'No fue posible cargar el detalle del artículo.'**
  String get detailLoadError;

  /// No description provided for @detailOfflineNoCache.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión y este artículo no está cacheado.'**
  String get detailOfflineNoCache;

  /// No description provided for @articleIdLabel.
  ///
  /// In es, this message translates to:
  /// **'ID del artículo'**
  String get articleIdLabel;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @profileEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get profileEmailLabel;

  /// No description provided for @profileUidLabel.
  ///
  /// In es, this message translates to:
  /// **'ID de usuario'**
  String get profileUidLabel;

  /// No description provided for @profileDisplayNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get profileDisplayNameLabel;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get profilePhoneLabel;

  /// No description provided for @profileProvidersLabel.
  ///
  /// In es, this message translates to:
  /// **'Proveedores'**
  String get profileProvidersLabel;

  /// No description provided for @profileEmailVerifiedLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo verificado'**
  String get profileEmailVerifiedLabel;

  /// No description provided for @profileVersionLabel.
  ///
  /// In es, this message translates to:
  /// **'Versión de la aplicación'**
  String get profileVersionLabel;

  /// No description provided for @profileNotAvailable.
  ///
  /// In es, this message translates to:
  /// **'No disponible'**
  String get profileNotAvailable;

  /// No description provided for @profileYesValue.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get profileYesValue;

  /// No description provided for @profileNoValue.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get profileNoValue;

  /// No description provided for @goToDetailButton.
  ///
  /// In es, this message translates to:
  /// **'Ir a detalle'**
  String get goToDetailButton;

  /// No description provided for @goToProfileButton.
  ///
  /// In es, this message translates to:
  /// **'Ir a perfil'**
  String get goToProfileButton;

  /// No description provided for @homeWelcome.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a tu estación, {email}'**
  String homeWelcome(String email);

  /// No description provided for @homeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu autenticación está activa y la sesión se guarda de forma segura.'**
  String get homeSubtitle;

  /// No description provided for @cardNavigationTitle.
  ///
  /// In es, this message translates to:
  /// **'Navegación'**
  String get cardNavigationTitle;

  /// No description provided for @cardNavigationBody.
  ///
  /// In es, this message translates to:
  /// **'Acceso inmediato al panel principal después del login.'**
  String get cardNavigationBody;

  /// No description provided for @cardSecurityTitle.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get cardSecurityTitle;

  /// No description provided for @cardSecurityBody.
  ///
  /// In es, this message translates to:
  /// **'Token y UID almacenados en secure storage.'**
  String get cardSecurityBody;

  /// No description provided for @cardSessionTitle.
  ///
  /// In es, this message translates to:
  /// **'Sesión'**
  String get cardSessionTitle;

  /// No description provided for @cardSessionBody.
  ///
  /// In es, this message translates to:
  /// **'Persistencia de usuario entre reinicios de la app.'**
  String get cardSessionBody;

  /// No description provided for @cardStatusTitle.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get cardStatusTitle;

  /// No description provided for @cardStatusBody.
  ///
  /// In es, this message translates to:
  /// **'Flujo conectado a FirebaseAuth para autenticación real.'**
  String get cardStatusBody;

  /// No description provided for @homeSpaceFeedTitle.
  ///
  /// In es, this message translates to:
  /// **'Novedades del Espacio'**
  String get homeSpaceFeedTitle;

  /// No description provided for @homeSpaceFeedSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Descubre artículos y recursos visuales obtenidos con MediaWiki Action API.'**
  String get homeSpaceFeedSubtitle;

  /// No description provided for @homeSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar en artículos del espacio'**
  String get homeSearchHint;

  /// No description provided for @homeSearchAction.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get homeSearchAction;

  /// No description provided for @homeLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando recursos del espacio...'**
  String get homeLoading;

  /// No description provided for @homeLoadError.
  ///
  /// In es, this message translates to:
  /// **'No fue posible cargar los recursos del espacio.'**
  String get homeLoadError;

  /// No description provided for @homeOfflineNoCache.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión y no existen datos guardados en este dispositivo.'**
  String get homeOfflineNoCache;

  /// No description provided for @homeOfflineBanner.
  ///
  /// In es, this message translates to:
  /// **'Estás sin conexión. Mostrando datos guardados.'**
  String get homeOfflineBanner;

  /// No description provided for @homeReconnectBanner.
  ///
  /// In es, this message translates to:
  /// **'Conexión restablecida. Puedes sincronizar los datos.'**
  String get homeReconnectBanner;

  /// No description provided for @homeSyncAction.
  ///
  /// In es, this message translates to:
  /// **'Sincronizar'**
  String get homeSyncAction;

  /// No description provided for @backPressExitHint.
  ///
  /// In es, this message translates to:
  /// **'Presiona atrás nuevamente para salir'**
  String get backPressExitHint;

  /// No description provided for @homeEmptyResults.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados visuales para la categoría Espacio.'**
  String get homeEmptyResults;

  /// No description provided for @homeRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get homeRetry;

  /// No description provided for @homeImageUnavailable.
  ///
  /// In es, this message translates to:
  /// **'Imagen no disponible'**
  String get homeImageUnavailable;

  /// No description provided for @homeSummaryFallback.
  ///
  /// In es, this message translates to:
  /// **'Sin resumen disponible para este artículo.'**
  String get homeSummaryFallback;

  /// No description provided for @homeSlideCounter.
  ///
  /// In es, this message translates to:
  /// **'{current} de {total}'**
  String homeSlideCounter(int current, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
