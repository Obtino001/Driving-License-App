/// Main quiz session screen — the core driving question experience.
///
/// Full-screen overlay with:
/// - Top bar: back, question counter, progress, bookmark
/// - Question text
/// - 4 answer options
/// - Explanation panel (slides up after answering)
/// - Smooth transitions between questions
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/models/question.dart';
import '../data/mock_questions.dart';
import '../providers/quiz_session_provider.dart';
import 'widgets/answer_option.dart';
import 'widgets/explanation_panel.dart';
import 'widgets/quiz_complete_screen.dart';

import '../data/repositories/question_repository.dart';

/// Entry point for starting a quiz session.
///
/// Creates a [ProviderScope] override so the quiz session is scoped
/// to this screen's lifecycle.
class QuizSessionScreen extends StatelessWidget {
  const QuizSessionScreen({
    super.key,
    this.questions,
    this.title = 'Practice',
  });

  /// Questions to use. Falls back to 10 random mock questions.
  final List<Question>? questions;

  /// Title shown in the app bar.
  final String title;

  @override
  Widget build(BuildContext context) {
    final sessionQuestions = questions ?? getQuickPracticeQuestions(count: 10);

    return ProviderScope(
      overrides: [
        quizSessionProvider.overrideWith(
          (ref) {
            final repo = ref.watch(sqlQuestionRepositoryProvider);
            return QuizSessionNotifier(
              questions: sessionQuestions,
              repository: repo,
            );
          }
        ),
      ],
      child: _QuizSessionBody(title: title),
    );
  }
}

class _QuizSessionBody extends ConsumerWidget {
  const _QuizSessionBody({required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizSessionProvider);

    if (state.isCompleted) {
      return QuizCompleteScreen(
        state: state,
        onExit: () => Navigator.of(context).pop(),
        onReviewWrong: () {
          // Jump to first wrong answer
          final firstWrong = state.results.indexWhere(
            (r) => r.status == QuestionStatus.incorrect,
          );
          if (firstWrong >= 0) {
            ref.read(quizSessionProvider.notifier).goToQuestion(firstWrong);
          }
        },
      );
    }

    return _QuizQuestionView(title: title);
  }
}

/// The main question view with app bar, question, answers, and explanation.
class _QuizQuestionView extends ConsumerStatefulWidget {
  const _QuizQuestionView({required this.title});
  final String title;

  @override
  ConsumerState<_QuizQuestionView> createState() => _QuizQuestionViewState();
}

class _QuizQuestionViewState extends ConsumerState<_QuizQuestionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutCubic,
    ));
    _transitionController.value = 1.0; // Start visible
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _onAnswerSelected(int index) {
    ref.read(quizSessionProvider.notifier).selectAnswer(index);
  }

  void _onNext() {
    // Animate out, switch question, animate in
    _transitionController.reverse().then((_) {
      ref.read(quizSessionProvider.notifier).nextQuestion();
      _transitionController.forward();
    });
  }

  Future<bool> _onWillPop() async {
    final state = ref.read(quizSessionProvider);
    if (state.answeredCount == 0) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Practice?'),
        content: Text(
          'You\'ve answered ${state.answeredCount} of ${state.totalQuestions} '
          'questions. Your progress in this session will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Going'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final state = ref.watch(quizSessionProvider);
    final question = state.currentQuestion;
    final result = state.currentResult;

    // Detect question change for transition
    if (state.currentIndex != _previousIndex) {
      _previousIndex = state.currentIndex;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ─── Top Bar ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm, AppSpacing.sm, AppSpacing.md, 0,
                ),
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () async {
                        final shouldPop = await _onWillPop();
                        if (shouldPop && context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Exit',
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                    ),

                    // Question counter
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Question ${state.currentIndex + 1} of ${state.totalQuestions}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),

                          // Progress bar
                          ClipRRect(
                            borderRadius: AppRadius.borderRadiusFull,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0,
                                end: state.progress,
                              ),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) {
                                return LinearProgressIndicator(
                                  value: value,
                                  minHeight: 6,
                                  backgroundColor: theme
                                      .colorScheme.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bookmark button
                    IconButton(
                      onPressed: () {
                        ref
                            .read(quizSessionProvider.notifier)
                            .toggleBookmark();
                      },
                      icon: Icon(
                        result.isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        color: result.isBookmarked
                            ? colors.warning
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      tooltip: 'Bookmark',
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Question + Answers (scrollable) ────────────────────
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.lg,
                      ),
                      children: [
                        // Category chip
                        if (question.category.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.ms),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.ms,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: theme
                                      .colorScheme.surfaceContainerHighest,
                                  borderRadius: AppRadius.borderRadiusFull,
                                ),
                                child: Text(
                                  question.category,
                                  style:
                                      theme.textTheme.labelSmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Question text
                        Text(
                          question.text,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Answer options
                        ...List.generate(question.options.length, (i) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.ms),
                            child: AnswerOption(
                              index: i,
                              text: question.options[i],
                              status: result.status,
                              isSelected: result.selectedIndex == i,
                              isCorrectAnswer:
                                  i == question.correctIndex,
                              isRevealed: result.isAnswered,
                              onTap: result.isAnswered
                                  ? null
                                  : () => _onAnswerSelected(i),
                            ),
                          );
                        }),

                        // Extra space if explanation is showing
                        if (state.showExplanation)
                          const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Explanation Panel (slides up from bottom) ──────────
              if (state.showExplanation)
                ExplanationPanel(
                  explanation: question.explanation,
                  isCorrect: result.isCorrect,
                  correctAnswer: question.correctAnswer,
                  onNext: _onNext,
                  isLastQuestion: !state.hasNext,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
