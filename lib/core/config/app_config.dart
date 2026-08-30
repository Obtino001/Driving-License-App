library;

/// Central configuration for multi-region support (Flavors).
///
/// Uses Dart defines injected at build time via `--dart-define=REGION=...`
class AppConfig {
  static const String regionCode = String.fromEnvironment('REGION', defaultValue: 'us_generic');

  /// The name of the agency for the current region (e.g., DMV, DVLA).
  static String get agencyName {
    switch (regionCode) {
      case 'uk':
        return 'DVLA';
      case 'ca_on':
        return 'MTO';
      case 'au_nsw':
        return 'Transport for NSW';
      case 'us_generic':
      default:
        return 'DMV';
    }
  }

  /// The name of the app to display.
  static String get appName {
    switch (regionCode) {
      case 'uk':
        return 'DriveWise: UK Theory Test';
      case 'us_generic':
      default:
        return 'DriveWise: DMV Practice Test';
    }
  }

  /// The path to the local data assets for seeding the database.
  static String get dataAssetPath {
    return 'assets/data/$regionCode';
  }
}
