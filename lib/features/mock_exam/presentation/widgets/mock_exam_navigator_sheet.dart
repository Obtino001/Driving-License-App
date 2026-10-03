import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../application/mock_exam_controller.dart';

class MockExamNavigatorSheet extends ConsumerWidget {
  const MockExamNavigatorSheet({
    super.key,
    required this.onSelectIndex,
  });

  final ValueChanged<int> onSelectIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mockExamProvider);
    if (state.questions == null || state.sessionQuestions == null) {
      return const SizedBox.shrink();
    }

    final total = state.questions!.length;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Exam Overview',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LegendItem(icon: PhosphorIcons.check(PhosphorIconsStyle.bold), label: 'Answered'),
              _LegendItem(icon: PhosphorIcons.circle(), label: 'Unanswered'),
              _LegendItem(icon: PhosphorIcons.flag(PhosphorIconsStyle.fill), color: AppColors.warning, label: 'Flagged'),
            ],
          ),
          const SizedBox(height: 32),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(total, (index) {
                  final isCurrent = index == state.currentIndex;
                  final sq = state.sessionQuestions![index];
                  final isAnswered = sq.selectedAnswerIndex != null;
                  final isFlagged = sq.isFlagged;

                  return GestureDetector(
                    onTap: () => onSelectIndex(index),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.primaryDark
                            : isAnswered
                                ? AppColors.primaryAccent.withValues(alpha: 0.15)
                                : AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primaryDark
                              : isFlagged
                                  ? AppColors.warning
                                  : AppColors.textTertiary.withValues(alpha: 0.2),
                          width: isCurrent || isFlagged ? 2 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: isCurrent
                                        ? AppColors.primaryAccent
                                        : AppColors.textPrimary,
                                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                  ),
                            ),
                          ),
                          if (isFlagged)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  PhosphorIcons.flag(PhosphorIconsStyle.fill),
                                  size: 12,
                                  color: AppColors.warning,
                                ),
                              ),
                            )
                          else if (isAnswered)
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  PhosphorIcons.check(PhosphorIconsStyle.bold),
                                  size: 12,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.icon, required this.label, this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
