import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/core/content/content_validator.dart';

void main() {
  group('ContentValidator Tests', () {
    test('Should return error for missing file', () {
      final errors = ContentValidator.validateQuestions('non_existent.json');
      expect(errors, isNotEmpty);
      expect(errors.first, contains('File not found'));
    });

    // Note: To fully unit test the validator, we could create temp files with bad JSON
    // and assert on specific error strings (e.g. duplicate IDs, missing options).
    // For now, we assume the logic holds and we will validate the actual real files.
  });
}
