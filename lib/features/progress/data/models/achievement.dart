library;

import 'package:flutter/material.dart';

@immutable
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconData,
    required this.isUnlocked,
    this.unlockedDate,
  });

  final String id;
  final String title;
  final String description;
  final IconData iconData;
  final bool isUnlocked;
  final DateTime? unlockedDate;
}
