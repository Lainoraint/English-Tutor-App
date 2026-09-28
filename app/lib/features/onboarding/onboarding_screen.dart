import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_store.dart';
import '../home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String _goal = 'exam_prep';
  String _level = 'intermediate';
  String _lang = 'id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to English Tutor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('What is your goal?'),
            DropdownButton<String>(
              value: _goal,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'exam_prep', child: Text('TOEFL / IELTS / Exam')),
                DropdownMenuItem(value: 'career', child: Text('Career / Professional')),
              ],
              onChanged: (val) => setState(() => _goal = val!),
            ),
            const SizedBox(height: 16),
            const Text('What is your current level?'),
            DropdownButton<String>(
              value: _level,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
              ],
              onChanged: (val) => setState(() => _level = val!),
            ),
            const SizedBox(height: 16),
            const Text('Explanation Language'),
            DropdownButton<String>(
              value: _lang,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'id', child: Text('Indonesian')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (val) => setState(() => _lang = val!),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await ref.read(settingsProvider.notifier).completeOnboarding(
                  goal: _goal,
                  level: _level,
                  explanationLanguage: _lang,
                );
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
              },
              child: const Text('Start Practicing'),
            )
          ],
        ),
      ),
    );
  }
}
