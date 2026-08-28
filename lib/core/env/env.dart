import 'dart:io';

/// Secure environment configuration reader.
/// Reads key-value pairs natively from `.env` file or `--dart-define` compilation flags.
class Env {
  Env._();

  static final Map<String, String> _envMap = {};

  static Future<void> init() async {
    try {
      final file = File('.env');
      if (await file.exists()) {
        final lines = await file.readAsLines();
        for (var line in lines) {
          line = line.trim();
          if (line.isEmpty || line.startsWith('#')) continue;
          final parts = line.split('=');
          if (parts.length >= 2) {
            final key = parts[0].trim();
            final value = parts.sublist(1).join('=').trim();
            _envMap[key] = value;
          }
        }
      }
    } catch (_) {
      // Ignored in test environment
    }
  }

  static String get amadeusClientId =>
      _envMap['AMADEUS_CLIENT_ID'] ??
      const String.fromEnvironment('AMADEUS_CLIENT_ID', defaultValue: '');

  static String get amadeusClientSecret =>
      _envMap['AMADEUS_CLIENT_SECRET'] ??
      const String.fromEnvironment('AMADEUS_CLIENT_SECRET', defaultValue: '');

  static String get geminiApiKey =>
      _envMap['GEMINI_API_KEY'] ??
      const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
}
