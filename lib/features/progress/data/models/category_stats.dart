library;

import 'package:flutter/foundation.dart';

@immutable
class CategoryStats {
  const CategoryStats({
    required this.categoryName,
    required this.questionsAnswered,
    required this.correctAnswers,
  });

  final String categoryName;
  final int questionsAnswered;
  final int correctAnswers;

  double get accuracy => 
      questionsAnswered > 0 ? correctAnswers / questionsAnswered : 0.0;
}
