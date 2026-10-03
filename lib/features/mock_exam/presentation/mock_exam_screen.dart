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

import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/widgets/visual_scenario.dart';

class MockExamScreen extends ConsumerWidget {
  const MockExamScreen({super.key});

  void _showExitConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _ExitSheet(),
    );
  }

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

    if (state.isLoading ||
        state.questions == null ||
        state.sessionQuestions == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryDark),
        ),
      );
    }

    final currentIndex = state.currentIndex;
    final total = state.questions!.length;
    final currentQ = state.questions![currentIndex];
    final currentSQ = state.sessionQuestions![currentIndex];

    // Read reduced motion preference
    // For now we'll just use standard AnimatedSwitcher
    // If reduced motion is needed, we adjust the duration/curve

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _showExitConfirmation(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          leading: IconButton(
            icon: Icon(PhosphorIcons.x(), color: AppColors.textPrimary),
            onPressed: () {
              AppHaptics.buttonPress();
              _showExitConfirmation(context);
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
                  'Question ${currentIndex + 1} of $total',
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
          actions: [
            IconButton(
              icon: Icon(
                currentSQ.isFlagged
                    ? PhosphorIcons.flag(PhosphorIconsStyle.fill)
                    : PhosphorIcons.flag(),
                color: currentSQ.isFlagged
                    ? AppColors.warning
                    : AppColors.textPrimary,
              ),
              onPressed: () {
                AppHaptics.selection();
                ref.read(mockExamProvider.notifier).toggleFlag();
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Restrained progress bar
              LinearProgressIndicator(
                value: (currentIndex + 1) / total,
                backgroundColor: AppColors.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryDark,
                ),
                minHeight: 2,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppMotion.standard,
                  switchInCurve: AppMotion.standardEasing,
                  switchOutCurve: AppMotion.standardEasing,
                  child: ListView(
                    key: ValueKey(currentIndex),
                    padding: const EdgeInsets.all(24),
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
                      const SizedBox(height: 16),
                      if (currentQ.illustrationAsset?.trim().isNotEmpty ==
                              true ||
                          currentQ.assetType == 'scenario') ...[
                        VisualScenario(
                          assetType: currentQ.assetType,
                          assetPath: currentQ.illustrationAsset,
                          isRevealed: currentSQ.selectedAnswerIndex != null,
                        ),
                        const SizedBox(height: 24),
                      ],
                      Text(
                        currentQ.questionText,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                      ),
                      const SizedBox(height: 40),
                      _AnswerOption(
                        text: currentQ.answerA,
                        isSelected: currentSQ.selectedAnswerIndex == 0,
                        onTap: () =>
                            ref.read(mockExamProvider.notifier).selectAnswer(0),
                      ),
                      const SizedBox(height: 16),
                      _AnswerOption(
                        text: currentQ.answerB,
                        isSelected: currentSQ.selectedAnswerIndex == 1,
                        onTap: () =>
                            ref.read(mockExamProvider.notifier).selectAnswer(1),
                      ),
                      const SizedBox(height: 16),
                      _AnswerOption(
                        text: currentQ.answerC,
                        isSelected: currentSQ.selectedAnswerIndex == 2,
                        onTap: () =>
                            ref.read(mockExamProvider.notifier).selectAnswer(2),
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
                    Expanded(
                      child: AppButton(
                        text: currentIndex < total - 1 ? 'Next' : 'Review',
                        onPressed: () {
                          AppHaptics.buttonPress();
                          if (currentIndex < total - 1) {
                            ref.read(mockExamProvider.notifier).nextQuestion();
                          } else {
                            context.push('/mock_exam_review');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHaptics.selection();
        onTap();
      },
      child: AnimatedContainer(
        duration: AppMotion.quick,
        curve: AppMotion.standardEasing,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryDark
                : AppColors.textTertiary.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? AppColors.primaryAccent
                      : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 16),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.primaryAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.check(PhosphorIconsStyle.bold),
                  size: 12,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExitSheet extends StatelessWidget {
  const _ExitSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pause exam?',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your progress is saved locally. You can resume later from the Practice screen.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Continue exam',
              onPressed: () {
                AppHaptics.buttonPress();
                context.pop();
              },
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Save & exit',
              type: AppButtonType.secondary,
              onPressed: () {
                AppHaptics.buttonPress();
                context.pop(); // close sheet
                context.go('/home'); // back to home/practice
              },
            ),
          ],
        ),
      ),
    );
  }
}
