library;

/// Represents an authoritative raw driving rule extracted from an official source.
/// This acts as the raw material for generating production content.
class DrivingRule {
  const DrivingRule({
    required this.ruleId,
    required this.stateId,
    required this.topic,
    required this.subtopic,
    required this.ruleSummary,
    required this.sourceId,
    this.section,
    this.page,
    required this.sourceVersion,
    required this.lastVerified,
    required this.status,
  });

  /// Unique identifier for this rule, e.g., 'ca_rule_speed_limit_school'
  final String ruleId;

  /// The region this rule applies to, e.g., 'ca'
  final String stateId;

  /// The high-level topic, e.g., 'Speed Limits'
  final String topic;

  /// The specific subtopic, e.g., 'School Zones'
  final String subtopic;

  /// The raw factual summary of the rule
  final String ruleSummary;

  /// The ID of the official Source this rule is derived from
  final String sourceId;

  /// The specific section/chapter in the source, if applicable
  final String? section;

  /// The specific page number in the source, if applicable
  final int? page;

  /// The edition/version of the source when this rule was extracted
  final String sourceVersion;

  /// Unix timestamp of when this rule was last fact-checked
  final int lastVerified;

  /// e.g., 'verified', 'needs_review', 'outdated'
  final String status;

  factory DrivingRule.fromJson(Map<String, dynamic> json) {
    return DrivingRule(
      ruleId: json['ruleId'] as String,
      stateId: json['stateId'] as String,
      topic: json['topic'] as String,
      subtopic: json['subtopic'] as String,
      ruleSummary: json['ruleSummary'] as String,
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
      'ruleId': ruleId,
      'stateId': stateId,
      'topic': topic,
      'subtopic': subtopic,
      'ruleSummary': ruleSummary,
      'sourceId': sourceId,
      'section': section,
      'page': page,
      'sourceVersion': sourceVersion,
      'lastVerified': lastVerified,
      'status': status,
    };
  }
}
