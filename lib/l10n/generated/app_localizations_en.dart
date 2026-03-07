// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wiki Space';

  @override
  String get helloWorld => 'Hello World';

  @override
  String get languageLabel => 'Language';

  @override
  String get spanishOption => 'Spanish';

  @override
  String get englishOption => 'English';

  @override
  String get themeLightLabel => 'Light theme';

  @override
  String get themeDarkLabel => 'Dark theme';

  @override
  String get genericUser => 'user';

  @override
  String get loginTitle => 'Sign in and launch';

  @override
  String get loginSubtitle => 'Access your star log with reinforced security.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRules =>
      'Password must contain 8+ characters, 1 uppercase letter, 1 number, and 1 symbol.';

  @override
  String get loginButton => 'Enter space';

  @override
  String get continueWith => 'or continue with';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get emailRequired => 'Email is required.';

  @override
  String get emailInvalid => 'Enter a valid email.';

  @override
  String get passwordRequired => 'Password is required.';

  @override
  String get passwordLengthError => 'Must contain at least 8 characters.';

  @override
  String get passwordUppercaseError =>
      'Must include at least one uppercase letter.';

  @override
  String get passwordNumberError => 'Must include at least one number.';

  @override
  String get passwordSpecialError =>
      'Must include at least one special character.';

  @override
  String get socialSignInUnavailable =>
      'Could not sign in with the selected provider.';

  @override
  String get googleSignInConfigError =>
      'Google Sign-In is not configured correctly (SHA-1/SHA-256 or OAuth).';

  @override
  String get networkProviderError =>
      'No network connection to authenticate with the provider.';

  @override
  String get signInUnexpectedError =>
      'An unexpected error occurred while signing in.';

  @override
  String get firebaseInvalidEmail => 'The email address is not valid.';

  @override
  String get firebaseInvalidCredentials =>
      'Invalid credentials. Check your email and password.';

  @override
  String get firebaseTooManyRequests =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get firebaseNetworkError =>
      'No connection. Check your internet and try again.';

  @override
  String get firebaseAccountExistsDifferentProvider =>
      'This account already exists with another sign-in method.';

  @override
  String get firebaseFacebookLoginFailed => 'Could not sign in with Facebook.';

  @override
  String get firebaseOperationNotAllowed =>
      'Authentication method is not enabled.';

  @override
  String get firebaseAuthFallbackError => 'Could not authenticate right now.';

  @override
  String get signOutSuccess => 'Signed out successfully.';

  @override
  String get signOutButton => 'Sign out';

  @override
  String homeWelcome(String email) {
    return 'Welcome to your station, $email';
  }

  @override
  String get homeSubtitle =>
      'Your authentication is active and your session is securely persisted.';

  @override
  String get cardNavigationTitle => 'Navigation';

  @override
  String get cardNavigationBody =>
      'Immediate access to the main panel after login.';

  @override
  String get cardSecurityTitle => 'Security';

  @override
  String get cardSecurityBody => 'Token and UID stored in secure storage.';

  @override
  String get cardSessionTitle => 'Session';

  @override
  String get cardSessionBody => 'User persistence between app restarts.';

  @override
  String get cardStatusTitle => 'Status';

  @override
  String get cardStatusBody =>
      'Flow connected to FirebaseAuth for real authentication.';
}
