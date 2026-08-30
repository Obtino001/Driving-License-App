import 'dart:io';
import 'package:driving_license_app/core/content/question_validator.dart';

void main() async {
  final basePath = '${Directory.current.path}/assets/data/us/ca';
  final researchPath = '${Directory.current.path}/assets/data/us/research/ca';
  final validator = QuestionValidator(basePath: basePath, researchPath: researchPath);
  final report = await validator.validateAll();
  
  // ignore: avoid_print
  print(report);
}
