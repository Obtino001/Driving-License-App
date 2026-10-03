import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/motion/app_motion.dart';
import '../../../core/widgets/app_button.dart';
import '../application/mock_exam_controller.dart';
import 'widgets/mock_exam_navigator_sheet.dart';

class MockExamAnswersScreen extends ConsumerWidget {
  const MockExamAnswersScreen({super.key});

  void _showNavigator(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundLight,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => MockExamNavigatorSheet(
        onSelectIndex: (index) {
          ref.read(mockExamProvider.notifier).goToQuestion(index);
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mockExamProvider);

    if (state.questions == null || state.sessionQuestions == null) {
      return const Scaffold(backgroundColor: AppColors.backgroundLight);
    }

    final currentIndex = state.currentIndex;
    final total = state.questions!.length;
    final currentQ = state.questions![currentIndex];
    final currentSQ = state.sessionQuestions![currentIndex];

    final isCorrect = currentSQ.isCorrect == true;
    final isUnanswered = currentSQ.selectedAnswerIndex == null;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: AppColors.textPrimary),
          onPressed: () {
            AppHaptics.buttonPress();
            context.pop();
          },
        ),
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            AppHaptics.selection();
            _showNavigator(context, ref);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Review ${currentIndex + 1} of $total',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                PhosphorIcons.caretDown(),
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: AppMotion.standard,
                switchInCurve: AppMotion.standardEasing,
                switchOutCurve: AppMotion.standardEasing,
                child: ListView(
                  key: ValueKey(currentIndex),
                  padding: const EdgeInsets.all(24),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentQ.category.toUpperCase(),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.textTertiary,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (currentSQ.isFlagged)
                          Icon(
                            PhosphorIcons.flag(PhosphorIconsStyle.fill),
                            color: AppColors.warning,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentQ.questionText,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.textPrimary, height: 1.3),
                    ),
                    const SizedBox(height: 32),
                    // Show explanation header based on correctness
                    if (isUnanswered)
                      _buildFeedbackHeader(
                        context,
                        'Unanswered',
                        AppColors.textSecondary,
                        PhosphorIcons.circle(),
                      )
                    else if (isCorrect)
                      _buildFeedbackHeader(
                        context,
                        'Correct',
                        AppColors.primaryDark,
                        PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                      )
                    else
                      _buildFeedbackHeader(
                        context,
                        'Incorrect',
                        AppColors.warning,
                        PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                      ),

                    const SizedBox(height: 24),
                    _ReviewOption(
                      text: currentQ.answerA,
                      isCorrectAnswer: currentQ.correctAnswerIndex == 0,
                      isUserAnswer: currentSQ.selectedAnswerIndex == 0,
                    ),
                    const SizedBox(height: 16),
                    _ReviewOption(
                      text: currentQ.answerB,
                      isCorrectAnswer: currentQ.correctAnswerIndex == 1,
                      isUserAnswer: currentSQ.selectedAnswerIndex == 1,
                    ),
                    const SizedBox(height: 16),
                    _ReviewOption(
                      text: currentQ.answerC,
                      isCorrectAnswer: currentQ.correctAnswerIndex == 2,
                      isUserAnswer: currentSQ.selectedAnswerIndex == 2,
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                PhosphorIcons.info(PhosphorIconsStyle.fill),
                                color: AppColors.primaryDark,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Explanation',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(color: AppColors.primaryDark),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentQ.explanationShort,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (currentIndex > 0)
                    Expanded(
                      child: AppButton(
                        text: 'Previous',
                        type: AppButtonType.secondary,
                        onPressed: () {
                          AppHaptics.buttonPress();
                          ref
                              .read(mockExamProvider.notifier)
                              .previousQuestion();
                        },
                      ),
                    )
                  else
                    const Spacer(),
                  const SizedBox(width: 16),
                  if (currentIndex < total - 1)
                    Expanded(
                      child: AppButton(
                        text: 'Next',
                        onPressed: () {
                          AppHaptics.buttonPress();
                          ref.read(mockExamProvider.notifier).nextQuestion();
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: AppButton(
                        text: 'Finish Review',
                        onPressed: () {
                          AppHaptics.buttonPress();
                          context.go('/home');
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackHeader(
    BuildContext context,
    String text,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ReviewOption extends StatelessWidget {
  const _ReviewOption({
    required this.text,
    required this.isCorrectAnswer,
    required this.isUserAnswer,
  });

  final String text;
  final bool isCorrectAnswer;
  final bool isUserAnswer;

  @override
  Widget build(BuildContext context) {
    // Styling matches Practice Quiz feedback
    Color borderColor = AppColors.textTertiary.withValues(alpha: 0.15);
    Color bgColor = AppColors.surface;
    Color textColor = AppColors.textPrimary;
    Widget? trailing;

    if (isCorrectAnswer) {
      borderColor = AppColors.primaryDark;
      bgColor = AppColors.primaryAccent.withValues(alpha: 0.1);
      textColor = AppColors.primaryDark;
      trailing = Icon(
        PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
        color: AppColors.primaryDark,
        size: 24,
      );
    } else if (isUserAnswer && !isCorrectAnswer) {
      borderColor = AppColors.warning;
      bgColor = AppColors.warning.withValues(alpha: 0.1);
      textColor = AppColors.textPrimary;
      trailing = Icon(
        PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
        color: AppColors.warning,
        size: 24,
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: isCorrectAnswer || isUserAnswer ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor,
                fontWeight: isCorrectAnswer || isUserAnswer
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 16), trailing],
        ],
      ),
    );
  }
}
