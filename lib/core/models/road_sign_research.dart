library;

/// Represents an authoritative raw road sign extracted from an official source.
class RoadSignResearch {
  const RoadSignResearch({
    required this.signResearchId,
    required this.stateId,
    required this.officialName,
    required this.meaning,
    required this.driverAction,
    required this.category,
    required this.shape,
    required this.color,
    this.symbol,
    required this.sourceId,
    this.section,
    this.page,
    required this.sourceVersion,
    required this.lastVerified,
    required this.status,
  });

  /// Unique identifier for this sign, e.g., 'ca_sign_stop'
  final String signResearchId;

  final String stateId;

  /// E.g., 'Stop Sign'
  final String officialName;

  /// The official meaning of the sign
  final String meaning;

  /// What the driver must do when seeing this sign
  final String driverAction;

  /// E.g., 'Regulatory', 'Warning', 'Guide', 'Construction'
  final String category;

  /// E.g., 'Octagon', 'Diamond', 'Triangle'
  final String shape;

  /// E.g., 'Red with White Letters', 'Yellow with Black Symbols'
  final String color;

  /// Description of the symbol on the sign, if applicable
  final String? symbol;

  final String sourceId;
  final String? section;
  final int? page;
  final String sourceVersion;
  final int lastVerified;
  final String status;

  factory RoadSignResearch.fromJson(Map<String, dynamic> json) {
    return RoadSignResearch(
      signResearchId: json['signResearchId'] as String,
      stateId: json['stateId'] as String,
      officialName: json['officialName'] as String,
      meaning: json['meaning'] as String,
      driverAction: json['driverAction'] as String,
      category: json['category'] as String,
      shape: json['shape'] as String,
      color: json['color'] as String,
      symbol: json['symbol'] as String?,
      sourceId: json['sourceId'] as String,
      section: json['section'] as String?,
      page: json['page'] as int?,
      sourceVersion: json['sourceVersion'] as String,
      lastVerified: json['lastVerified'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signResearchId': signResearchId,
      'stateId': stateId,
      'officialName': officialName,
      'meaning': meaning,
      'driverAction': driverAction,
      'category': category,
      'shape': shape,
      'color': color,
      'symbol': symbol,
      'sourceId': sourceId,
      'section': section,
      'page': page,
      'sourceVersion': sourceVersion,
      'lastVerified': lastVerified,
      'status': status,
    };
  }
}
