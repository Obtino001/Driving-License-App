/// Home screen — the visual signature of the app.
///
/// Assembles the hero ProgressCard, ChallengeCard, QuickActions row,
/// and WeeklyProgress in a scrollable layout with staggered entrance
/// animations and generous whitespace.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/streak_badge.dart';
import '../../practice/data/mock_questions.dart';
import '../../practice/presentation/quiz_session_screen.dart';
import '../../mock_test/presentation/mock_test_intro_screen.dart';
import '../../road_signs/presentation/road_signs_screen.dart';
import '../../practice/providers/mistakes_provider.dart';
import '../../practice/presentation/mistakes_dashboard_screen.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../premium/presentation/premium_upgrade_screen.dart';
import 'widgets/progress_card.dart';
import 'widgets/challenge_card.dart';
import 'widgets/quick_action.dart';
import 'widgets/weekly_progress.dart';

/// The main Home tab — first thing the user sees.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // ─── Top Bar: greeting + avatar ───
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: _TopBar(),
              ),
            ),

            // ─── Hero: Continue Learning card ───
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: ProgressCard(
                  categoryName: 'Road Signs & Signals',
                  completedQuestions: 26,
                  totalQuestions: 40,
                  onContinue: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => QuizSessionScreen(
                        title: 'Road Signs & Signals',
                        questions: getQuestionsByCategory('Road Signs & Signals'),
                      ),
                    ));
                  },
                ),
              ),
            ),

            // ─── Section label ───
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: _SectionLabel(
                  title: 'Daily',
                  animationDelay: const Duration(milliseconds: 150),
                ),
              ),
            ),

            // ─── Today's Challenge ───
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: ChallengeCard(
                  questionCount: 10,
                  estimatedMinutes: 5,
                  isCompleted: false,
                  animationDelay: const Duration(milliseconds: 200),
                  onStart: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const QuizSessionScreen(
                        title: 'Daily Challenge',
                      ),
                    ));
                  },
                ),
              ),
            ),

            // ─── Mistakes Banner ───
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, ref, _) {
                  final mistakesAsync = ref.watch(mistakesProvider);
                  return mistakesAsync.maybeWhen(
                    data: (state) {
                      if (state.totalMistakes > 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xl),
                          child: _MistakesBanner(count: state.totalMistakes),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ),

            // ─── Premium Upsell Banner ───
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, ref, _) {
                  final isPremium = ref.watch(isPremiumProvider);
                  if (!isPremium) {
                    return const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xl),
                      child: _PremiumUpsellBanner(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            // ─── Section label ───
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: _SectionLabel(
                  title: 'Explore',
                  animationDelay: const Duration(milliseconds: 250),
                ),
              ),
            ),

            // ─── Quick Actions ───
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.ms, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: QuickActionsRow(
                  onQuickPractice: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const QuizSessionScreen(
                        title: 'Quick Practice',
                      ),
                    ));
                  },
                  onMockTest: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const MockTestIntroScreen(),
                    ));
                  },
                  onRoadSigns: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const RoadSignsScreen(),
                    ));
                  },
                ),
              ),
            ),

            // ─── Weekly Progress ───
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: WeeklyProgress(
                  activeDays: const {1, 2, 3, 5, 6},
                  currentStreak: 5,
                  animationDelay: const Duration(milliseconds: 400),
                ),
              ),
            ),

            // ─── Motivational footer ───
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(
                child: _MotivationalFooter(
                  animationDelay: const Duration(milliseconds: 500),
                ),
              ),
            ),

            // Bottom clearance for nav bar
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: AppSpacing.xxl + bottomPadding,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar ────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Ready for your test?',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const StreakBadge(days: 5, compact: true),
        const SizedBox(width: AppSpacing.ms),
        _AvatarButton(),
      ],
    );
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

// ─── Avatar Button ──────────────────────────────────────────────────────────

class _AvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: 'Profile',
      child: GestureDetector(
        onTap: () {
          // TODO: Navigate to profile
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'Y',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section Label ──────────────────────────────────────────────────────────

class _SectionLabel extends StatefulWidget {
  const _SectionLabel({
    required this.title,
    this.animationDelay = Duration.zero,
  });

  final String title;
  final Duration animationDelay;

  @override
  State<_SectionLabel> createState() => _SectionLabelState();
}

class _SectionLabelState extends State<_SectionLabel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        widget.title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _MistakesBanner extends StatelessWidget {
  const _MistakesBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Material(
        color: colors.warning.withValues(alpha: 0.15),
        borderRadius: AppRadius.borderRadiusLg,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MistakesDashboardScreen()),
            );
          },
          borderRadius: AppRadius.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.warning.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.psychology_alt_rounded, color: colors.warning),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review Mistakes',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'You have $count questions to improve.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.warning),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Motivational Footer ────────────────────────────────────────────────────

class _MotivationalFooter extends StatefulWidget {
  const _MotivationalFooter({
    this.animationDelay = Duration.zero,
  });

  final Duration animationDelay;

  @override
  State<_MotivationalFooter> createState() => _MotivationalFooterState();
}

class _MotivationalFooterState extends State<_MotivationalFooter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  static const _quotes = [
    'Every expert was once a beginner. 🌱',
    'One question at a time. You\'ve got this! 💪',
    'Consistency beats intensity. Keep going! 🔥',
    'Your future self will thank you. 🚗',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quoteIndex = DateTime.now().day % _quotes.length;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: AppRadius.borderRadiusLg,
        ),
        child: Text(
          _quotes[quoteIndex],
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _PremiumUpsellBanner extends StatelessWidget {
  const _PremiumUpsellBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Material(
        color: theme.colorScheme.primaryContainer,
        borderRadius: AppRadius.borderRadiusLg,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PremiumUpgradeScreen()),
            );
          },
          borderRadius: AppRadius.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unlock Premium',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'No ads, Smart Mistakes & unlimited tests.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
