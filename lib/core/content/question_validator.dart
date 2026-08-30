import 'dart:convert';
import 'dart:io';

class QuestionValidator {
  final String basePath;
  final String researchPath;

  QuestionValidator({required this.basePath, required this.researchPath});

  Future<String> validateAll() async {
    final buffer = StringBuffer();
    buffer.writeln('=== QUESTION VALIDATION REPORT ===\n');

    final questionsFile = File('$basePath/questions.json');
    if (!await questionsFile.exists()) {
      buffer.writeln('ERROR: questions.json not found in $basePath.');
      return buffer.toString();
    }

    final rulesFile = File('$researchPath/rules.json');
    final signsFile = File('$researchPath/road_signs.json');

    final Set<String> validRuleIds = {};
    if (await rulesFile.exists()) {
      final rulesJson = jsonDecode(await rulesFile.readAsString()) as List;
      for (var rule in rulesJson) {
        validRuleIds.add(rule['ruleId'] as String);
      }
    }

    final Set<String> validSignIds = {};
    if (await signsFile.exists()) {
      final signsJson = jsonDecode(await signsFile.readAsString()) as List;
      for (var sign in signsJson) {
        validSignIds.add(sign['signResearchId'] as String);
      }
    }

    final questionsJson = jsonDecode(await questionsFile.readAsString()) as List;
    
    int total = questionsJson.length;
    int valid = 0;
    int review = 0;
    int rejected = 0;
    int errors = 0;

    final Set<String> questionIds = {};
    final Set<String> questionTexts = {};

    for (var i = 0; i < total; i++) {
      final q = questionsJson[i];
      final id = q['id'] as String?;
      final text = q['text'] as String?;
      final options = q['options'] as List<dynamic>?;
      final correctIndex = q['correctIndex'] as int?;
      final explanation = q['explanation'] as String?;
      final ruleId = q['ruleId'] as String?;
      final sourceId = q['sourceId'] as String?;
      final difficulty = q['difficulty'] as String?;
      final status = q['verificationStatus'] as String?;
      final stateId = q['stateId'] as String?;
      final category = q['category'] as String?;

      bool hasError = false;

      if (id == null) {
        buffer.writeln('  [ERROR] Question at index $i is missing an ID.');
        hasError = true;
      } else {
        if (questionIds.contains(id)) {
          buffer.writeln('  [ERROR] Duplicate question ID: $id');
          hasError = true;
        }
        questionIds.add(id);
      }

      if (text == null || text.trim().isEmpty) {
        buffer.writeln('  [ERROR] Question $id has no text.');
        hasError = true;
      } else {
        final normalizedText = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        if (questionTexts.contains(normalizedText)) {
          buffer.writeln('  [ERROR] Duplicate question text detected: "$text"');
          hasError = true;
        }
        questionTexts.add(normalizedText);
      }

      if (options == null || options.length != 4) {
        buffer.writeln('  [ERROR] Question $id does not have exactly 4 options.');
        hasError = true;
      } else {
        final Set<String> uniqueOptions = {};
        for (var opt in options) {
          if (opt.toString().trim().isEmpty) {
            buffer.writeln('  [ERROR] Question $id has an empty option.');
            hasError = true;
          }
          uniqueOptions.add(opt.toString().trim().toLowerCase());
        }
        if (uniqueOptions.length != 4) {
          buffer.writeln('  [ERROR] Question $id has duplicate options.');
          hasError = true;
        }
      }

      if (correctIndex == null || correctIndex < 0 || correctIndex > 3) {
        buffer.writeln('  [ERROR] Question $id has invalid correctIndex: $correctIndex');
        hasError = true;
      }

      if (explanation == null || explanation.trim().isEmpty) {
        buffer.writeln('  [ERROR] Question $id is missing an explanation.');
        hasError = true;
      }

      if (ruleId == null) {
        buffer.writeln('  [ERROR] Question $id is missing a ruleId.');
        hasError = true;
      } else {
        if (!validRuleIds.contains(ruleId) && !validSignIds.contains(ruleId)) {
          buffer.writeln('  [ERROR] Question $id references unknown ruleId/signId: $ruleId');
          hasError = true;
        }
      }

      if (sourceId == null) {
        buffer.writeln('  [ERROR] Question $id is missing a sourceId.');
        hasError = true;
      }

      if (stateId == null) {
        buffer.writeln('  [ERROR] Question $id is missing a stateId.');
        hasError = true;
      }

      if (category == null || category.trim().isEmpty) {
        buffer.writeln('  [ERROR] Question $id is missing a category.');
        hasError = true;
      }

      if (difficulty == null || !['easy', 'medium', 'hard'].contains(difficulty.toLowerCase())) {
        buffer.writeln('  [ERROR] Question $id has invalid difficulty: $difficulty');
        hasError = true;
      }

      if (hasError) {
        errors++;
        rejected++;
      } else {
        if (status == 'REVIEW' || status == 'needs_review') {
          review++;
        } else if (status == 'VERIFIED' || status == 'verified') {
          valid++;
        } else {
          buffer.writeln('  [WARNING] Question $id has unknown status: $status');
          review++;
        }
      }
    }

    buffer.writeln('\nTotal: $total');
    buffer.writeln('Valid (VERIFIED): $valid');
    buffer.writeln('Review (DRAFT/REVIEW): $review');
    buffer.writeln('Rejected: $rejected');
    buffer.writeln('Errors: $errors');
    buffer.writeln('\n=== END OF REPORT ===');
    
    return buffer.toString();
  }
}
