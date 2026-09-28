// Based on API_CONTRACT.md

class Correction {
  final String original;
  final String fixed;
  final String explanation;

  Correction({required this.original, required this.fixed, required this.explanation});

  factory Correction.fromJson(Map<String, dynamic> json) {
    return Correction(
      original: json['original'] as String,
      fixed: json['fixed'] as String,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'original': original,
    'fixed': fixed,
    'explanation': explanation,
  };
}

class ChatMessage {
  final String role;
  final String text;

  ChatMessage({required this.role, required this.text});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role,
    'text': text,
  };
}

class ChatResponse {
  final String reply;
  final List<Correction> corrections;

  ChatResponse({required this.reply, required this.corrections});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      reply: json['reply'] as String,
      corrections: (json['corrections'] as List)
          .map((e) => Correction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuizQuestion {
  final String targetWord;
  final String sentence;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  QuizQuestion({
    required this.targetWord,
    required this.sentence,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      targetWord: json['target_word'] as String,
      sentence: json['sentence'] as String,
      options: List<String>.from(json['options']),
      correctIndex: json['correct_index'] as int,
      explanation: json['explanation'] as String,
    );
  }
}

class QuizResponse {
  final List<QuizQuestion> questions;

  QuizResponse({required this.questions});

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      questions: (json['questions'] as List)
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SpeakingPromptResponse {
  final String prompt;
  final List<String> tips;

  SpeakingPromptResponse({required this.prompt, required this.tips});

  factory SpeakingPromptResponse.fromJson(Map<String, dynamic> json) {
    return SpeakingPromptResponse(
      prompt: json['prompt'] as String,
      tips: List<String>.from(json['tips']),
    );
  }
}

class Scores {
  final int grammar;
  final int vocabulary;
  final int coherence;

  Scores({required this.grammar, required this.vocabulary, required this.coherence});

  factory Scores.fromJson(Map<String, dynamic> json) {
    return Scores(
      grammar: json['grammar'] as int,
      vocabulary: json['vocabulary'] as int,
      coherence: json['coherence'] as int,
    );
  }
}

class SpeakingFeedbackResponse {
  final List<String> good;
  final List<Correction> improve;
  final String polished;
  final Scores scores;

  SpeakingFeedbackResponse({
    required this.good,
    required this.improve,
    required this.polished,
    required this.scores,
  });

  factory SpeakingFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return SpeakingFeedbackResponse(
      good: List<String>.from(json['good']),
      improve: (json['improve'] as List)
          .map((e) => Correction.fromJson(e as Map<String, dynamic>))
          .toList(),
      polished: json['polished'] as String,
      scores: Scores.fromJson(json['scores'] as Map<String, dynamic>),
    );
  }
}
