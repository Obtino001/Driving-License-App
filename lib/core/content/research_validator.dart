import 'dart:convert';
import 'dart:io';
import '../models/source.dart';
import '../models/driving_rule.dart';
import '../models/research_manifest.dart';

class ResearchValidator {
  final String basePath;

  ResearchValidator({required this.basePath});

  Future<String> validateAll() async {
    final buffer = StringBuffer();
    buffer.writeln('=== RESEARCH DATA VALIDATION REPORT ===\n');

    final manifestFile = File('$basePath/research_manifest.json');
    if (!await manifestFile.exists()) {
      buffer.writeln('ERROR: research_manifest.json not found.');
      return buffer.toString();
    }

    final manifestJson = jsonDecode(await manifestFile.readAsString()) as List;
    final manifests = manifestJson.map((e) => ResearchManifest.fromJson(e)).toList();

    int totalStates = manifests.length;
    int verifiedStates = manifests.where((m) => m.researchStatus == 'verified').length;
    
    buffer.writeln('States tracked: $totalStates');
    buffer.writeln('States verified: $verifiedStates\n');

    for (final manifest in manifests) {
      if (manifest.researchStatus == 'not_started') continue;

      buffer.writeln('--- STATE: ${manifest.stateName} (${manifest.stateCode}) ---');
      
      final stateDir = '$basePath/${manifest.stateId}';
      final sourcesFile = File('$stateDir/sources.json');
      final rulesFile = File('$stateDir/rules.json');

      List<Source> sources = [];
      if (await sourcesFile.exists()) {
        final sourcesJson = jsonDecode(await sourcesFile.readAsString()) as List;
        sources = sourcesJson.map((e) => Source.fromJson(e)).toList();
      }

      List<DrivingRule> rules = [];
      if (await rulesFile.exists()) {
        final rulesJson = jsonDecode(await rulesFile.readAsString()) as List;
        rules = rulesJson.map((e) => DrivingRule.fromJson(e)).toList();
      }

      // Validate Sources
      int verifiedSources = 0;
      int reviewSources = 0;
      final sourceIds = <String>{};

      for (final source in sources) {
        if (sourceIds.contains(source.sourceId)) {
          buffer.writeln('  [ERROR] Duplicate source ID: ${source.sourceId}');
        }
        sourceIds.add(source.sourceId);

        if (source.url == null && (source.sourceType == 'official_dmv_page' || source.sourceType == 'driver_handbook')) {
          buffer.writeln('  [WARNING] Source missing URL: ${source.sourceId}');
        }

        if (source.status == 'verified') {
          verifiedSources++;
        } else {
          reviewSources++;
        }
      }

      // Validate Rules
      int verifiedRules = 0;
      int reviewRules = 0;
      final ruleIds = <String>{};

      for (final rule in rules) {
        if (ruleIds.contains(rule.ruleId)) {
          buffer.writeln('  [ERROR] Duplicate rule ID: ${rule.ruleId}');
        }
        ruleIds.add(rule.ruleId);

        if (!sourceIds.contains(rule.sourceId)) {
          buffer.writeln('  [ERROR] Orphaned rule (invalid sourceId): ${rule.ruleId} -> ${rule.sourceId}');
        }

        if (rule.status == 'verified') {
          verifiedRules++;
        } else {
          reviewRules++;
        }
      }

      buffer.writeln('  Sources: ${sources.length} total ($verifiedSources verified, $reviewSources needs review)');
      buffer.writeln('  Rules: ${rules.length} total ($verifiedRules verified, $reviewRules needs review)\n');
    }

    buffer.writeln('=== END OF REPORT ===');
    return buffer.toString();
  }
}
