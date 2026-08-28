import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../planner/domain/models/optimization_strategy.dart';
import '../providers/settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentThemeMode = ref.watch(themeProvider);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final loc = ref.watch(locProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil ve Ayarlar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // User Profile Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade400, Colors.blue.shade600],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Ahmet Yılmaz',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.verified_rounded, size: 18, color: Colors.blue),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ahmet.yilmaz@example.com',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '⭐ Premium Gezgin',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 1. Theme Section
          _buildSectionTitle(theme, 'Görünüm & Tema'),
          const SizedBox(height: 10),
          Center(
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text('Koyu'),
                  icon: Icon(Icons.dark_mode_rounded),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text('Açık'),
                  icon: Icon(Icons.light_mode_rounded),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text('Sistem'),
                  icon: Icon(Icons.settings_system_daydream_rounded),
                ),
              ],
              selected: {currentThemeMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                settingsNotifier.setThemeMode(newSelection.first);
              },
            ),
          ),
          if (currentThemeMode == ThemeMode.system) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      loc.systemThemeExplanation,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // 2. Language & Currency Section
          _buildSectionTitle(theme, 'Dil & Para Birimi'),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: Colors.indigo),
                  title: const Text('Uygulama Dili'),
                  subtitle: Text(
                    settings.languageCode == 'tr' ? 'Türkçe (TR)' : 'English (US)',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showLanguagePicker(context, settingsNotifier, settings.languageCode),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.attach_money_rounded, color: Colors.green),
                  title: const Text('Para Birimi'),
                  subtitle: Text(_getCurrencyLabel(settings.currencyCode)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showCurrencyPicker(context, settingsNotifier, settings.currencyCode),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. Notification Preferences Section
          _buildSectionTitle(theme, 'Bildirim Tercihleri'),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.trending_down_rounded, color: Colors.orange),
                  title: const Text('Fiyat Düşüşü Bildirimleri'),
                  subtitle: const Text('Takip ettiğiniz rotalarda ucuzlama olduğunda bildirim alın.'),
                  value: settings.priceAlertsEnabled,
                  onChanged: (val) => settingsNotifier.togglePriceAlerts(val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.alarm_rounded, color: Colors.blue),
                  title: const Text('Uçuş Hatırlatıcıları'),
                  subtitle: const Text('Yaklaşan uçuşlarınız için zamanında uyarılın.'),
                  value: settings.flightRemindersEnabled,
                  onChanged: (val) => settingsNotifier.toggleFlightReminders(val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.card_giftcard_rounded, color: Colors.purple),
                  title: const Text('Promosyonlar & Fırsatlar'),
                  subtitle: const Text('Özel indirimler ve sezonsal fırsatlardan haberdar olun.'),
                  value: settings.promotionsEnabled,
                  onChanged: (val) => settingsNotifier.togglePromotions(val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 4. Default Travel Preferences Section
          _buildSectionTitle(theme, 'Varsayılan Seyahat Tercihleri'),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.group_rounded, color: Colors.teal),
                  title: const Text('Varsayılan Yolcu Sayısı'),
                  subtitle: Text('${settings.defaultPassengerCount} Yolcu'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 22),
                        onPressed: settings.defaultPassengerCount > 1
                            ? () => settingsNotifier.setDefaultPassengerCount(settings.defaultPassengerCount - 1)
                            : null,
                      ),
                      Text(
                        '${settings.defaultPassengerCount}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 22),
                        onPressed: settings.defaultPassengerCount < 9
                            ? () => settingsNotifier.setDefaultPassengerCount(settings.defaultPassengerCount + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.auto_awesome_rounded, color: Colors.indigo),
                  title: const Text('Varsayılan Optimizer Tercihi'),
                  subtitle: Text(settings.defaultStrategy.label),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showStrategyPicker(context, settingsNotifier, settings.defaultStrategy),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 5. About & Version Section
          _buildSectionTitle(theme, 'Uygulama Hakkında'),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: Colors.blueGrey),
                  title: Text('Sürüm'),
                  trailing: Text('v1.2.0 (Akıllı Optimizer + Local Storage)'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.security_rounded, color: Colors.blueGrey),
                  title: Text('Gizlilik Politikası & KVKK'),
                  trailing: Icon(Icons.open_in_new_rounded, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _getCurrencyLabel(String code) {
    switch (code) {
      case 'USD':
        return 'USD (\$ - Amerikan Doları)';
      case 'EUR':
        return 'EUR (€ - Euro)';
      case 'TRY':
      default:
        return 'TRY (₺ - Türk Lirası)';
    }
  }

  void _showLanguagePicker(
    BuildContext context,
    SettingsNotifier notifier,
    String currentCode,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dil Seçimi',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              RadioListTile<String>(
                title: const Text('🇹🇷 Türkçe'),
                value: 'tr',
                groupValue: currentCode,
                onChanged: (val) {
                  if (val != null) notifier.setLanguage(val);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('🇬🇧 English'),
                value: 'en',
                groupValue: currentCode,
                onChanged: (val) {
                  if (val != null) notifier.setLanguage(val);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    SettingsNotifier notifier,
    String currentCode,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Para Birimi Seçin',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              RadioListTile<String>(
                title: const Text('₺ - TRY (Türk Lirası)'),
                value: 'TRY',
                groupValue: currentCode,
                onChanged: (val) {
                  if (val != null) notifier.setCurrency(val);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('\$ - USD (Amerikan Doları)'),
                value: 'USD',
                groupValue: currentCode,
                onChanged: (val) {
                  if (val != null) notifier.setCurrency(val);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('€ - EUR (Euro)'),
                value: 'EUR',
                groupValue: currentCode,
                onChanged: (val) {
                  if (val != null) notifier.setCurrency(val);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStrategyPicker(
    BuildContext context,
    SettingsNotifier notifier,
    OptimizationStrategy currentStrategy,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Varsayılan Optimizer Tercihi',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ...OptimizationStrategy.values.map((strategy) {
                return RadioListTile<OptimizationStrategy>(
                  title: Text(strategy.label),
                  subtitle: Text(strategy.description, style: const TextStyle(fontSize: 11)),
                  value: strategy,
                  groupValue: currentStrategy,
                  onChanged: (val) {
                    if (val != null) notifier.setDefaultStrategy(val);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
