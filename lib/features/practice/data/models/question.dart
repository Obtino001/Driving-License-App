/// Question data model — pure Dart, no Flutter dependencies.
library;

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

  /// The correct answer text.
  String get correctAnswer => options[correctIndex];
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
