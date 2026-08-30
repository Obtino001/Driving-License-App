import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:driving_license_app/core/content/research_validator.dart';

void main() {
  group('ResearchValidator Tests', () {
    late Directory tempDir;
    late ResearchValidator validator;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('research_test');
      validator = ResearchValidator(basePath: tempDir.path);
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('Should return error if manifest is missing', () async {
      final report = await validator.validateAll();
      expect(report, contains('ERROR: research_manifest.json not found'));
    });

    test('Should validate clean data without errors', () async {
      // 1. Create manifest
      final manifestFile = File('${tempDir.path}/research_manifest.json');
      await manifestFile.writeAsString(jsonEncode([
        {
          "stateId": "ca",
          "stateCode": "CA",
          "stateName": "California",
          "licensingAuthority": "DMV",
          "officialWebsite": "https://dmv.ca.gov",
          "handbookFound": true,
          "sampleTestFound": false,
          "roadSignSourceFound": false,
          "vehicleCodeSourceFound": false,
          "researchStatus": "sources_found"
        }
      ]));

      // 2. Create state dir and sources
      final stateDir = Directory('${tempDir.path}/ca');
      await stateDir.create();

      final sourcesFile = File('${stateDir.path}/sources.json');
      await sourcesFile.writeAsString(jsonEncode([
        {
          "sourceId": "ca_handbook",
          "stateId": "ca",
          "organization": "DMV",
          "title": "Handbook",
          "url": "https://dmv.ca.gov/handbook",
          "sourceType": "driver_handbook",
          "status": "verified"
        }
      ]));

      // 3. Create rules
      final rulesFile = File('${stateDir.path}/rules.json');
      await rulesFile.writeAsString(jsonEncode([
        {
          "ruleId": "rule_1",
          "stateId": "ca",
          "topic": "Speed",
          "subtopic": "Limits",
          "ruleSummary": "Speed is 25.",
          "sourceId": "ca_handbook",
          "sourceVersion": "2024",
          "lastVerified": 1000,
          "status": "verified"
        }
      ]));

      final report = await validator.validateAll();
      expect(report, isNot(contains('ERROR')));
      expect(report, contains('States tracked: 1'));
      expect(report, contains('Sources: 1 total'));
      expect(report, contains('Rules: 1 total'));
    });

    test('Should detect duplicate rules and missing sources', () async {
      // 1. Create manifest
      final manifestFile = File('${tempDir.path}/research_manifest.json');
      await manifestFile.writeAsString(jsonEncode([
        {
          "stateId": "ca",
          "stateCode": "CA",
          "stateName": "California",
          "licensingAuthority": "DMV",
          "officialWebsite": "https://dmv.ca.gov",
          "handbookFound": true,
          "sampleTestFound": false,
          "roadSignSourceFound": false,
          "vehicleCodeSourceFound": false,
          "researchStatus": "sources_found"
        }
      ]));

      // 2. Create state dir and sources
      final stateDir = Directory('${tempDir.path}/ca');
      await stateDir.create();

      final sourcesFile = File('${stateDir.path}/sources.json');
      await sourcesFile.writeAsString(jsonEncode([
        {
          "sourceId": "ca_handbook",
          "stateId": "ca",
          "organization": "DMV",
          "title": "Handbook",
          "sourceType": "driver_handbook", // Missing URL
          "status": "verified"
        }
      ]));

      // 3. Create rules
      final rulesFile = File('${stateDir.path}/rules.json');
      await rulesFile.writeAsString(jsonEncode([
        {
          "ruleId": "rule_1",
          "stateId": "ca",
          "topic": "Speed",
          "subtopic": "Limits",
          "ruleSummary": "Speed is 25.",
          "sourceId": "non_existent_source",
          "sourceVersion": "2024",
          "lastVerified": 1000,
          "status": "verified"
        },
        {
          "ruleId": "rule_1", // Duplicate ID
          "stateId": "ca",
          "topic": "Speed",
          "subtopic": "Limits",
          "ruleSummary": "Speed is 30.",
          "sourceId": "ca_handbook",
          "sourceVersion": "2024",
          "lastVerified": 1000,
          "status": "verified"
        }
      ]));

      final report = await validator.validateAll();
      expect(report, contains('[WARNING] Source missing URL: ca_handbook'));
      expect(report, contains('[ERROR] Orphaned rule (invalid sourceId): rule_1 -> non_existent_source'));
      expect(report, contains('[ERROR] Duplicate rule ID: rule_1'));
    });
  });
}
