import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/motion/app_motion.dart';
import '../application/mock_exam_controller.dart';

class MockExamIntroScreen extends ConsumerWidget {
  const MockExamIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIcons.x(), color: AppColors.textPrimary),
          onPressed: () {
            AppHaptics.buttonPress();
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  PhosphorIcons.flagCheckered(PhosphorIconsStyle.fill),
                  color: AppColors.primaryAccent,
                  size: 32,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'MOCK EXAM',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ready for a full\ntest run?',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 48),
              _buildFeatureRow(
                context,
                PhosphorIcons.listNumbers(),
                '$mockExamQuestionCount Questions',
                'Simulates the real format.',
              ),
              const SizedBox(height: 24),
              _buildFeatureRow(
                context,
                PhosphorIcons.timer(),
                '~20 Minutes',
                'Take your time. You can review before submitting.',
              ),
              const SizedBox(height: 24),
              _buildFeatureRow(
                context,
                PhosphorIcons.eyeClosed(),
                'No Immediate Feedback',
                'Correct answers are shown at the end.',
              ),
              const Spacer(),
              Text(
                'This is a practice simulation and is not the official California DMV knowledge test.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Start mock exam',
                onPressed: () async {
                  AppHaptics.buttonPress();
                  await ref.read(mockExamProvider.notifier).startExam();
                  if (context.mounted) {
                    context.pushReplacement('/mock_exam');
                  }
                },
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Not now',
                type: AppButtonType.secondary,
                onPressed: () {
                  AppHaptics.buttonPress();
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.textTertiary.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(icon, color: AppColors.primaryDark, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
