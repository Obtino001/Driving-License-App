import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/editorial_header.dart';
import '../../../core/widgets/road_progress_track.dart';
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
            data: (state) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                const EditorialHeader(
                  title: 'PROGRESS',
                  subtitle: 'See what\'s getting stronger.',
                ),
                const SizedBox(height: 24),
                _TopStatsRow(
                  readiness: state.readiness,
                  todayQuestions: state.todayQuestions,
                  topicsExplored: state.topicsExplored,
                  totalTopics: state.totalTopics,
                ),
                const SizedBox(height: 32),
                _SectionHeader('CATEGORY BREAKDOWN'),
                ...state.categoryStats.entries.map((e) {
                  final cat = e.key;
                  final completed = e.value['completed'] ?? 0;
                  final total = e.value['total'] ?? 0;
                  final progress = total == 0 ? 0.0 : (completed / total);

                  return _CategoryProgressRow(
                    category: cat,
                    completed: completed,
                    total: total,
                    progress: progress,
                  );
                }),
                const SizedBox(height: 32),
                _SectionHeader('ACTIVITY'),
                _ActivityRow(
                  label: 'Mistakes to review',
                  value: '${state.mistakeCount}',
                  isHighlight: state.mistakeCount > 0,
                ),
                _ActivityRow(
                  label: 'Questions today',
                  value: '${state.todayQuestions}',
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }
}

class _TopStatsRow extends StatelessWidget {
  const _TopStatsRow({
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
          child: _StatCard(
            title: 'Readiness',
            value: '$readiness%',
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              _StatCard(
                title: 'Today',
                value: '$todayQuestions',
                isPrimary: false,
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'Topics',
                value: '$topicsExplored/$totalTopics',
                isPrimary: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.isPrimary,
  });

  final String title;
  final String value;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isPrimary ? 24 : 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textTertiary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
          SizedBox(height: isPrimary ? 8 : 4),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: isPrimary ? 48 : 24,
                  height: 1.1,
                  color: isPrimary ? AppColors.primaryAccent : AppColors.primaryDark,
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
      padding: const EdgeInsets.only(left: 4, bottom: 12),
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

class _CategoryProgressRow extends StatelessWidget {
  const _CategoryProgressRow({
    required this.category,
    required this.completed,
    required this.total,
    required this.progress,
  });

  final String category;
  final int completed;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textTertiary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '$completed / $total',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RoadProgressTrack(progress: progress),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  final String label;
  final String value;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textTertiary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isHighlight ? AppColors.warning : AppColors.textSecondary,
                  fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
