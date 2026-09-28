import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Tutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings (placeholder)
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Conversation'),
              subtitle: const Text('Practice free chat'),
              onTap: () {}, // placeholder
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.quiz),
              title: const Text('Vocabulary Quiz'),
              subtitle: const Text('Fill in the blanks'),
              onTap: () {}, // placeholder
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.mic),
              title: const Text('Speaking Practice'),
              subtitle: const Text('Answer prompts with your voice'),
              onTap: () {}, // placeholder
            ),
          ),
        ],
      ),
    );
  }
}
