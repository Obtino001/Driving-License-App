import 'dart:convert';
import 'dart:io';

class BlueprintValidator {
  final String basePath;

  BlueprintValidator({required this.basePath});

  Future<String> validateBlueprint(String stateId) async {
    final buffer = StringBuffer();
    buffer.writeln('=== BLUEPRINT VALIDATION REPORT ===\n');

    final stateDir = '$basePath/$stateId';
    final blueprintFile = File('$stateDir/question_blueprint.json');
    final rulesFile = File('$stateDir/rules.json');
    final signsFile = File('$stateDir/road_signs.json');

    if (!await blueprintFile.exists()) {
      buffer.writeln('ERROR: question_blueprint.json not found.');
      return buffer.toString();
    }

    final blueprintJson = jsonDecode(await blueprintFile.readAsString()) as Map<String, dynamic>;
    final rulesList = await rulesFile.exists() ? jsonDecode(await rulesFile.readAsString()) as List : [];
    final signsList = await signsFile.exists() ? jsonDecode(await signsFile.readAsString()) as List : [];

    final validRuleIds = rulesList.map((e) => e['ruleId'] as String).toSet();
    final validSignIds = signsList.map((e) => e['signResearchId'] as String).toSet();

    final rulesBlueprint = blueprintJson['rulesBlueprint'] as List;
    final signsBlueprint = blueprintJson['signsBlueprint'] as List;

    int validRefs = 0;
    int errorCount = 0;

    final validTypes = {'standard_mcq', 'scenario', 'exception', 'numerical', 'sign_question'};
    final validDifficulties = {'easy', 'medium', 'hard'};

    for (var ruleBp in rulesBlueprint) {
      final ruleId = ruleBp['ruleId'] as String;
      if (!validRuleIds.contains(ruleId)) {
        buffer.writeln('  [ERROR] Blueprint references nonexistent ruleId: $ruleId');
        errorCount++;
      } else {
        validRefs++;
      }

      final angles = ruleBp['angles'] as List;
      for (var angle in angles) {
        final type = angle['type'];
        final difficulty = angle['difficulty'];
        if (!validTypes.contains(type)) {
          buffer.writeln('  [ERROR] Invalid angle type "$type" in rule: $ruleId');
          errorCount++;
        }
        if (!validDifficulties.contains(difficulty)) {
          buffer.writeln('  [ERROR] Invalid difficulty "$difficulty" in rule: $ruleId');
          errorCount++;
        }
      }
    }

    for (var signBp in signsBlueprint) {
      final signId = signBp['signResearchId'] as String;
      if (!validSignIds.contains(signId)) {
        buffer.writeln('  [ERROR] Blueprint references nonexistent signResearchId: $signId');
        errorCount++;
      } else {
        validRefs++;
      }

      final angles = signBp['angles'] as List;
      for (var angle in angles) {
        final type = angle['type'];
        final difficulty = angle['difficulty'];
        if (!validTypes.contains(type)) {
          buffer.writeln('  [ERROR] Invalid angle type "$type" in sign: $signId');
          errorCount++;
        }
        if (!validDifficulties.contains(difficulty)) {
          buffer.writeln('  [ERROR] Invalid difficulty "$difficulty" in sign: $signId');
          errorCount++;
        }
      }
    }

    buffer.writeln('Verified $validRefs valid blueprint references.');
    if (errorCount > 0) {
      buffer.writeln('Failed with $errorCount errors.');
    } else {
      buffer.writeln('Validation passed.');
    }

    buffer.writeln('=== END OF REPORT ===');
    return buffer.toString();
  }
}
