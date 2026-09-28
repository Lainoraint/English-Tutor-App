import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'features/settings/settings_store.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home_screen.dart';
import 'core/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsNotifier = ref.watch(settingsProvider.notifier);
    
    // Background health check
    final client = ApiClient(deviceId: settingsNotifier.state.deviceId);
    client.healthCheck();

    return MaterialApp(
      title: 'English Tutor',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: settingsNotifier.isOnboardingComplete 
          ? const HomeScreen() 
          : const OnboardingScreen(),
    );
  }
}
