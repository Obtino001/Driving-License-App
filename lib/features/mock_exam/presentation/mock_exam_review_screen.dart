import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/haptics.dart';
import '../application/mock_exam_controller.dart';

class MockExamReviewScreen extends ConsumerWidget {
  const MockExamReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mockExamProvider);

    if (state.session == null || state.sessionQuestions == null) {
      return const Scaffold(backgroundColor: AppColors.backgroundLight);
    }

    final total = state.sessionQuestions!.length;
    final answered = state.sessionQuestions!.where((q) => q.selectedAnswerIndex != null).length;
    final unanswered = total - answered;
    final flagged = state.sessionQuestions!.where((q) => q.isFlagged).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: AppColors.textPrimary),
          onPressed: () {
            AppHaptics.buttonPress();
            context.pop(); // Go back to last question
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Before you finish',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Review your exam status before submitting for a final score.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 48),
                      _buildStatRow(
                        context,
                        'Answered',
                        answered.toString(),
                        PhosphorIcons.check(PhosphorIconsStyle.bold),
                        AppColors.primaryDark,
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow(
                        context,
                        'Unanswered',
                        unanswered.toString(),
                        PhosphorIcons.circle(),
                        unanswered > 0 ? AppColors.warning : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow(
                        context,
                        'Flagged',
                        flagged.toString(),
                        PhosphorIcons.flag(PhosphorIconsStyle.fill),
                        flagged > 0 ? AppColors.warning : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              if (unanswered > 0) ...[
                AppButton(
                  text: 'Review unanswered',
                  type: AppButtonType.secondary,
                  onPressed: () {
                    AppHaptics.buttonPress();
                    final idx = state.sessionQuestions!.indexWhere((q) => q.selectedAnswerIndex == null);
                    if (idx != -1) {
                      ref.read(mockExamProvider.notifier).goToQuestion(idx);
                      context.pop(); // pop review screen to show question
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (flagged > 0) ...[
                AppButton(
                  text: 'Review flagged',
                  type: AppButtonType.secondary,
                  onPressed: () {
                    AppHaptics.buttonPress();
                    final idx = state.sessionQuestions!.indexWhere((q) => q.isFlagged);
                    if (idx != -1) {
                      ref.read(mockExamProvider.notifier).goToQuestion(idx);
                      context.pop();
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
              AppButton(
                text: 'Submit exam',
                isLoading: state.isSubmitting,
                onPressed: () async {
                  AppHaptics.buttonPress();
                  await ref.read(mockExamProvider.notifier).submitExam();
                  if (context.mounted) {
                    context.pushReplacement('/mock_exam_results');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textTertiary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          Text(
            count,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
