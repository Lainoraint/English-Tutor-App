import 'package:flutter_test/flutter_test.dart';
import 'package:english_tutor_app/core/models/contract_models.dart';
import 'dart:convert';

void main() {
  test('ChatResponse parses JSON correctly', () {
    const jsonStr = '''
    {
      "reply": "That sounds stressful! How did the exam go?",
      "corrections": [
        {
          "original": "Yesterday I go to school and take a exam.",
          "fixed": "Yesterday I went to school and took an exam.",
          "explanation": "Gunakan past tense"
        }
      ]
    }
    ''';
    
    final jsonMap = jsonDecode(jsonStr);
    final response = ChatResponse.fromJson(jsonMap);
    
    expect(response.reply, "That sounds stressful! How did the exam go?");
    expect(response.corrections.length, 1);
    expect(response.corrections.first.fixed, "Yesterday I went to school and took an exam.");
  });

  test('QuizResponse parses JSON correctly', () {
    const jsonStr = '''
    {
      "questions": [
        {
          "target_word": "postpone",
          "sentence": "We had to ____ the meeting.",
          "options": ["postpone", "improve", "borrow", "arrive"],
          "correct_index": 0,
          "explanation": "'Postpone' artinya menunda"
        }
      ]
    }
    ''';
    
    final jsonMap = jsonDecode(jsonStr);
    final response = QuizResponse.fromJson(jsonMap);
    
    expect(response.questions.length, 1);
    expect(response.questions.first.targetWord, "postpone");
    expect(response.questions.first.options.length, 4);
    expect(response.questions.first.correctIndex, 0);
  });
}
