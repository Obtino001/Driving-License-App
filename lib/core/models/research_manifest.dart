library;

/// Tracks the research progress and state of official driving content for a given US state.
class ResearchManifest {
  const ResearchManifest({
    required this.stateId,
    required this.stateCode,
    required this.stateName,
    required this.licensingAuthority,
    required this.officialWebsite,
    required this.handbookFound,
    this.handbookURL,
    this.handbookVersion,
    required this.sampleTestFound,
    required this.roadSignSourceFound,
    required this.vehicleCodeSourceFound,
    this.lastResearchDate,
    required this.researchStatus,
  });

  final String stateId;
  final String stateCode;
  final String stateName;
  final String licensingAuthority;
  final String officialWebsite;
  final bool handbookFound;
  final String? handbookURL;
  final String? handbookVersion;
  final bool sampleTestFound;
  final bool roadSignSourceFound;
  final bool vehicleCodeSourceFound;
  final int? lastResearchDate;
  
  /// 'not_started', 'researching', 'sources_found', 'content_in_progress', 'verified', 'needs_update'
  final String researchStatus;

  factory ResearchManifest.fromJson(Map<String, dynamic> json) {
    return ResearchManifest(
      stateId: json['stateId'] as String,
      stateCode: json['stateCode'] as String,
      stateName: json['stateName'] as String,
      licensingAuthority: json['licensingAuthority'] as String,
      officialWebsite: json['officialWebsite'] as String,
      handbookFound: json['handbookFound'] as bool,
      handbookURL: json['handbookURL'] as String?,
      handbookVersion: json['handbookVersion'] as String?,
      sampleTestFound: json['sampleTestFound'] as bool,
      roadSignSourceFound: json['roadSignSourceFound'] as bool,
      vehicleCodeSourceFound: json['vehicleCodeSourceFound'] as bool,
      lastResearchDate: json['lastResearchDate'] as int?,
      researchStatus: json['researchStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stateId': stateId,
      'stateCode': stateCode,
      'stateName': stateName,
      'licensingAuthority': licensingAuthority,
      'officialWebsite': officialWebsite,
      'handbookFound': handbookFound,
      'handbookURL': handbookURL,
      'handbookVersion': handbookVersion,
      'sampleTestFound': sampleTestFound,
      'roadSignSourceFound': roadSignSourceFound,
      'vehicleCodeSourceFound': vehicleCodeSourceFound,
      'lastResearchDate': lastResearchDate,
      'researchStatus': researchStatus,
    };
  }
}
