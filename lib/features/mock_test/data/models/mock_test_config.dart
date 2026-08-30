library;

/// Configuration for a Mock Test session.
class MockTestConfig {
  const MockTestConfig({
    this.questionCount = 40,
    this.timeLimitMinutes = 45,
    this.passingScorePercentage = 80,
  });

  final int questionCount;
  final int timeLimitMinutes;
  final int passingScorePercentage;

  /// Returns the number of questions required to pass.
  int get requiredCorrectCount =>
      (questionCount * (passingScorePercentage / 100)).ceil();
}
