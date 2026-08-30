/// Question data model — pure Dart, no Flutter dependencies.
library;

import 'dart:convert';

/// Represents a single driving test question.
class Question {
  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.category = '',
    this.imageUrl,
    this.stateId,
    this.subcategoryId,
    this.difficulty,
    this.ruleId,
    this.sourceId,
    this.sourceSection,
    this.sourcePage,
    this.sourceVersion,
    this.lastVerified,
    this.verificationStatus,
  });

  /// Unique identifier.
  final String id;

  /// The question text.
  final String text;

  /// List of 4 answer options.
  final List<String> options;

  /// Index (0-based) of the correct answer in [options].
  final int correctIndex;

  /// Explanation of why the correct answer is right.
  final String explanation;

  /// Category this question belongs to.
  final String category;

  /// Optional image URL (e.g., road sign illustration).
  final String? imageUrl;

  /// ID of the state this question belongs to.
  final String? stateId;

  /// ID of the subcategory this question belongs to.
  final String? subcategoryId;

  /// Difficulty level, e.g., 'easy', 'medium', 'hard'.
  final String? difficulty;

  /// Related rule ID for this question.
  final String? ruleId;

  /// ID of the source for this question.
  final String? sourceId;

  /// Section within the source.
  final String? sourceSection;

  /// Page number/identifier within the source.
  final String? sourcePage;

  /// Version of the source.
  final String? sourceVersion;

  /// Unix timestamp of when the content was last verified.
  final int? lastVerified;

  /// Status of verification, e.g., 'verified', 'needs_review'.
  final String? verificationStatus;

  /// The correct answer text.
  String get correctAnswer => options[correctIndex];

  /// Creates a [Question] from a JSON map (e.g. parsed from asset).
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      stateId: json['stateId'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
      difficulty: json['difficulty'] as String?,
      ruleId: json['ruleId'] as String?,
      sourceId: json['sourceId'] as String?,
      sourceSection: json['sourceSection'] as String?,
      sourcePage: json['sourcePage'] as String?,
      sourceVersion: json['sourceVersion'] as String?,
      lastVerified: json['lastVerified'] as int?,
      verificationStatus: json['verificationStatus'] as String?,
    );
  }

  /// Converts the question to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
      'category': category,
      'imageUrl': imageUrl,
      'stateId': stateId,
      'subcategoryId': subcategoryId,
      'difficulty': difficulty,
      'ruleId': ruleId,
      'sourceId': sourceId,
      'sourceSection': sourceSection,
      'sourcePage': sourcePage,
      'sourceVersion': sourceVersion,
      'lastVerified': lastVerified,
      'verificationStatus': verificationStatus,
    };
  }

  /// Converts the question to a flat map suitable for SQLite insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': category.toLowerCase().replaceAll(' ', '_'),
      'text': text,
      'options_json': jsonEncode(options),
      'correct_index': correctIndex,
      'explanation': explanation,
      'image_url': imageUrl,
      'state_id': stateId,
      'subcategory_id': subcategoryId,
      'difficulty': difficulty,
      'rule_id': ruleId,
      'source_id': sourceId,
      'source_section': sourceSection,
      'source_page': sourcePage,
      'source_version': sourceVersion,
      'last_verified': lastVerified,
      'verification_status': verificationStatus,
    };
  }

  /// Creates a [Question] from a SQLite map.
  factory Question.fromMap(Map<String, dynamic> map, String categoryName) {
    return Question(
      id: map['id'] as String,
      text: map['text'] as String,
      options: List<String>.from(jsonDecode(map['options_json'] as String)),
      correctIndex: map['correct_index'] as int,
      explanation: map['explanation'] as String,
      category: categoryName,
      imageUrl: map['image_url'] as String?,
      stateId: map['state_id'] as String?,
      subcategoryId: map['subcategory_id'] as String?,
      difficulty: map['difficulty'] as String?,
      ruleId: map['rule_id'] as String?,
      sourceId: map['source_id'] as String?,
      sourceSection: map['source_section'] as String?,
      sourcePage: map['source_page'] as String?,
      sourceVersion: map['source_version'] as String?,
      lastVerified: map['last_verified'] as int?,
      verificationStatus: map['verification_status'] as String?,
    );
  }
}

/// The state of a single question during a quiz session.
enum QuestionStatus {
  /// User hasn't interacted yet.
  unanswered,

  /// User tapped an answer; brief highlight before reveal.
  selected,

  /// Answer revealed as correct.
  correct,

  /// Answer revealed as incorrect.
  incorrect,
}

/// Tracks user interaction with a single question.
class QuestionResult {
  const QuestionResult({
    required this.questionIndex,
    this.selectedIndex,
    this.status = QuestionStatus.unanswered,
    this.isBookmarked = false,
    this.timeSpentMs = 0,
  });

  final int questionIndex;
  final int? selectedIndex;
  final QuestionStatus status;
  final bool isBookmarked;
  final int timeSpentMs;

  bool get isCorrect => status == QuestionStatus.correct;
  bool get isAnswered =>
      status == QuestionStatus.correct || status == QuestionStatus.incorrect;

  QuestionResult copyWith({
    int? questionIndex,
    int? selectedIndex,
    QuestionStatus? status,
    bool? isBookmarked,
    int? timeSpentMs,
  }) {
    return QuestionResult(
      questionIndex: questionIndex ?? this.questionIndex,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      status: status ?? this.status,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      timeSpentMs: timeSpentMs ?? this.timeSpentMs,
    );
  }
}
