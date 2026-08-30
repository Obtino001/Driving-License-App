import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:driving_license_app/core/models/research_manifest.dart';

void main() {
  group('ResearchManifest Tests', () {
    test('Should parse ResearchManifest from JSON correctly', () {
      const jsonStr = '''
      {
        "stateId": "ca",
        "stateCode": "CA",
        "stateName": "California",
        "licensingAuthority": "California Department of Motor Vehicles",
        "officialWebsite": "https://www.dmv.ca.gov/",
        "handbookFound": true,
        "handbookURL": "https://www.dmv.ca.gov/portal/handbook/california-driver-handbook/",
        "handbookVersion": "2024",
        "sampleTestFound": true,
        "roadSignSourceFound": true,
        "vehicleCodeSourceFound": true,
        "lastResearchDate": 1725015000,
        "researchStatus": "sources_found"
      }
      ''';

      final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      final manifest = ResearchManifest.fromJson(jsonMap);

      expect(manifest.stateId, 'ca');
      expect(manifest.stateName, 'California');
      expect(manifest.handbookFound, true);
      expect(manifest.handbookURL, 'https://www.dmv.ca.gov/portal/handbook/california-driver-handbook/');
      expect(manifest.researchStatus, 'sources_found');
    });

    test('Should parse ResearchManifest with null values correctly', () {
      const jsonStr = '''
      {
        "stateId": "tx",
        "stateCode": "TX",
        "stateName": "Texas",
        "licensingAuthority": "Texas Department of Public Safety",
        "officialWebsite": "https://www.dps.texas.gov/",
        "handbookFound": false,
        "handbookURL": null,
        "handbookVersion": null,
        "sampleTestFound": false,
        "roadSignSourceFound": false,
        "vehicleCodeSourceFound": false,
        "lastResearchDate": null,
        "researchStatus": "not_started"
      }
      ''';

      final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      final manifest = ResearchManifest.fromJson(jsonMap);

      expect(manifest.stateId, 'tx');
      expect(manifest.handbookFound, false);
      expect(manifest.handbookURL, isNull);
      expect(manifest.lastResearchDate, isNull);
      expect(manifest.researchStatus, 'not_started');
    });
  });
}
