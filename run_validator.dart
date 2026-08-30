import 'dart:io';
import 'package:driving_license_app/core/content/research_validator.dart';

void main() async {
  final basePath = '${Directory.current.path}/assets/data/us/research';
  final validator = ResearchValidator(basePath: basePath);
  final report = await validator.validateAll();
  print(report);
}
