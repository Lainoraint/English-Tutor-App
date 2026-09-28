import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class SettingsState {
  final String goal;
  final String level;
  final String explanationLanguage;
  final String deviceId;

  SettingsState({
    required this.goal,
    required this.level,
    required this.explanationLanguage,
    required this.deviceId,
  });

  SettingsState copyWith({
    String? goal,
    String? level,
    String? explanationLanguage,
  }) {
    return SettingsState(
      goal: goal ?? this.goal,
      level: level ?? this.level,
      explanationLanguage: explanationLanguage ?? this.explanationLanguage,
      deviceId: deviceId,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences prefs;

  SettingsNotifier(this.prefs) : super(_loadInitialState(prefs));

  static SettingsState _loadInitialState(SharedPreferences prefs) {
    String? deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      prefs.setString('device_id', deviceId);
    }

    return SettingsState(
      goal: prefs.getString('goal') ?? 'exam_prep',
      level: prefs.getString('level') ?? 'intermediate',
      explanationLanguage: prefs.getString('explanation_language') ?? 'id',
      deviceId: deviceId,
    );
  }

  Future<void> updateSettings({String? goal, String? level, String? explanationLanguage}) async {
    if (goal != null) await prefs.setString('goal', goal);
    if (level != null) await prefs.setString('level', level);
    if (explanationLanguage != null) await prefs.setString('explanation_language', explanationLanguage);

    state = state.copyWith(
      goal: goal,
      level: level,
      explanationLanguage: explanationLanguage,
    );
  }

  bool get isOnboardingComplete {
    return prefs.containsKey('goal') && prefs.containsKey('level') && prefs.containsKey('explanation_language');
  }

  Future<void> completeOnboarding({required String goal, required String level, required String explanationLanguage}) async {
    await updateSettings(goal: goal, level: level, explanationLanguage: explanationLanguage);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});
