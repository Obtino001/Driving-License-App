import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/database/app_database.dart';
import '../../../core/motion/app_motion.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/road_progress_track.dart';
import '../../../core/widgets/visual_scenario.dart';
import '../application/practice_quiz_controller.dart';

class PracticeQuizScreen extends ConsumerStatefulWidget {
  const PracticeQuizScreen({super.key, this.category});
  final String? category;

  @override
  ConsumerState<PracticeQuizScreen> createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends ConsumerState<PracticeQuizScreen> {
  bool _showDetail = false;
  bool _submitting = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await ref
            .read(practiceQuizProvider.notifier)
            .loadQuestions(widget.category);
        if (mounted) setState(() => _ready = true);
      }
    });
  }

  Future<void> _submit(int index, int correctIndex) async {
    if (_submitting) return;
    _submitting = true;
    try {
      await ref.read(practiceQuizProvider.notifier).submitAnswer(index);
      if (mounted) {
        if (index == correctIndex) {
          await AppHaptics.success();
        } else {
          await AppHaptics.selection();
        }
      }
    } finally {
      _submitting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(practiceQuizProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: !_ready
            ? const Center(child: CircularProgressIndicator())
            : async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _EmptyQuiz(
                  title: 'Could not load practice',
                  detail: '$error',
                  onClose: () => context.pop(),
                ),
                data: (state) {
                  if (state.questions.isEmpty) {
                    return _EmptyQuiz(
                      title: 'No questions here yet',
                      detail: 'Choose another topic to keep moving.',
                      onClose: () => context.pop(),
                    );
                  }
                  if (state.isFinished) {
                    return _QuizFinished(
                      correct: state.correctCount,
                      total: state.questions.length,
                      onDone: () => context.pop(),
                    );
                  }
                  final question = state.currentQuestion!;
                  return Column(
                    children: [
                      QuizProgressHeader(
                        index: state.currentIndex,
                        total: state.questions.length,
                        category: question.category,
                        onClose: () => context.pop(),
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: AppMotion.standard,
                          switchInCurve: AppMotion.standardEasing,
                          switchOutCurve: AppMotion.standardAccelerate,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(.035, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: SingleChildScrollView(
                            key: ValueKey(question.id),
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CHOOSE ONE ANSWER',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        fontSize: 11,
                                        letterSpacing: 1.5,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  question.questionText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontSize: 29,
                                        height: 1.14,
                                        letterSpacing: -.7,
                                      ),
                                ),
                                if (question.illustrationAsset
                                            ?.trim()
                                            .isNotEmpty ==
                                        true ||
                                    question.assetType == 'scenario') ...[
                                  const SizedBox(height: 20),
                                  VisualScenario(
                                    assetType: question.assetType,
                                    assetPath: question.illustrationAsset,
                                    isRevealed: state.isRevealed,
                                  ),
                                ],
                                const SizedBox(height: 28),
                                ...List.generate(3, (index) {
                                  final answers = [
                                    question.answerA,
                                    question.answerB,
                                    question.answerC,
                                  ];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: PremiumAnswerCard(
                                      index: index,
                                      text: answers[index],
                                      revealed: state.isRevealed,
                                      selected: state.selectedIndex == index,
                                      correct:
                                          question.correctAnswerIndex == index,
                                      onTap: () => _submit(
                                        index,
                                        question.correctAnswerIndex,
                                      ),
                                    ),
                                  );
                                }),
                                AnimatedSize(
                                  duration: AppMotion.standard,
                                  curve: AppMotion.standardEasing,
                                  alignment: Alignment.topCenter,
                                  child: state.isRevealed
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            top: 15,
                                          ),
                                          child: ExplanationPanel(
                                            question: question,
                                            correct:
                                                state.selectedIndex ==
                                                question.correctAnswerIndex,
                                            expanded: _showDetail,
                                            onToggle: () => setState(
                                              () => _showDetail = !_showDetail,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (state.isRevealed)
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            20,
                            11,
                            20,
                            12 + MediaQuery.paddingOf(context).bottom,
                          ),
                          color: AppColors.backgroundLight,
                          child: AppButton(
                            text:
                                state.currentIndex + 1 == state.questions.length
                                ? 'See results  →'
                                : 'Next question  →',
                            onPressed: () {
                              AppHaptics.buttonPress();
                              setState(() => _showDetail = false);
                              ref
                                  .read(practiceQuizProvider.notifier)
                                  .nextQuestion();
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class QuizProgressHeader extends StatelessWidget {
  const QuizProgressHeader({
    super.key,
    required this.index,
    required this.total,
    required this.category,
    required this.onClose,
  });
  final int index;
  final int total;
  final String category;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 11, 20, 12),
    child: Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onClose,
              tooltip: 'Close practice',
              icon: Icon(PhosphorIcons.x(), size: 23),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                'QUESTION ${index + 1} OF $total',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Padding(
          padding: const EdgeInsets.only(left: 9),
          child: RoadProgressTrack(
            progress: total == 0 ? 0 : (index + 1) / total,
          ),
        ),
      ],
    ),
  );
}

class PremiumAnswerCard extends StatefulWidget {
  const PremiumAnswerCard({
    super.key,
    required this.index,
    required this.text,
    required this.revealed,
    required this.selected,
    required this.correct,
    required this.onTap,
  });
  final int index;
  final String text;
  final bool revealed;
  final bool selected;
  final bool correct;
  final VoidCallback onTap;

  @override
  State<PremiumAnswerCard> createState() => _PremiumAnswerCardState();
}

class _PremiumAnswerCardState extends State<PremiumAnswerCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final right = widget.revealed && widget.correct;
    final wrong = widget.revealed && widget.selected && !widget.correct;
    final color = right
        ? const Color(0xFFE6F2D2)
        : wrong
        ? const Color(0xFFF9E7E3)
        : AppColors.surface;
    final border = right
        ? const Color(0xFF6D9137)
        : wrong
        ? const Color(0xFFB86D62)
        : const Color(0xFFDCE1DA);
    return Semantics(
      button: !widget.revealed,
      selected: widget.selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.revealed
            ? null
            : (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.revealed ? null : widget.onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: wrong ? 1 : 0),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : AppMotion.standard,
          builder: (context, value, child) => Transform.translate(
            offset: Offset(wrong ? math.sin(value * math.pi) * 4 : 0, 0),
            child: child,
          ),
          child: AnimatedScale(
            scale: _pressed ? .985 : 1,
            duration: AppMotion.quick,
            child: AnimatedContainer(
              duration: AppMotion.quick,
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: border,
                  width: right || wrong ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: right
                          ? AppColors.primaryDark
                          : wrong
                          ? const Color(0xFFAF5B51)
                          : const Color(0xFFF1F3EE),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      String.fromCharCode(65 + widget.index),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: right || wrong
                            ? AppColors.surface
                            : AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(height: 1.3, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (right || wrong) ...[
                    const SizedBox(width: 8),
                    Icon(
                      right
                          ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                          : PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                      color: right
                          ? AppColors.primaryDark
                          : const Color(0xFFAF5B51),
                      size: 22,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExplanationPanel extends StatelessWidget {
  const ExplanationPanel({
    super.key,
    required this.question,
    required this.correct,
    required this.expanded,
    required this.onToggle,
  });
  final Question question;
  final bool correct;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final detail = question.explanationDetailed?.trim() ?? '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            correct
                ? 'CORRECT  /  KEEP MOVING'
                : 'NOT QUITE  /  LEARN THE RULE',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.primaryAccent,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            question.explanationShort,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.surface, height: 1.4),
          ),
          if (detail.isNotEmpty) ...[
            const SizedBox(height: 13),
            TextButton(
              onPressed: onToggle,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.primaryAccent,
              ),
              child: Text(expanded ? 'Show less ↑' : 'Learn why ↓'),
            ),
            AnimatedSize(
              duration: AppMotion.standard,
              child: expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        detail,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: const Color(0xFFD5DED4)),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuizFinished extends StatelessWidget {
  const _QuizFinished({
    required this.correct,
    required this.total,
    required this.onDone,
  });
  final int correct;
  final int total;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Text(
          'SESSION COMPLETE',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            letterSpacing: 1.5,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '$correct / $total',
          style: Theme.of(context).textTheme.displayLarge
              ?.copyWith(fontSize: 70, letterSpacing: -3),
        ),
        const SizedBox(height: 8),
        Text(
          'Every answer moves you forward.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 24),
        RoadProgressTrack(progress: total == 0 ? 0 : correct / total),
        const Spacer(),
        AppButton(text: 'Back to journey  →', onPressed: onDone),
      ],
    ),
  );
}

class _EmptyQuiz extends StatelessWidget {
  const _EmptyQuiz({
    required this.title,
    required this.detail,
    required this.onClose,
  });
  final String title;
  final String detail;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(detail, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          AppButton(text: 'Go back', onPressed: onClose),
        ],
      ),
    ),
  );
}
