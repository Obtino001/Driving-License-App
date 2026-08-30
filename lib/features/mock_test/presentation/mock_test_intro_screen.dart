library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../practice/data/mock_questions.dart';
import '../data/models/mock_test_config.dart';
import 'mock_test_session_screen.dart';

/// Introduction screen for the Mock Test.
class MockTestIntroScreen extends StatelessWidget {
  const MockTestIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    // We can make these configurable later, but for now we'll stick to a standard mock test config.
    const config = MockTestConfig(
      questionCount: 20, 
      timeLimitMinutes: 30,
      passingScorePercentage: 80,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Test'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              
              // Icon Header
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment_turned_in_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Title
              Text(
                'Ready for your Mock Test?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Subtitle
              Text(
                'This test simulates the real exam environment. You will not see correct answers until the end.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              // Rules / Info Cards
              _InfoRow(
                icon: Icons.timer_outlined,
                title: 'Time Limit',
                value: '${config.timeLimitMinutes} Minutes',
              ),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                icon: Icons.format_list_numbered_rounded,
                title: 'Questions',
                value: '${config.questionCount} Multiple Choice',
              ),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                icon: Icons.check_circle_outline_rounded,
                title: 'Passing Score',
                value: '${config.passingScorePercentage}% (${config.requiredCorrectCount} correct)',
                iconColor: colors.success,
              ),
              
              const Spacer(flex: 2),
                            // Start Button
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: () {
                      final questions = getQuickPracticeQuestions(count: config.questionCount);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => MockTestSessionScreen(
                            config: config,
                            questions: questions,
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderRadiusLg,
                      ),
                    ),
                    child: Text(
                      'Start Test',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iColor = iconColor ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: iColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Icon(icon, color: iColor, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
