library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/achievement.dart';

class AchievementsStrip extends StatelessWidget {
  const AchievementsStrip({super.key, required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Achievements',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              return _AchievementBadge(achievement: achievements[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color badgeColor = achievement.isUnlocked
        ? const Color(0xFFFFC107) // Gold/Amber
        : theme.colorScheme.surfaceContainerHighest;

    final Color iconColor = achievement.isUnlocked
        ? Colors.black87
        : theme.colorScheme.onSurfaceVariant;

    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: achievement.isUnlocked
                    ? const Color(0xFFFFB300)
                    : theme.colorScheme.outlineVariant,
                width: 2,
              ),
              boxShadow: achievement.isUnlocked
                  ? [
                      BoxShadow(
                        color: badgeColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: Icon(achievement.iconData, color: iconColor, size: 32),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            achievement.title,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: achievement.isUnlocked
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
