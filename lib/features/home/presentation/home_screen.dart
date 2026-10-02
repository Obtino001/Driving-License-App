import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildReadinessHero(context),
              const SizedBox(height: 32),
              _buildActionGrid(context),
              const SizedBox(height: 32),
              _buildLearningRoadmap(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Goal",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(PhosphorIcons.fire(PhosphorIconsStyle.fill), color: AppColors.warning, size: 24),
                const SizedBox(width: 8),
                Text(
                  "3 Day Streak",
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

  Widget _buildReadinessHero(BuildContext context) {
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                  Text(
                    "64% ready",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.primaryAccent,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(PhosphorIcons.chartLineUp(), color: AppColors.textInverse),
              ),
            ],
          ),
          const SizedBox(height: 32),
          AppButton(
            text: "Continue Learning",
            onPressed: () {
              context.push('/practice');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            "Quick Practice",
            PhosphorIcons.lightning(PhosphorIconsStyle.fill),
            AppColors.secondaryAccent,
            () {
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
            () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color iconColor, VoidCallback onTap) {
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
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningRoadmap(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Learning Roadmap",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        _buildRoadmapItem(context, "Road Rules", "4/5 completed", true, true),
        _buildRoadmapItem(context, "Traffic Signs", "In progress", true, false),
        _buildRoadmapItem(context, "Right of Way", "Locked", false, false),
        _buildRoadmapItem(context, "Speed Limits", "Locked", false, false),
      ],
    );
  }

  Widget _buildRoadmapItem(BuildContext context, String title, String subtitle, bool isAvailable, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primaryAccent
                      : (isAvailable ? AppColors.surfaceDark : AppColors.surfaceElevated),
                  shape: BoxShape.circle,
                  border: isAvailable ? null : Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Icon(
                  isCompleted
                      ? PhosphorIcons.check(PhosphorIconsStyle.bold)
                      : (isAvailable ? PhosphorIcons.carProfile(PhosphorIconsStyle.fill) : PhosphorIcons.lock(PhosphorIconsStyle.fill)),
                  color: isCompleted
                      ? AppColors.primaryDark
                      : (isAvailable ? AppColors.textInverse : AppColors.textTertiary),
                  size: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 2,
                height: 32,
                color: isCompleted ? AppColors.primaryAccent : const Color(0xFFE0E0E0),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isAvailable ? AppColors.textPrimary : AppColors.textTertiary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
