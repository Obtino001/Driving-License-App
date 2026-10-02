import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../application/home_controller.dart';
import '../../../core/utils/haptics.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeProvider.notifier).loadHomeData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: stateAsync.when(
              data: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, state),
                    const SizedBox(height: 32),
                    _buildReadinessHero(context, state),
                    const SizedBox(height: 32),
                    _buildActionGrid(context, state),
                    const SizedBox(height: 32),
                    _buildDailyGoal(context, state),
                    const SizedBox(height: 32),
                    _buildLearningRoadmap(context),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryAccent,
                ),
              ),
              error: (e, _) => Center(child: Text("Error: \$e")),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Goal",
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  PhosphorIcons.fire(PhosphorIconsStyle.fill),
                  color: AppColors.warning,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "\${state.streak} Day Streak",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: AppColors.surfaceElevated,
          radius: 24,
          child: Icon(PhosphorIcons.user(), color: AppColors.primaryDark),
        ),
      ],
    );
  }

  Widget _buildReadinessHero(BuildContext context, HomeState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You're",
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(color: AppColors.textTertiary),
                  ),
                  Text(
                    "\${state.readiness}% ready",
                    style: Theme.of(context).textTheme.displayMedium
                        ?.copyWith(color: AppColors.primaryAccent),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  PhosphorIcons.chartLineUp(),
                  color: AppColors.textInverse,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          AppButton(
            text: "Continue Learning",
            onPressed: () {
              AppHaptics.buttonPress();
              context.push('/learn');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context, HomeState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                "Quick Practice",
                PhosphorIcons.lightning(PhosphorIconsStyle.fill),
                AppColors.secondaryAccent,
                () {
                  AppHaptics.selection();
                  context.push('/practice');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context,
                "Road Signs",
                PhosphorIcons.trafficSign(PhosphorIconsStyle.fill),
                AppColors.warning,
                () {
                  AppHaptics.selection();
                  context.push('/signs');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                "Mistakes (\${state.mistakesCount})",
                PhosphorIcons.target(PhosphorIconsStyle.fill),
                AppColors.danger,
                () {
                  AppHaptics.selection();
                  context.push('/mistakes');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyGoal(BuildContext context, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Daily Goal", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Practice 10 Questions",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    "\${state.dailyGoalProgress} / 10",
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: state.dailyGoalProgress / 10,
                backgroundColor: AppColors.textTertiary.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  state.dailyGoalProgress >= 10
                      ? AppColors.success
                      : AppColors.primaryAccent,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLearningRoadmap(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/learn'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.mapTrifold(PhosphorIconsStyle.fill),
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Learning Roadmap",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "View all modules and topics",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight(), color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
