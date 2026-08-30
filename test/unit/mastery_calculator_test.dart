import 'package:flutter_test/flutter_test.dart';
import 'package:driving_license_app/core/utils/mastery_calculator.dart';

void main() {
  group('MasteryCalculator', () {
    test('Correct answer moves from Learning to Improving (level 2)', () {
      final result = MasteryCalculator.calculateNewMastery(true, 0);
      expect(result['level'], 2);
      expect(result['consecutive'], 1);
    });

    test('Second correct answer moves from Improving to Mastered (level 3)', () {
      final result = MasteryCalculator.calculateNewMastery(true, 1);
      expect(result['level'], 3);
      expect(result['consecutive'], 2);
    });

    test('Incorrect answer drops to Learning (level 1)', () {
      final result = MasteryCalculator.calculateNewMastery(false, 5);
      expect(result['level'], 1);
      expect(result['consecutive'], 0);
    });
  });
}
