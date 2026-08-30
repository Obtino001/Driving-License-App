import 'dart:convert';
import 'dart:io';
import '../lib/features/practice/data/mock_questions.dart';
import '../lib/features/road_signs/data/mock_road_signs.dart';

void main() {
  final outDir = Directory('assets/data/us_generic');
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  // Dump questions
  final questionsList = mockQuestions.map((q) => {
    'id': q.id,
    'category': q.category,
    'text': q.text,
    'options': q.options,
    'correctIndex': q.correctIndex,
    'explanation': q.explanation,
  }).toList();
  
  File('${outDir.path}/questions.json')
      .writeAsStringSync(jsonEncode(questionsList));
  print('Wrote questions.json');

  // Dump road signs
  final roadSignsList = mockRoadSigns.map((s) => {
    'id': s.id,
    'name': s.name,
    'category': s.category,
    'meaning': s.meaning,
    'actionRequired': s.actionRequired,
    'exampleSituation': s.exampleSituation,
    'iconDataCode': s.iconData.codePoint,
    'colorHex': s.color.toARGB32(),
    'shapeIndex': s.shape.index,
  }).toList();

  File('${outDir.path}/road_signs.json')
      .writeAsStringSync(jsonEncode(roadSignsList));
  print('Wrote road_signs.json');
}
