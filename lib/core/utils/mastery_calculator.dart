library;

/// Pure logic for calculating question mastery.
class MasteryCalculator {
  /// Calculates the new mastery level and consecutive correct answers.
  /// 
  /// Returns a Map containing:
  /// - 'level': The new mastery level (1=Learning, 2=Improving, 3=Mastered)
  /// - 'consecutive': The new consecutive correct answers count
  static Map<String, int> calculateNewMastery(bool isCorrect, int currentConsecutive) {
    int consecutive = currentConsecutive;
    int level = 0;
    
    if (isCorrect) {
      consecutive += 1;
      level = consecutive >= 2 ? 3 : 2; // >=2 is Mastered, 1 is Improving
    } else {
      consecutive = 0;
      level = 1; // Learning
    }
    
    return {'level': level, 'consecutive': consecutive};
  }
}
