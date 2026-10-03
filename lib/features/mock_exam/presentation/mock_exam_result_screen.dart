import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/haptics.dart';
import '../application/mock_exam_controller.dart';

class MockExamResultScreen extends ConsumerStatefulWidget {
  const MockExamResultScreen({super.key});

  @override
  ConsumerState<MockExamResultScreen> createState() =>
      _MockExamResultScreenState();
}

class _MockExamResultScreenState extends ConsumerState<MockExamResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _surfaceOpacity;
  late Animation<double> _scoreOpacity;
  late Animation<double> _statsOpacity;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _surfaceOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );
    _scoreOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
    _statsOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
    AppHaptics.selection();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mockExamProvider);

    if (state.session == null || state.sessionQuestions == null) {
      return const Scaffold(backgroundColor: AppColors.backgroundLight);
    }

    final session = state.session!;
    final score = session.score ?? 0;
    final isPass = score >= session.passingRequirement;
    final total = session.questionCount;
    final percentage = (score / total * 100).round();

    int correct = 0;
    int incorrect = 0;
    int unanswered = 0;

    // We can also calculate category breakdown if needed, but keeping it simple for now.
    for (final q in state.sessionQuestions!) {
      if (q.selectedAnswerIndex == null) {
        unanswered++;
      } else if (q.isCorrect == true) {
        correct++;
      } else {
        incorrect++;
      }
    }

    final duration = session.completedAt != null
        ? session.completedAt!.difference(session.startedAt)
        : Duration.zero;
    final durationStr = '${duration.inMinutes}m ${duration.inSeconds % 60}s';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          leading: IconButton(
            icon: Icon(PhosphorIcons.x(), color: AppColors.textPrimary),
            onPressed: () {
              AppHaptics.buttonPress();
              context.go('/home');
            },
          ),
        ),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                children: [
                  FadeTransition(
                    opacity: _surfaceOpacity,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isPass
                              ? AppColors.primaryAccent.withValues(alpha: 0.2)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          isPass ? 'PASS' : 'KEEP PRACTICING',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.primaryDark,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _scoreOpacity,
                    child: Column(
                      children: [
                        Text(
                          isPass
                              ? 'Strong run.'
                              : 'Let\'s tighten the weak spots.',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontSize: 40,
                                height: 1.1,
                                letterSpacing: -1.0,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$percentage%',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontSize: 72,
                                height: 1.0,
                                color: isPass
                                    ? AppColors.primaryDark
                                    : AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$score of $total correct • ${session.passingRequirement} required',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  FadeTransition(
                    opacity: _statsOpacity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatBox(
                                'Correct',
                                correct.toString(),
                                AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatBox(
                                'Incorrect',
                                incorrect.toString(),
                                AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatBox(
                                'Unanswered',
                                unanswered.toString(),
                                AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatBox(
                                'Time',
                                durationStr,
                                AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        AppButton(
                          text: 'Review answers',
                          onPressed: () {
                            AppHaptics.buttonPress();
                            // Reset current index to 0 and push to review route
                            ref.read(mockExamProvider.notifier).goToQuestion(0);
                            context.push('/mock_exam_answers');
                          },
                        ),
                        const SizedBox(height: 16),
                        if (!isPass)
                          AppButton(
                            text: 'Practice weak areas',
                            type: AppButtonType.secondary,
                            onPressed: () {
                              AppHaptics.buttonPress();
                              // Could deep link to specific category. For now go to mistakes.
                              context.go('/mistakes');
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
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
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
