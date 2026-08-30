library;

import 'package:flutter/material.dart';

/// Represents a single road sign in the learning section.
/// 
/// Data is separated from UI. In a real app, this could be hydrated
/// from a local database or API. Since we lack image assets, we use
/// [iconData], [shape], and [color] to procedurally generate a placeholder.
class RoadSign {
  const RoadSign({
    required this.id,
    required this.name,
    required this.category,
    required this.meaning,
    required this.actionRequired,
    required this.exampleSituation,
    required this.iconData,
    required this.color,
    this.shape = RoadSignShape.rectangle,
    this.foregroundColor = Colors.white,
    this.stateId,
    this.sourceId,
    this.sourceSection,
    this.sourcePage,
    this.version,
    this.lastVerified,
  });

  final String id;
  final String name;
  final String category;
  
  /// Short description of what the sign means.
  final String meaning;
  
  /// What the driver must do when seeing this sign.
  final String actionRequired;

  /// Example of where/when you might see this sign.
  final String exampleSituation;

  // We are storing UI-specific presentation details directly on the model 
  // since we don't have image assets for signs yet.
  final IconData iconData;
  final Color color;
  final Color foregroundColor;
  final RoadSignShape shape;

  /// ID of the state this sign belongs to.
  final String? stateId;

  /// ID of the source for this sign.
  final String? sourceId;

  /// Section within the source.
  final String? sourceSection;

  /// Page number/identifier within the source.
  final String? sourcePage;

  /// Version of the source/content.
  final String? version;

  /// Unix timestamp of when the content was last verified.
  final int? lastVerified;

  factory RoadSign.fromJson(Map<String, dynamic> json) {
    return RoadSign(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      meaning: json['meaning'] as String,
      actionRequired: json['actionRequired'] as String,
      exampleSituation: json['exampleSituation'] as String,
      iconData: IconData(
        json['iconDataCode'] as int, 
        fontFamily: 'MaterialIcons'
      ),
      color: Color(json['colorHex'] as int),
      shape: RoadSignShape.values[json['shapeIndex'] as int],
      stateId: json['stateId'] as String?,
      sourceId: json['sourceId'] as String?,
      sourceSection: json['sourceSection'] as String?,
      sourcePage: json['sourcePage'] as String?,
      version: json['version'] as String?,
      lastVerified: json['lastVerified'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'meaning': meaning,
      'actionRequired': actionRequired,
      'exampleSituation': exampleSituation,
      'iconDataCode': iconData.codePoint,
      'colorHex': color.toARGB32(),
      'shapeIndex': shape.index,
      'stateId': stateId,
      'sourceId': sourceId,
      'sourceSection': sourceSection,
      'sourcePage': sourcePage,
      'version': version,
      'lastVerified': lastVerified,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'meaning': meaning,
      'action_required': actionRequired,
      'example_situation': exampleSituation,
      'icon_data_code': iconData.codePoint,
      'color_hex': color.toARGB32(),
      'shape_index': shape.index,
      'state_id': stateId,
      'source_id': sourceId,
      'source_section': sourceSection,
      'source_page': sourcePage,
      'version': version,
      'last_verified': lastVerified,
    };
  }

  factory RoadSign.fromMap(Map<String, dynamic> map) {
    return RoadSign(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      meaning: map['meaning'] as String,
      actionRequired: map['action_required'] as String,
      exampleSituation: map['example_situation'] as String,
      iconData: IconData(
        map['icon_data_code'] as int,
        fontFamily: 'MaterialIcons',
      ),
      color: Color(map['color_hex'] as int),
      shape: RoadSignShape.values[map['shape_index'] as int],
      stateId: map['state_id'] as String?,
      sourceId: map['source_id'] as String?,
      sourceSection: map['source_section'] as String?,
      sourcePage: map['source_page'] as String?,
      version: map['version'] as String?,
      lastVerified: map['last_verified'] as int?,
    );
  }
}

/// The geometric shape of the sign for the procedural placeholder.
enum RoadSignShape {
  octagon,
  triangle, // point up or down depending on type (Yield is down, Warning is usually diamond, but we'll use diamond)
  diamond,
  rectangle, // vertical or horizontal
  circle,
  pentagon, // School zone
  crossbuck, // Railroad
}
