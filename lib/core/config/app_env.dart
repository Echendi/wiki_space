import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Acceso tipado a variables de entorno cargadas desde `.env`.
class AppEnv {
  const AppEnv._();

  static String _required(String key) {
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env var: $key');
    }
    return value;
  }

  static String _optional(String key, String fallback) {
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return value;
  }

  static int _optionalInt(String key, int fallback) {
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return int.tryParse(value) ?? fallback;
  }

  static String wikipediaApiEndpoint(String languageCode) {
    final normalized = languageCode.toLowerCase() == 'es' ? 'es' : 'en';
    final template = _optional(
      'WIKIPEDIA_API_ENDPOINT_TEMPLATE',
      'https://{lang}.wikipedia.org/w/api.php',
    );
    return template.replaceAll('{lang}', normalized);
  }

  static String get networkProbeUrl =>
      _optional('NETWORK_PROBE_URL', 'https://www.google.com/generate_204');

  static Duration get networkProbeTimeout =>
      Duration(seconds: _optionalInt('NETWORK_PROBE_TIMEOUT_SECONDS', 4));

  static Duration get wikiRequestTimeout =>
      Duration(seconds: _optionalInt('WIKI_REQUEST_TIMEOUT_SECONDS', 12));

  static String get firebaseAndroidApiKey =>
      _required('FIREBASE_ANDROID_API_KEY');
  static String get firebaseAndroidAppId =>
      _required('FIREBASE_ANDROID_APP_ID');
  static String get firebaseMessagingSenderId =>
      _required('FIREBASE_MESSAGING_SENDER_ID');
  static String get firebaseProjectId => _required('FIREBASE_PROJECT_ID');
  static String get firebaseStorageBucket =>
      _required('FIREBASE_STORAGE_BUCKET');

  static String get firebaseIosApiKey => _required('FIREBASE_IOS_API_KEY');
  static String get firebaseIosAppId => _required('FIREBASE_IOS_APP_ID');
  static String get firebaseIosClientId => _required('FIREBASE_IOS_CLIENT_ID');
  static String get firebaseIosBundleId => _required('FIREBASE_IOS_BUNDLE_ID');
}
