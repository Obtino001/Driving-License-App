library;

import 'dart:convert';
import 'dart:io';

/// Validates driving content JSON files (questions, road signs, states, sources)
/// ensuring data integrity before release.
class ContentValidator {
  
  /// Validates a single state's question JSON file.
  static List<String> validateQuestions(String filePath) {
    final errors = <String>[];
    
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        return ['File not found: $filePath'];
      }

      final content = file.readAsStringSync();
      final List<dynamic> questions = jsonDecode(content);
      
      final seenIds = <String>{};

      for (var i = 0; i < questions.length; i++) {
        final q = questions[i] as Map<String, dynamic>;
        final qId = q['id'] as String?;
        
        if (qId == null || qId.isEmpty) {
          errors.add('Question at index $i is missing an ID.');
          continue;
        }

        if (seenIds.contains(qId)) {
          errors.add('Duplicate Question ID found: $qId');
        }
        seenIds.add(qId);

        final options = q['options'] as List<dynamic>?;
        if (options == null || options.length != 4) {
          errors.add('Question $qId must have exactly 4 options.');
        }

        final correctIndex = q['correctIndex'] as int?;
        if (correctIndex == null || correctIndex < 0 || correctIndex > 3) {
          errors.add('Question $qId has invalid correctIndex: $correctIndex');
        }

        final explanation = q['explanation'] as String?;
        if (explanation == null || explanation.trim().isEmpty) {
          errors.add('Question $qId is missing an explanation.');
        }

        final category = q['category'] as String?;
        if (category == null || category.trim().isEmpty) {
          errors.add('Question $qId is missing a category.');
        }
      }
    } catch (e) {
      errors.add('Failed to validate $filePath: $e');
    }

    return errors;
  }

  /// Validates a single state's road signs JSON file.
  static List<String> validateRoadSigns(String filePath) {
    final errors = <String>[];
    
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        return ['File not found: $filePath'];
      }

      final content = file.readAsStringSync();
      final List<dynamic> signs = jsonDecode(content);
      
      final seenIds = <String>{};

      for (var i = 0; i < signs.length; i++) {
        final s = signs[i] as Map<String, dynamic>;
        final sId = s['id'] as String?;
        
        if (sId == null || sId.isEmpty) {
          errors.add('RoadSign at index $i is missing an ID.');
          continue;
        }

        if (seenIds.contains(sId)) {
          errors.add('Duplicate RoadSign ID found: $sId');
        }
        seenIds.add(sId);

        final name = s['name'] as String?;
        if (name == null || name.trim().isEmpty) {
          errors.add('RoadSign $sId is missing a name.');
        }

        final meaning = s['meaning'] as String?;
        if (meaning == null || meaning.trim().isEmpty) {
          errors.add('RoadSign $sId is missing a meaning.');
        }
      }
    } catch (e) {
      errors.add('Failed to validate $filePath: $e');
    }

    return errors;
  }
}
