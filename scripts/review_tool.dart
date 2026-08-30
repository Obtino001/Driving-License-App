import 'dart:convert';
import 'dart:io';

const String questionsPath = 'assets/data/us/ca/questions.json';
const String rulesPath = 'assets/data/us/research/ca/rules.json';
const String signsPath = 'assets/data/us/research/ca/road_signs.json';

void main(List<String> args) async {
  if (args.isEmpty) {
    printUsage();
    return;
  }

  final command = args[0];

  switch (command) {
    case 'report':
      await generateReport();
      break;
    case 'approve':
      if (args.length < 2) {
        print('Error: Missing question ID to approve.');
        return;
      }
      await updateStatus(args[1], 'VERIFIED');
      break;
    case 'reject':
      if (args.length < 2) {
        print('Error: Missing question ID to reject.');
        return;
      }
      await updateStatus(args[1], 'REJECTED');
      break;
    case 'deps':
      if (args.length < 2) {
        print('Error: Missing source or rule ID.');
        return;
      }
      await findDependencies(args[1]);
      break;
    default:
      printUsage();
  }
}

void printUsage() {
  print('''
Usage: dart run scripts/review_tool.dart <command> [args]

Commands:
  report             Generate a human-readable review report of all REVIEW questions.
  approve <ID>       Mark a specific question as VERIFIED.
  reject <ID>        Mark a specific question as REJECTED.
  deps <ID>          Find dependencies for a given Source ID or Rule ID.
''');
}

Future<void> generateReport() async {
  final file = File(questionsPath);
  if (!await file.exists()) {
    print('Error: questions.json not found.');
    return;
  }

  final questions = jsonDecode(await file.readAsString()) as List<dynamic>;
  final reviewQuestions = questions.where((q) => q['verificationStatus'] == 'REVIEW').toList();

  if (reviewQuestions.isEmpty) {
    print('No questions currently in REVIEW status.');
    return;
  }

  final buffer = StringBuffer();
  buffer.writeln('=== QUESTION REVIEW REPORT ===');
  buffer.writeln('Total questions needing review: ${reviewQuestions.length}\n');

  for (var q in reviewQuestions) {
    buffer.writeln('---');
    buffer.writeln('Question ID: ${q['id']}');
    buffer.writeln('Question: ${q['text']}\n');
    
    final options = q['options'] as List<dynamic>;
    final labels = ['A', 'B', 'C', 'D'];
    for (var i = 0; i < options.length; i++) {
      buffer.writeln('${labels[i]}. ${options[i]}');
    }
    
    buffer.writeln('\nCorrect Answer: ${labels[q['correctIndex'] as int]}');
    buffer.writeln('Explanation: ${q['explanation']}\n');
    
    buffer.writeln('Difficulty: ${q['difficulty']}');
    buffer.writeln('Category: ${q['category']}');
    buffer.writeln('Question Type: ${q['questionType']}');
    buffer.writeln('Underlying Rule/Sign: ${q['ruleId']}');
    buffer.writeln('Source: ${q['sourceId']}');
    if (q['sourceSection'] != null) buffer.writeln('Source Section/Page: ${q['sourceSection']}');
    if (q['sourceVersion'] != null) buffer.writeln('Source Version: ${q['sourceVersion']}');
    buffer.writeln('Verification Status: ${q['verificationStatus']}');
    buffer.writeln('\n## Review Notes (if any):');
    buffer.writeln(q['reviewNotes'] ?? 'None.');
    buffer.writeln('\n');
  }

  print(buffer.toString());
}

Future<void> updateStatus(String questionId, String status) async {
  final file = File(questionsPath);
  if (!await file.exists()) {
    print('Error: questions.json not found.');
    return;
  }

  final questions = jsonDecode(await file.readAsString()) as List<dynamic>;
  bool found = false;

  for (var i = 0; i < questions.length; i++) {
    if (questions[i]['id'] == questionId) {
      questions[i]['verificationStatus'] = status;
      if (status == 'VERIFIED') {
        questions[i]['reviewedAt'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        questions[i]['reviewerType'] = 'human';
      }
      found = true;
      break;
    }
  }

  if (!found) {
    print('Error: Question ID $questionId not found.');
    return;
  }

  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  await file.writeAsString(encoder.convert(questions));
  print('Successfully updated $questionId to $status.');
}

Future<void> findDependencies(String id) async {
  print('=== DEPENDENCY REPORT FOR: $id ===\n');
  
  final rulesFile = File(rulesPath);
  final signsFile = File(signsPath);
  final questionsFile = File(questionsPath);

  List<dynamic> rules = [];
  List<dynamic> signs = [];
  List<dynamic> questions = [];

  if (await rulesFile.exists()) rules = jsonDecode(await rulesFile.readAsString());
  if (await signsFile.exists()) signs = jsonDecode(await signsFile.readAsString());
  if (await questionsFile.exists()) questions = jsonDecode(await questionsFile.readAsString());

  // Check if it's a Source ID
  final dependentRules = rules.where((r) => r['sourceId'] == id).toList();
  final dependentSigns = signs.where((s) => s['sourceId'] == id).toList();
  
  if (dependentRules.isNotEmpty || dependentSigns.isNotEmpty) {
    print('Type: Source');
    print('Dependent Rules:');
    for (var r in dependentRules) {
      print('  - ${r['ruleId']}');
    }
    print('Dependent Signs:');
    for (var s in dependentSigns) {
      print('  - ${s['signResearchId']}');
    }
    print('');
  }

  // Check if it's a Rule ID / Sign ID (or show questions for the rules above)
  List<String> idsToCheck = [id];
  if (dependentRules.isNotEmpty) {
    idsToCheck.addAll(dependentRules.map((r) => r['ruleId'] as String));
  }
  if (dependentSigns.isNotEmpty) {
    idsToCheck.addAll(dependentSigns.map((s) => s['signResearchId'] as String));
  }

  for (var targetId in idsToCheck) {
    final dependentQuestions = questions.where((q) => q['ruleId'] == targetId).toList();
    if (dependentQuestions.isNotEmpty) {
      if (targetId == id) print('Type: Rule/Sign');
      print('Questions dependent on $targetId:');
      for (var q in dependentQuestions) {
        print('  - ${q['id']} [${q['verificationStatus']}]');
      }
    } else if (targetId == id) {
      print('No dependent questions found for Rule/Sign $id.');
    }
  }

  print('\n=== END OF REPORT ===');
}
