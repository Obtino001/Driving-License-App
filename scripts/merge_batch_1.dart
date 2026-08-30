import 'dart:convert';
import 'dart:io';

void main() async {
  final questionsFile = File('assets/data/us/ca/questions.json');
  final List questions = jsonDecode(await questionsFile.readAsString());

  final basePath = r'C:\Users\Yasir\.gemini\antigravity-ide\brain\5bbbac36-1744-4347-a915-e0f215c8164a\scratch';
  
  for (int i = 1; i <= 4; i++) {
    final partFile = File('$basePath\\batch_1_part_$i.json');
    if (await partFile.exists()) {
      final List partQuestions = jsonDecode(await partFile.readAsString());
      questions.addAll(partQuestions);
      print('Added \${partQuestions.length} questions from part $i.');
    }
  }

  await questionsFile.writeAsString(JsonEncoder.withIndent('  ').convert(questions));
  print('Successfully wrote \${questions.length} total questions to questions.json.');
}
