library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../premium/presentation/premium_upgrade_screen.dart';
import '../providers/mistakes_provider.dart';
import 'quiz_session_screen.dart';

class MistakesDashboardScreen extends ConsumerWidget {
  const MistakesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mistakesAsync = ref.watch(mistakesProvider);
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Mistakes'),
        centerTitle: true,
      ),
      body: !isPremium 
          ? _buildLockedState(context)
          : mistakesAsync.when(
              data: (state) {
                if (state.totalMistakes == 0) {
                  return _buildEmptyState(context);
                }
                return _buildDashboard(context, state);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
    );
  }

  Widget _buildLockedState(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.warning.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_rounded, size: 64, color: colors.warning),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Premium Feature',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'The Smart Mistake Trainer automatically tracks your weaknesses and builds custom practice sessions. Upgrade to Premium to unlock.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PremiumUpgradeScreen()),
                );
              },
              icon: const Icon(Icons.workspace_premium_rounded),
              label: const Text('Unlock Premium', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded, size: 80, color: colors.success),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'All caught up!',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You have no mistakes to review. Keep practicing to build your mastery.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, MistakesState state) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Stat Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: colors.warning.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderRadiusXl,
              border: Border.all(color: colors.warning.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  '${state.totalMistakes}',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.warning,
                  ),
                ),
                Text(
                  'Questions to improve',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizSessionScreen(
                            title: 'Mistakes Practice',
                            questions: state.questions,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.psychology_alt_rounded),
                    label: const Text(
                      'Practice Mistakes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.warning,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderRadiusMd,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Mastery Breakdown
          Text(
            'Mastery Breakdown',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          _MasteryRow(
            label: 'Learning (Got it wrong)',
            count: state.learningCount,
            icon: Icons.error_outline_rounded,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: AppSpacing.sm),
          _MasteryRow(
            label: 'Improving (Got it right once)',
            count: state.improvingCount,
            icon: Icons.trending_up_rounded,
            color: colors.warning,
          ),
          const SizedBox(height: AppSpacing.sm),
          _MasteryRow(
            label: 'Mastered (Done!)',
            count: state.masteredCount,
            icon: Icons.workspace_premium_rounded,
            color: colors.success,
          ),
          const SizedBox(height: AppSpacing.xl),
          
          Text(
            'How this works:',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Questions you answer incorrectly are added to this list. Answer them correctly twice in a row to achieve Mastery and remove them from your mistakes pool.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _MasteryRow extends StatelessWidget {
  const _MasteryRow({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '$count',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
