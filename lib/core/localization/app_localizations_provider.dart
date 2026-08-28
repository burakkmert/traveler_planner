import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/profile/presentation/providers/settings_provider.dart';
import 'app_localizations.dart';

/// Riverpod provider delivering reactive [AppLocalizations] based on active user settings.
final locProvider = Provider<AppLocalizations>((ref) {
  final settings = ref.watch(settingsProvider);
  return AppLocalizations(settings.languageCode);
});
