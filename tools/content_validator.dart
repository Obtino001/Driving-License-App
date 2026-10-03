import 'dart:convert';
import 'dart:io';

void main() async {
  print('Running Content Validator...');

  await validateQuestions();
  await validateSigns();

  print('Validation complete.');
}

Future<void> validateQuestions() async {
  final file = File('assets/content/questions_v1.json');
  if (!await file.exists()) {
    print('❌ Error: questions_v1.json not found');
    exit(1);
  }

  final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  final questions = data['questions'] as List;
  print('Validating \${questions.length} questions...');

  final ids = <String>{};

  for (final q in questions) {
    final id = q['id'];

    // Check ID
    if (ids.contains(id)) {
      print('❌ Error: Duplicate question ID \$id');
      exit(1);
    }
    ids.add(id);

    // Check Options
    final options = q['options'] as List;
    if (options.length != 3) {
      print('❌ Error: Question \$id must have exactly 3 choices');
      exit(1);
    }

    final uniqueOptions = options.map((e) => e.toString().trim()).toSet();
    if (uniqueOptions.length != 3) {
      print('❌ Error: Question \$id has duplicate choices');
      exit(1);
    }

    // Check Correct Index
    final correct = q['correctIndex'];
    if (correct < 0 || correct > 2) {
      print('❌ Error: Question \$id has invalid correctIndex \$correct');
      exit(1);
    }

    // Required Strings
    if (q['explanationShort'] == null ||
        (q['explanationShort'] as String).isEmpty) {
      print('❌ Error: Question \$id is missing explanationShort');
      exit(1);
    }
    if (q['category'] == null || (q['category'] as String).isEmpty) {
      print('❌ Error: Question \$id is missing category');
      exit(1);
    }
    if (q['reviewStatus'] == null || (q['reviewStatus'] as String).isEmpty) {
      print('❌ Error: Question \$id is missing reviewStatus');
      exit(1);
    }
  }

  print('✅ Questions validation passed.');
}

Future<void> validateSigns() async {
  final file = File('assets/content/signs_v1.json');
  if (!await file.exists()) {
    print('❌ Error: signs_v1.json not found');
    exit(1);
  }

  final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  final signs = data['signs'] as List;
  print('Validating \${signs.length} signs...');

  final ids = <String>{};

  for (final s in signs) {
    final id = s['id'];

    if (ids.contains(id)) {
      print('❌ Error: Duplicate sign ID \$id');
      exit(1);
    }
    ids.add(id);

    if (s['assetPath'] == null || (s['assetPath'] as String).isEmpty) {
      print('❌ Error: Sign \$id is missing assetPath');
      exit(1);
    }
  }
  print('✅ Signs validation passed.');
}
