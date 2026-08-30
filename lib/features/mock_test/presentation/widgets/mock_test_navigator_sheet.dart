library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/mock_test_provider.dart';

/// A bottom sheet that shows a grid of all questions for quick navigation.
class MockTestNavigatorSheet extends ConsumerWidget {
  const MockTestNavigatorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mockTestProvider);
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question Navigator',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(color: theme.colorScheme.primary, label: 'Answered'),
                const SizedBox(width: AppSpacing.md),
                _LegendItem(color: colors.warning, label: 'Flagged'),
                const SizedBox(width: AppSpacing.md),
                _LegendItem(color: theme.colorScheme.surfaceContainerHighest, label: 'Unanswered', textColor: theme.colorScheme.onSurfaceVariant),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Grid
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 60,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                ),
                itemCount: state.totalQuestions,
                itemBuilder: (context, index) {
                  final isAnswered = state.selectedAnswers.containsKey(index);
                  final isFlagged = state.flaggedIndices.contains(index);
                  final isCurrent = state.currentIndex == index;
                  
                  Color bgColor = theme.colorScheme.surfaceContainerHighest;
                  Color textColor = theme.colorScheme.onSurfaceVariant;
                  Color borderColor = Colors.transparent;
                  
                  if (isFlagged) {
                    bgColor = colors.warningContainer;
                    textColor = colors.onWarningContainer;
                    borderColor = colors.warning;
                  } else if (isAnswered) {
                    bgColor = theme.colorScheme.primaryContainer;
                    textColor = theme.colorScheme.onPrimaryContainer;
                  }
                  
                  if (isCurrent) {
                    borderColor = theme.colorScheme.onSurface;
                  }

                  return InkWell(
                    onTap: () {
                      ref.read(mockTestProvider.notifier).jumpToQuestion(index);
                      Navigator.pop(context);
                    },
                    borderRadius: AppRadius.borderRadiusSm,
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: AppRadius.borderRadiusSm,
                        border: Border.all(
                          color: borderColor,
                          width: isCurrent ? 2 : (isFlagged ? 1.5 : 0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label, this.textColor});
  final Color color;
  final String label;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
