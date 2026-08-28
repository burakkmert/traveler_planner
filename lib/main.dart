import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/navigation/presentation/screens/main_wrapper_screen.dart';
import 'features/saved/presentation/providers/saved_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Turkish locale date formatting for Intl package
  await initializeDateFormatting('tr_TR', null);

  // Initialize Local Storage Service (Hive)
  final localStorageService = LocalStorageService();
  await localStorageService.init();

  runApp(
    ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(localStorageService),
      ],
      child: const TravelApp(),
    ),
  );
}

class TravelApp extends ConsumerWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Seyahat Planlayıcı',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const MainWrapperScreen(),
    );
  }
}
