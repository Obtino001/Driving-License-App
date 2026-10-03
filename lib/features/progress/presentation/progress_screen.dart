import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/editorial_header.dart';
import '../../../core/widgets/road_progress_track.dart';
import '../../../core/utils/haptics.dart';
import '../application/progress_controller.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(progressProvider.future),
          color: AppColors.primaryDark,
          child: progressAsync.when(
            data: (state) {
              if (state.topicsExplored == 0) {
                return _buildEmptyState(context);
              }
              return _buildDataState(context, state);
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryDark),
            ),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        const EditorialHeader(
          title: 'PROGRESS',
          subtitle: 'See what\'s getting stronger.',
        ),
        const SizedBox(height: 64),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textTertiary.withValues(alpha: 0.1),
                  ),
                ),
                child: Icon(
                  PhosphorIcons.roadHorizon(PhosphorIconsStyle.light),
                  size: 40,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No progress yet',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Start a short practice run to unlock your readiness, topic breakdown, and personalized recommendations.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Start practice',
                onPressed: () {
                  AppHaptics.selection();
                  context.push('/practice');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataState(BuildContext context, ProgressState state) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        const EditorialHeader(
          title: 'PROGRESS',
          subtitle: 'See what\'s getting stronger.',
        ),
        const SizedBox(height: 24),
        _ProgressSummaryHero(
          readiness: state.readiness,
          todayQuestions: state.todayQuestions,
          topicsExplored: state.topicsExplored,
          totalTopics: state.totalTopics,
        ),
        const SizedBox(height: 32),
        if (state.weakestTopic != null) ...[
          _ProgressInsightCard(
            title: 'Needs attention',
            topic: state.weakestTopic!,
            metric:
                '${(state.categoryAccuracy[state.weakestTopic!]! * 100).round()}% accuracy',
            ctaText: 'Practice weak area',
            isWarning: true,
            onTap: () {
              AppHaptics.selection();
              context.push('/quiz', extra: state.weakestTopic);
            },
          ),
          const SizedBox(height: 32),
        ] else if (state.strongestTopic != null) ...[
          _ProgressInsightCard(
            title: 'Strongest topic',
            topic: state.strongestTopic!,
            metric:
                '${(state.categoryAccuracy[state.strongestTopic!]! * 100).round()}% accuracy',
            ctaText: 'Keep it up',
            isWarning: false,
            onTap: () {
              AppHaptics.selection();
              context.push('/quiz', extra: state.strongestTopic);
            },
          ),
          const SizedBox(height: 32),
        ],

        _SectionHeader('CATEGORY BREAKDOWN'),
        ...state.categoryStats.entries.map((e) {
          final cat = e.key;
          final completed = e.value['completed'] ?? 0;
          final total = e.value['total'] ?? 0;
          final progress = total == 0 ? 0.0 : (completed / total);
          final acc = state.categoryAccuracy[cat] ?? 0.0;

          return _CategoryProgressCard(
            category: cat,
            completed: completed,
            total: total,
            progress: progress,
            accuracy: acc,
            onStart: () {
              AppHaptics.selection();
              context.push('/quiz', extra: cat);
            },
          );
        }),
        const SizedBox(height: 32),

        _SectionHeader('MOCK EXAMS'),
        if (state.mockExamsCount > 0) ...[
          _ActivityRow(
            label: 'Mock exams completed',
            value: '\${state.mockExamsCount}',
          ),
          if (state.latestMockScore != null)
            _ActivityRow(
              label: 'Latest mock score',
              value: '\${state.latestMockScore}%',
            ),
          if (state.bestMockScore != null)
            _ActivityRow(
              label: 'Best mock score',
              value: '\${state.bestMockScore}%',
            ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.textTertiary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.graduationCap(),
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Take your first mock exam to unlock exam trends.',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 32),
        _NextStepCard(
          topic: state.weakestTopic ?? state.strongestTopic ?? 'Road Rules',
        ),
      ],
    );
  }
}

class _ProgressSummaryHero extends StatelessWidget {
  const _ProgressSummaryHero({
    required this.readiness,
    required this.todayQuestions,
    required this.topicsExplored,
    required this.totalTopics,
  });

  final int readiness;
  final int todayQuestions;
  final int topicsExplored;
  final int totalTopics;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Readiness',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.surface.withValues(alpha: 0.7),
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$readiness%',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.primaryAccent,
                    height: 1.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Based on practice accuracy and topic coverage',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.surface.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _MiniStatCard(
                label: 'Today',
                value: '$todayQuestions',
                unit: 'qs',
              ),
              const SizedBox(height: 12),
              _MiniStatCard(
                label: 'Topics',
                value: '$topicsExplored',
                unit: '/$totalTopics',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressInsightCard extends StatelessWidget {
  const _ProgressInsightCard({
    required this.title,
    required this.topic,
    required this.metric,
    required this.ctaText,
    required this.isWarning,
    required this.onTap,
  });

  final String title;
  final String topic;
  final String metric;
  final String ctaText;
  final bool isWarning;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isWarning
              ? AppColors.warning.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isWarning
                ? AppColors.warning.withValues(alpha: 0.3)
                : AppColors.textTertiary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isWarning
                    ? AppColors.warning.withValues(alpha: 0.2)
                    : AppColors.primaryDark.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isWarning ? PhosphorIcons.trendDown() : PhosphorIcons.trendUp(),
                color: isWarning ? AppColors.warning : AppColors.primaryDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isWarning
                          ? AppColors.warning
                          : AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    metric,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIcons.caretRight(),
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryProgressCard extends StatelessWidget {
  const _CategoryProgressCard({
    required this.category,
    required this.completed,
    required this.total,
    required this.progress,
    required this.accuracy,
    required this.onStart,
  });

  final String category;
  final int completed;
  final int total;
  final double progress;
  final double accuracy;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = completed == 0;

    String status = 'Not explored yet';
    if (!isEmpty) {
      if (accuracy >= 0.8) {
        status = 'Strong';
      } else if (accuracy >= 0.5) {
        status = 'Improving';
      } else {
        status = 'Getting started';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isEmpty
                            ? AppColors.textTertiary
                            : AppColors.primaryDark,
                        fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isEmpty)
                TextButton(
                  onPressed: onStart,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor: AppColors.primaryDark.withValues(
                      alpha: 0.05,
                    ),
                  ),
                  child: Text(
                    'Start',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\${(accuracy * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completed / $total qs',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
            ],
          ),
          if (!isEmpty) ...[
            const SizedBox(height: 16),
            RoadProgressTrack(progress: progress),
          ],
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textTertiary,
          letterSpacing: 1.2,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NextStepCard extends StatelessWidget {
  const _NextStepCard({required this.topic});

  final String topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next step',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.primaryAccent,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Practice $topic to improve your readiness.',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: AppColors.surface, height: 1.3),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Continue practicing',
              onPressed: () {
                AppHaptics.selection();
                context.push('/quiz', extra: topic);
              },
            ),
          ),
        ],
      ),
    );
  }
}
