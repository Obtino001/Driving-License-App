import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/motion/app_motion.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/database/app_database.dart';
import '../application/practice_quiz_controller.dart';

class PracticeQuizScreen extends ConsumerStatefulWidget {
  final String? category;

  const PracticeQuizScreen({super.key, this.category});

  @override
  ConsumerState<PracticeQuizScreen> createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends ConsumerState<PracticeQuizScreen> {
  bool _isExplainingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(practiceQuizProvider.notifier).loadQuestions(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(practiceQuizProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: stateAsync.when(
          data: (state) {
            if (state.isFinished) {
              return _buildFinishedState(state);
            }

            final question = state.currentQuestion!;
            final answers = [
              question.answerA,
              question.answerB,
              question.answerC,
            ];

            return Stack(
              children: [
                // Use AnimatedSwitcher for smooth transition between questions
                AnimatedSwitcher(
                  duration: AppMotion.standard,
                  switchInCurve: AppMotion.standardEasing,
                  switchOutCurve: AppMotion.standardAccelerate,
                  child: SingleChildScrollView(
                    key: ValueKey(question.id),
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 32,
                      bottom: 200,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category and difficulty header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                question.category,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          question.questionText,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 48),
                        ...List.generate(answers.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildAnswerCard(
                              index: index,
                              text: answers[index],
                              isRevealed: state.isRevealed,
                              selectedIndex: state.selectedIndex,
                              correctIndex: question.correctAnswerIndex,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Explanation Panel
                AnimatedPositioned(
                  duration: AppMotion.standard,
                  curve: AppMotion.standardEasing,
                  bottom: state.isRevealed ? 0 : -400,
                  left: 0,
                  right: 0,
                  child: _buildExplanationPanel(
                    question,
                    state.selectedIndex == question.correctAnswerIndex,
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          ),
          error: (e, _) => Center(child: Text("Error: \$e")),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final stateAsync = ref.watch(practiceQuizProvider);

    return AppBar(
      leading: IconButton(
        icon: const Icon(PhosphorIconsRegular.x),
        onPressed: () => context.pop(),
      ),
      title: const Text("Practice"),
      actions: [
        if (stateAsync.hasValue &&
            !stateAsync.requireValue.isFinished &&
            stateAsync.requireValue.questions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                "\${stateAsync.requireValue.currentIndex + 1}/\${stateAsync.requireValue.questions.length}",
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.textTertiary),
              ),
            ),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child:
            stateAsync.hasValue && stateAsync.requireValue.questions.isNotEmpty
            ? LinearProgressIndicator(
                value:
                    (stateAsync.requireValue.currentIndex) /
                    stateAsync.requireValue.questions.length,
                backgroundColor: AppColors.textTertiary.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryAccent,
                ),
                minHeight: 4,
              )
            : const SizedBox(height: 4),
      ),
    );
  }

  Widget _buildAnswerCard({
    required int index,
    required String text,
    required bool isRevealed,
    required int? selectedIndex,
    required int correctIndex,
  }) {
    bool isSelected = selectedIndex == index;
    bool isCorrect = index == correctIndex;

    Color backgroundColor = AppColors.surface;
    Color borderColor = const Color(0xFFE0E0E0);
    Widget? trailingIcon;

    if (isRevealed) {
      if (isCorrect) {
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        borderColor = AppColors.success;
        trailingIcon = Icon(
          PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
          color: AppColors.success,
        );
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.danger.withValues(alpha: 0.1);
        borderColor = AppColors.danger;
        trailingIcon = Icon(
          PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
          color: AppColors.danger,
        );
      } else {
        backgroundColor = AppColors.surface.withValues(alpha: 0.5);
      }
    } else if (isSelected) {
      backgroundColor = AppColors.surfaceElevated;
      borderColor = AppColors.primaryDark;
    }

    return GestureDetector(
      onTap: () async {
        if (!isRevealed) {
          await AppHaptics.selection();
          ref
              .read(practiceQuizProvider.notifier)
              .submitAnswer(index);

          if (index == correctIndex) {
            await AppHaptics.success();
          } else {
            await AppHaptics.error();
          }

          setState(() {
            _isExplainingMore =
                false; // Reset explanation state for next question
          });
        }
      },
      child: AnimatedContainer(
        duration: AppMotion.quick,
        curve: AppMotion.springSubtle,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected || (isRevealed && (isCorrect || isSelected))
                ? 2
                : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isRevealed && !isCorrect && !isSelected
                      ? AppColors.textTertiary
                      : AppColors.textPrimary,
                  fontWeight: (isSelected || (isRevealed && isCorrect))
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 16),
              trailingIcon,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationPanel(Question question, bool isUserCorrect) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isUserCorrect
                    ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                    : PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                color: isUserCorrect ? AppColors.success : AppColors.danger,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isUserCorrect ? "Great job!" : "Not quite.",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.explanationShort,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.textPrimary),
          ),
          if (question.explanationDetailed != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExplainingMore = !_isExplainingMore;
                });
              },
              child: Row(
                children: [
                  Text(
                    _isExplainingMore ? "Show less" : "Learn why",
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: AppColors.info),
                  ),
                  Icon(
                    _isExplainingMore
                        ? PhosphorIcons.caretUp()
                        : PhosphorIcons.caretDown(),
                    color: AppColors.info,
                    size: 16,
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: AppMotion.standard,
              curve: AppMotion.standardEasing,
              child: _isExplainingMore
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        question.explanationDetailed!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
          const SizedBox(height: 32),
          AppButton(
            text: "Next Question",
            onPressed: () {
              AppHaptics.buttonPress();
              ref
                  .read(practiceQuizProvider.notifier)
                  .nextQuestion();
              setState(() {
                _isExplainingMore = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedState(PracticeQuizState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.trophy(PhosphorIconsStyle.fill),
              size: 80,
              color: AppColors.primaryAccent,
            ),
            const SizedBox(height: 32),
            Text(
              "Session Complete!",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            Text(
              "You got \${state.correctCount} out of \${state.questions.length} correct.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),
            AppButton(text: "Done", onPressed: () => context.pop()),
          ],
        ),
      ),
    );
  }
}
