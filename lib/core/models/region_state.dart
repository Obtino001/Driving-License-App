library;

/// Represents a geographical state or region for content configuration.
class RegionState {
  const RegionState({
    required this.stateId,
    required this.stateCode,
    required this.stateName,
    required this.abbreviation,
    this.licensingAuthority,
    this.officialWebsite,
    this.handbookSource,
    this.contentVersion,
    this.lastVerified,
    required this.status,
  });

  /// Unique identifier, e.g., 'us_ca'
  final String stateId;

  /// ISO-like state code, e.g., 'US-CA'
  final String stateCode;

  /// Full name of the state, e.g., 'California'
  final String stateName;

  /// State abbreviation, e.g., 'CA'
  final String abbreviation;

  /// E.g., 'DMV', 'DPS'
  final String? licensingAuthority;

  /// Official state website URL
  final String? officialWebsite;

  /// URL or name of the official handbook
  final String? handbookSource;

  /// Version of the content pack, e.g., '2026.1'
  final String? contentVersion;

  /// Unix timestamp of when the content was last verified
  final int? lastVerified;

  /// 'AVAILABLE' or 'COMING_SOON'
  final String status;

  factory RegionState.fromJson(Map<String, dynamic> json) {
    return RegionState(
      stateId: json['stateId'] as String,
      stateCode: json['stateCode'] as String,
      stateName: json['stateName'] as String,
      abbreviation: json['abbreviation'] as String,
      licensingAuthority: json['licensingAuthority'] as String?,
      officialWebsite: json['officialWebsite'] as String?,
      handbookSource: json['handbookSource'] as String?,
      contentVersion: json['contentVersion'] as String?,
      lastVerified: json['lastVerified'] as int?,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'state_id': stateId,
      'state_code': stateCode,
      'state_name': stateName,
      'abbreviation': abbreviation,
      'licensing_authority': licensingAuthority,
      'official_website': officialWebsite,
      'handbook_source': handbookSource,
      'content_version': contentVersion,
      'last_verified': lastVerified,
      'status': status,
    };
  }

  factory RegionState.fromMap(Map<String, dynamic> map) {
    return RegionState(
      stateId: map['state_id'] as String,
      stateCode: map['state_code'] as String,
      stateName: map['state_name'] as String,
      abbreviation: map['abbreviation'] as String,
      licensingAuthority: map['licensing_authority'] as String?,
      officialWebsite: map['official_website'] as String?,
      handbookSource: map['handbook_source'] as String?,
      contentVersion: map['content_version'] as String?,
      lastVerified: map['last_verified'] as int?,
      status: map['status'] as String,
    );
  }
}
