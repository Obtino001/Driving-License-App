/// Progress screen placeholder.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/circular_progress_indicator.dart';

/// The Progress tab showing overall stats and category breakdown.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress',
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Track your learning journey',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Overall progress ring
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: AppRadius.borderRadiusLg,
                  ),
                  child: Column(
                    children: [
                      AppCircularProgress(
                        progress: 0.35,
                        size: 120,
                        strokeWidth: 10,
                        activeColor: colors.success,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Overall Progress',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '72 of 203 questions completed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Stats grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: 'Study Time',
                        value: '4h 23m',
                        icon: Icons.schedule_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.ms),
                    Expanded(
                      child: _StatBox(
                        label: 'Accuracy',
                        value: '78%',
                        icon: Icons.gps_fixed_rounded,
                        color: colors.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.ms),
                    Expanded(
                      child: _StatBox(
                        label: 'Mock Tests',
                        value: '3',
                        icon: Icons.assignment_rounded,
                        color: colors.info,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Weak areas section
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Areas to Improve',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.ms),
                    _WeakAreaTile(
                      name: 'Right of Way',
                      accuracy: 45,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _WeakAreaTile(
                      name: 'Safety & Emergencies',
                      accuracy: 58,
                      color: colors.warning,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _WeakAreaTile(
                      name: 'Traffic Rules',
                      accuracy: 65,
                      color: colors.warning,
                    ),
                  ],
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WeakAreaTile extends StatelessWidget {
  const _WeakAreaTile({
    required this.name,
    required this.accuracy,
    required this.color,
  });

  final String name;
  final int accuracy;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: AppRadius.borderRadiusFull,
                  child: LinearProgressIndicator(
                    value: accuracy / 100,
                    minHeight: 6,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '$accuracy%',
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
