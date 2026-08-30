library;

/// Represents the authoritative source of a driving rule, question, or sign.
class Source {
  const Source({
    required this.sourceId,
    required this.stateId,
    required this.organization,
    required this.title,
    this.url,
    this.documentVersion,
    this.publicationDate,
    this.lastUpdated,
    required this.sourceType,
    this.lastVerified,
    required this.status,
  });

  /// Unique identifier, e.g., 'ca_dmv_handbook_2026'
  final String sourceId;

  /// ID of the state this source belongs to
  final String stateId;

  /// E.g., 'California DMV'
  final String organization;

  /// E.g., 'California Driver Handbook'
  final String title;

  /// URL to the official source if available
  final String? url;

  /// E.g., '2026 Edition'
  final String? documentVersion;

  /// Unix timestamp
  final int? publicationDate;

  /// Unix timestamp
  final int? lastUpdated;

  /// E.g., 'driver_handbook', 'vehicle_code', 'official_dmv_page'
  final String sourceType;

  /// Unix timestamp of when the content was last verified
  final int? lastVerified;

  /// 'verified', 'needs_review', 'outdated', 'rejected'
  final String status;

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      sourceId: json['sourceId'] as String,
      stateId: json['stateId'] as String,
      organization: json['organization'] as String,
      title: json['title'] as String,
      url: json['url'] as String?,
      documentVersion: json['documentVersion'] as String?,
      publicationDate: json['publicationDate'] as int?,
      lastUpdated: json['lastUpdated'] as int?,
      sourceType: json['sourceType'] as String,
      lastVerified: json['lastVerified'] as int?,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source_id': sourceId,
      'state_id': stateId,
      'organization': organization,
      'title': title,
      'url': url,
      'document_version': documentVersion,
      'publication_date': publicationDate,
      'last_updated': lastUpdated,
      'source_type': sourceType,
      'last_verified': lastVerified,
      'status': status,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      sourceId: map['source_id'] as String,
      stateId: map['state_id'] as String,
      organization: map['organization'] as String,
      title: map['title'] as String,
      url: map['url'] as String?,
      documentVersion: map['document_version'] as String?,
      publicationDate: map['publication_date'] as int?,
      lastUpdated: map['last_updated'] as int?,
      sourceType: map['source_type'] as String,
      lastVerified: map['last_verified'] as int?,
      status: map['status'] as String,
    );
  }
}
