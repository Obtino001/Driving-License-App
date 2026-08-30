import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:driving_license_app/core/content/question_validator.dart';

void main() {
  group('QuestionValidator Tests', () {
    late Directory tempDir;
    late Directory researchDir;
    late QuestionValidator validator;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('questions_test');
      researchDir = await Directory('${tempDir.path}/research').create();
      validator = QuestionValidator(basePath: tempDir.path, researchPath: researchDir.path);
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('Should return error if questions.json is missing', () async {
      final report = await validator.validateAll();
      expect(report, contains('ERROR: questions.json not found'));
    });

    test('Should validate clean data without errors', () async {
      // 1. Create rules and signs
      final rulesFile = File('${researchDir.path}/rules.json');
      await rulesFile.writeAsString(jsonEncode([
        {
          "ruleId": "rule_1",
          "stateId": "ca",
          "topic": "Speed",
          "subtopic": "Limits",
          "ruleSummary": "Speed is 25.",
          "sourceId": "ca_handbook",
          "sourceVersion": "2024",
          "lastVerified": 1000,
          "status": "verified"
        }
      ]));

      final signsFile = File('${researchDir.path}/road_signs.json');
      await signsFile.writeAsString(jsonEncode([]));

      // 2. Create questions.json
      final questionsFile = File('${tempDir.path}/questions.json');
      await questionsFile.writeAsString(jsonEncode([
        {
          "id": "q1",
          "text": "What is the speed?",
          "options": ["15", "25", "35", "45"],
          "correctIndex": 1,
          "explanation": "Because 25.",
          "category": "Speed",
          "stateId": "ca",
          "difficulty": "easy",
          "ruleId": "rule_1",
          "sourceId": "ca_handbook",
          "verificationStatus": "REVIEW"
        }
      ]));

      final report = await validator.validateAll();
      expect(report, isNot(contains('ERROR')));
      expect(report, contains('Total: 1'));
      expect(report, contains('Review (DRAFT/REVIEW): 1'));
    });

    test('Should detect missing fields and invalid options', () async {
      final rulesFile = File('${researchDir.path}/rules.json');
      await rulesFile.writeAsString(jsonEncode([
        {"ruleId": "rule_1"}
      ]));

      final questionsFile = File('${tempDir.path}/questions.json');
      await questionsFile.writeAsString(jsonEncode([
        {
          "id": "q1",
          "text": "What is the speed?",
          "options": ["15", "25", "35"], // Only 3 options
          "correctIndex": 4, // Invalid index
          "explanation": "", // Empty explanation
          "category": "Speed",
          "stateId": "ca",
          "difficulty": "invalid_difficulty", // Invalid difficulty
          "ruleId": "unknown_rule", // Invalid rule
          "sourceId": "ca_handbook",
          "verificationStatus": "REVIEW"
        }
      ]));

      final report = await validator.validateAll();
      expect(report, contains('does not have exactly 4 options'));
      expect(report, contains('invalid correctIndex: 4'));
      expect(report, contains('missing an explanation'));
      expect(report, contains('references unknown ruleId'));
      expect(report, contains('invalid difficulty'));
    });

    test('Should detect duplicate question texts', () async {
      final rulesFile = File('${researchDir.path}/rules.json');
      await rulesFile.writeAsString(jsonEncode([
        {"ruleId": "rule_1"}
      ]));

      final questionsFile = File('${tempDir.path}/questions.json');
      await questionsFile.writeAsString(jsonEncode([
        {
          "id": "q1",
          "text": "What is the speed?",
          "options": ["15", "25", "35", "45"],
          "correctIndex": 1,
          "explanation": "Because 25.",
          "category": "Speed",
          "stateId": "ca",
          "difficulty": "easy",
          "ruleId": "rule_1",
          "sourceId": "ca_handbook",
          "verificationStatus": "REVIEW"
        },
        {
          "id": "q2",
          "text": "What is the speed? ", // Fuzzy duplicate
          "options": ["15", "25", "35", "45"],
          "correctIndex": 1,
          "explanation": "Because 25.",
          "category": "Speed",
          "stateId": "ca",
          "difficulty": "easy",
          "ruleId": "rule_1",
          "sourceId": "ca_handbook",
          "verificationStatus": "REVIEW"
        }
      ]));

      final report = await validator.validateAll();
      expect(report, contains('Duplicate question text detected'));
    });
  });
}
