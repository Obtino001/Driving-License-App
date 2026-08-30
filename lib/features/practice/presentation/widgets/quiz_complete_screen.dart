/// Quiz completion screen with results summary.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/widgets/circular_progress_indicator.dart';
import '../../providers/quiz_session_provider.dart';

/// Full-screen results shown after completing a quiz session.
class QuizCompleteScreen extends ConsumerStatefulWidget {
  const QuizCompleteScreen({
    super.key,
    required this.state,
    this.onRetry,
    this.onExit,
    this.onReviewWrong,
  });

  final QuizSessionState state;
  final VoidCallback? onRetry;
  final VoidCallback? onExit;
  final VoidCallback? onReviewWrong;

  @override
  ConsumerState<QuizCompleteScreen> createState() => _QuizCompleteScreenState();
}

class _QuizCompleteScreenState extends ConsumerState<QuizCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scoreAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.state.accuracy / 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _resultEmoji {
    final acc = widget.state.accuracy;
    if (acc >= 90) return '🏆';
    if (acc >= 80) return '🌟';
    if (acc >= 70) return '👍';
    if (acc >= 60) return '💪';
    return '📚';
  }

  String get _resultMessage {
    final acc = widget.state.accuracy;
    if (acc >= 90) return 'Outstanding!';
    if (acc >= 80) return 'Great job!';
    if (acc >= 70) return 'Good work!';
    if (acc >= 60) return 'Keep practicing!';
    return 'Let\'s review and try again';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final s = widget.state;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const Spacer(flex: 1),

                // Emoji
                Text(_resultEmoji, style: const TextStyle(fontSize: 56)),
                const SizedBox(height: AppSpacing.md),

                // Result message
                Text(
                  _resultMessage,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Animated score ring
                AnimatedBuilder(
                  animation: _scoreAnimation,
                  builder: (context, _) {
                    return AppCircularProgress(
                      progress: _scoreAnimation.value,
                      size: 140,
                      strokeWidth: 12,
                      activeColor:
                          s.accuracy >= 70 ? colors.success : colors.warning,
                      showLabel: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(_scoreAnimation.value * 100).round()}%',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Score',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.xl),

                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatColumn(
                      value: '${s.correctCount}',
                      label: 'Correct',
                      color: colors.success,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: theme.colorScheme.outlineVariant,
                    ),
                    _StatColumn(
                      value: '${s.incorrectCount}',
                      label: 'Incorrect',
                      color: theme.colorScheme.error,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: theme.colorScheme.outlineVariant,
                    ),
                    _StatColumn(
                      value: '${s.totalQuestions}',
                      label: 'Total',
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),

                const Spacer(flex: 2),

                // Action buttons
                if (s.incorrectCount > 0) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.tonalIcon(
                      onPressed: widget.onReviewWrong,
                      icon: const Icon(Icons.replay_rounded, size: 20),
                      label: const Text('Review Wrong Answers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderRadiusLg,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.ms),
                ],

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: () async {
                      final isPremium = ref.read(isPremiumProvider);
                      if (!isPremium) {
                        await ref.read(adsServiceProvider).showInterstitialAd(context);
                      }
                      if (widget.onExit != null) widget.onExit!();
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderRadiusLg,
                      ),
                    ),
                    child: const Text('Back to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
