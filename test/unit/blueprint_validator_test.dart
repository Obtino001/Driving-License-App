import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'dart:convert';
import '../../lib/core/content/blueprint_validator.dart';

void main() {
  group('BlueprintValidator Tests', () {
    late Directory tempDir;
    late String basePath;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('blueprint_validator_test_');
      basePath = tempDir.path;
      final stateDir = Directory('$basePath/ca');
      await stateDir.create(recursive: true);

      // Create fake rules
      final rules = [
        {"ruleId": "rule_1"}
      ];
      await File('${stateDir.path}/rules.json').writeAsString(jsonEncode(rules));

      // Create fake signs
      final signs = [
        {"signResearchId": "sign_1"}
      ];
      await File('${stateDir.path}/road_signs.json').writeAsString(jsonEncode(signs));
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('Should pass for valid blueprint', () async {
      final blueprint = {
        "rulesBlueprint": [
          {
            "ruleId": "rule_1",
            "angles": [
              {"type": "standard_mcq", "difficulty": "easy"}
            ]
          }
        ],
        "signsBlueprint": [
          {
            "signResearchId": "sign_1",
            "angles": [
              {"type": "sign_question", "difficulty": "medium"}
            ]
          }
        ]
      };
      await File('$basePath/ca/question_blueprint.json').writeAsString(jsonEncode(blueprint));

      final validator = BlueprintValidator(basePath: basePath);
      final report = await validator.validateBlueprint('ca');

      expect(report, contains('Validation passed.'));
      expect(report, isNot(contains('ERROR')));
    });

    test('Should detect invalid rules and invalid types', () async {
      final blueprint = {
        "rulesBlueprint": [
          {
            "ruleId": "rule_missing",
            "angles": [
              {"type": "invalid_type", "difficulty": "easy"}
            ]
          }
        ],
        "signsBlueprint": []
      };
      await File('$basePath/ca/question_blueprint.json').writeAsString(jsonEncode(blueprint));

      final validator = BlueprintValidator(basePath: basePath);
      final report = await validator.validateBlueprint('ca');

      expect(report, contains('ERROR] Blueprint references nonexistent ruleId: rule_missing'));
      expect(report, contains('ERROR] Invalid angle type "invalid_type" in rule: rule_missing'));
      expect(report, contains('Failed with 2 errors.'));
    });
  });
}
