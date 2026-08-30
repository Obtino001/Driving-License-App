library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/widgets/circular_progress_indicator.dart';
import '../providers/mock_test_provider.dart';

class MockTestResultsScreen extends ConsumerStatefulWidget {
  const MockTestResultsScreen({super.key, required this.onExit});

  final VoidCallback onExit;

  @override
  ConsumerState<MockTestResultsScreen> createState() => _MockTestResultsScreenState();
}

class _MockTestResultsScreenState extends ConsumerState<MockTestResultsScreen>
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

    final state = ref.read(mockTestProvider);

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: state.accuracy,
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

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final state = ref.watch(mockTestProvider);
    
    final bool passed = state.isPassed;
    final Color resultColor = passed ? colors.success : theme.colorScheme.error;
    final String resultText = passed ? 'PASSED' : 'FAILED';
    final IconData resultIcon = passed ? Icons.verified_rounded : Icons.cancel_rounded;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const Spacer(flex: 1),

                // Pass/Fail Banner
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: resultColor.withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderRadiusFull,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(resultIcon, color: resultColor),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        resultText,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: resultColor,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xl),

                // Animated Score Ring
                AnimatedBuilder(
                  animation: _scoreAnimation,
                  builder: (context, _) {
                    return AppCircularProgress(
                      progress: _scoreAnimation.value,
                      size: 160,
                      strokeWidth: 14,
                      activeColor: resultColor,
                      showLabel: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(_scoreAnimation.value * 100).round()}%',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
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

                const SizedBox(height: AppSpacing.lg),
                
                // Requirement text
                Text(
                  'Passing score is ${state.config.passingScorePercentage}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const Spacer(flex: 1),

                // Breakdown Grid
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: AppRadius.borderRadiusLg,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _BreakdownItem(
                            icon: Icons.check_circle_rounded,
                            color: colors.success,
                            value: '${state.correctCount}',
                            label: 'Correct',
                          ),
                          _BreakdownItem(
                            icon: Icons.cancel_rounded,
                            color: theme.colorScheme.error,
                            value: '${state.incorrectCount}',
                            label: 'Incorrect',
                          ),
                        ],
                      ),
                      const Divider(height: AppSpacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _BreakdownItem(
                            icon: Icons.help_outline_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                            value: '${state.unansweredCount}',
                            label: 'Unanswered',
                          ),
                          _BreakdownItem(
                            icon: Icons.timer_outlined,
                            color: theme.colorScheme.primary,
                            value: _formatTime(state.timeUsedSeconds),
                            label: 'Time Used',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement Review Mode
                    },
                    icon: const Icon(Icons.fact_check_outlined, size: 20),
                    label: const Text('Review Questions'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderRadiusMd,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.ms),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: () async {
                      final isPremium = ref.read(isPremiumProvider);
                      if (!isPremium) {
                        await ref.read(adsServiceProvider).showInterstitialAd(context);
                      }
                      widget.onExit();
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderRadiusMd,
                      ),
                    ),
                    child: const Text('Done'),
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

class _BreakdownItem extends StatelessWidget {
  const _BreakdownItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
