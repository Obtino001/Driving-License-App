import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/editorial_header.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/motion/app_motion.dart';

class PracticeLandingScreen extends StatelessWidget {
  const PracticeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            const EditorialHeader(
              title: 'PRACTICE',
              subtitle: 'Sharpen your skills.',
            ),
            const SizedBox(height: 32),
            _PracticeOptionCard(
              title: 'Quick Practice',
              subtitle: 'Random set of 10 questions',
              icon: PhosphorIcons.lightning(PhosphorIconsStyle.fill),
              color: AppColors.primaryAccent,
              onTap: () {
                AppHaptics.selection();
                context.push('/quiz');
              },
            ),
            _PracticeOptionCard(
              title: 'Practice by Topic',
              subtitle: 'Focus on specific categories',
              icon: PhosphorIcons.books(PhosphorIconsStyle.fill),
              color: AppColors.primaryDark,
              onTap: () {
                AppHaptics.selection();
                context.go('/learn');
              },
            ),
            _PracticeOptionCard(
              title: 'Mistakes',
              subtitle: 'Review questions you missed',
              icon: PhosphorIcons.target(PhosphorIconsStyle.fill),
              color: AppColors.warning,
              onTap: () {
                AppHaptics.selection();
                context.push('/mistakes');
              },
            ),
            _PracticeOptionCard(
              title: 'Road Signs Quiz',
              subtitle: 'Test your visual knowledge',
              icon: PhosphorIcons.signpost(PhosphorIconsStyle.fill),
              color: const Color(0xFF849B28),
              onTap: () {
                AppHaptics.selection();
                context.push('/signs');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeOptionCard extends StatelessWidget {
  const _PracticeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppMotion.quick,
        curve: AppMotion.standardEasing,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.textTertiary.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              PhosphorIcons.caretRight(),
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
