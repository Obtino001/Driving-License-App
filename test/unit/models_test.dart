import 'package:flutter_test/flutter_test.dart';
import '../../lib/features/practice/data/models/question.dart';
import '../../lib/core/models/region_state.dart';
import '../../lib/core/models/driving_rule.dart';

void main() {
  group('Model Tests', () {
    test('Question handles new fields correctly in toMap/fromMap', () {
      final q = Question(
        id: '123',
        text: 'Test',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
        explanation: 'Because',
        stateId: 'us_ca',
        difficulty: 'hard',
      );

      final map = q.toMap();
      expect(map['state_id'], 'us_ca');
      expect(map['difficulty'], 'hard');

      final q2 = Question.fromMap(map, 'TestCategory');
      expect(q2.stateId, 'us_ca');
      expect(q2.difficulty, 'hard');
      expect(q2.id, '123');
    });

    test('RegionState parses from JSON correctly', () {
      final json = {
        "stateId": "us_ca",
        "stateCode": "US-CA",
        "stateName": "California",
        "abbreviation": "CA",
        "licensingAuthority": "DMV",
        "status": "COMING_SOON"
      };

      final state = RegionState.fromJson(json);
      expect(state.stateName, 'California');
      expect(state.abbreviation, 'CA');
      expect(state.status, 'COMING_SOON');
    });

    test('DrivingRule parses from JSON correctly with new version fields', () {
      final json = {
        "ruleId": "ca_rule_test",
        "stateId": "ca",
        "topic": "Test Topic",
        "subtopic": "Test Subtopic",
        "ruleSummary": "Rule summary",
        "sourceId": "ca_dmv",
        "sourceVersion": "v1.0",
        "contentVersion": "v2.0",
        "effectiveDate": "2024-01-01",
        "lastVerified": 1234567890,
        "status": "verified"
      };

      final rule = DrivingRule.fromJson(json);
      expect(rule.ruleId, 'ca_rule_test');
      expect(rule.contentVersion, 'v2.0');
      expect(rule.effectiveDate, '2024-01-01');
      expect(rule.sourceVersion, 'v1.0');
    });
  });
}
