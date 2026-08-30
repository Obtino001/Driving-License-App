library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../practice/data/models/question.dart';
import '../data/models/mock_test_config.dart';
import '../providers/mock_test_provider.dart';
import 'mock_test_results_screen.dart';
import 'widgets/mock_test_answer_option.dart';
import 'widgets/mock_test_navigator_sheet.dart';

class MockTestSessionScreen extends StatelessWidget {
  const MockTestSessionScreen({
    super.key,
    required this.config,
    required this.questions,
  });

  final MockTestConfig config;
  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        mockTestProvider.overrideWith(
          (ref) => MockTestNotifier(config: config, questions: questions),
        ),
      ],
      child: const _MockTestBody(),
    );
  }
}

class _MockTestBody extends ConsumerWidget {
  const _MockTestBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mockTestProvider);

    if (state.isSubmitted) {
      return MockTestResultsScreen(
        onExit: () => Navigator.of(context).pop(),
      );
    }

    return const _MockTestQuestionView();
  }
}

class _MockTestQuestionView extends ConsumerStatefulWidget {
  const _MockTestQuestionView();

  @override
  ConsumerState<_MockTestQuestionView> createState() => _MockTestQuestionViewState();
}

class _MockTestQuestionViewState extends ConsumerState<_MockTestQuestionView>
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
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(parent: _transitionController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _transitionController, curve: Curves.easeOutCubic));
    _transitionController.value = 1.0;
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _triggerTransition(VoidCallback action) {
    _transitionController.reverse().then((_) {
      action();
      _transitionController.forward();
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<bool> _onWillPop() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Test Early?'),
        content: const Text(
            'Are you sure you want to exit? Your progress will be lost and the test will not be scored.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Exit Test'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _confirmSubmit() async {
    final state = ref.read(mockTestProvider);
    final unans = state.unansweredCount;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Test?'),
        content: Text(unans > 0
            ? 'You have $unans unanswered questions. Are you sure you want to submit?'
            : 'You have answered all questions. Ready to see your results?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      ref.read(mockTestProvider.notifier).submitTest();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final state = ref.watch(mockTestProvider);
    final question = state.currentQuestion;

    if (state.currentIndex != _previousIndex) {
      _previousIndex = state.currentIndex;
      // We assume _transitionController is handled by _triggerTransition.
    }

    // Time warning color
    final timeColor = state.timeRemainingSeconds < 300 
        ? theme.colorScheme.error 
        : theme.colorScheme.onSurfaceVariant;

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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, color: timeColor, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formatTime(state.timeRemainingSeconds),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: timeColor,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _confirmSubmit,
              child: const Text('Submit'),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ─── Progress & Question Info ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${state.currentIndex + 1} of ${state.totalQuestions}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ref.read(mockTestProvider.notifier).toggleFlag();
                      },
                      borderRadius: AppRadius.borderRadiusSm,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              state.isCurrentFlagged ? Icons.flag_rounded : Icons.flag_outlined,
                              color: state.isCurrentFlagged ? colors.warning : theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Flag',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: state.isCurrentFlagged ? colors.warning : theme.colorScheme.onSurfaceVariant,
                                fontWeight: state.isCurrentFlagged ? FontWeight.w600 : FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(
                value: (state.currentIndex + 1) / state.totalQuestions,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                minHeight: 2,
              ),

              // ─── Question & Answers ───
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      children: [
                        Text(
                          question.text,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        ...List.generate(question.options.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.ms),
                            child: MockTestAnswerOption(
                              index: i,
                              text: question.options[i],
                              isSelected: state.currentAnswer == i,
                              onTap: () {
                                ref.read(mockTestProvider.notifier).selectAnswer(i);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Bottom Navigation ───
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous
                    IconButton(
                      onPressed: state.hasPrevious
                          ? () => _triggerTransition(() => ref.read(mockTestProvider.notifier).previousQuestion())
                          : null,
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    
                    // Grid Navigator
                    ActionChip(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => UncontrolledProviderScope(
                            container: ProviderScope.containerOf(context),
                            child: const MockTestNavigatorSheet(),
                          ),
                        );
                      },
                      avatar: const Icon(Icons.grid_view_rounded, size: 18),
                      label: const Text('View All'),
                    ),

                    // Next
                    IconButton(
                      onPressed: state.hasNext
                          ? () => _triggerTransition(() => ref.read(mockTestProvider.notifier).nextQuestion())
                          : null,
                      icon: const Icon(Icons.arrow_forward_rounded),
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
