import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';

class SignsScreen extends StatelessWidget {
  const SignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text("Road Signs")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildModes(context),
              const SizedBox(height: 32),
              _buildCategories(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Master the Signs",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          "Learn to instantly recognize every traffic sign.",
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildModes(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildModeCard(
            context,
            "Flashcards",
            PhosphorIcons.cards(),
            AppColors.primaryAccent,
            AppColors.primaryDark,
            () {
              AppHaptics.selection();
              context.push('/signs/flashcards');
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildModeCard(
            context,
            "Sign Quiz",
            PhosphorIcons.question(),
            AppColors.surfaceDark,
            AppColors.textInverse,
            () {
              AppHaptics.selection();
              context.push('/practice', extra: 'Traffic Signs');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModeCard(
    BuildContext context,
    String title,
    IconData icon,
    Color bgColor,
    Color fgColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: fgColor, size: 28),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: fgColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      {
        'name': 'Regulatory',
        'icon': PhosphorIcons.prohibit(),
        'color': AppColors.danger,
      },
      {
        'name': 'Warning',
        'icon': PhosphorIcons.warning(),
        'color': AppColors.warning,
      },
      {
        'name': 'Guide',
        'icon': PhosphorIcons.info(),
        'color': AppColors.success,
      },
      {
        'name': 'Construction',
        'icon': PhosphorIcons.trafficCone(),
        'color': AppColors.warning,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Browse by Category",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ...categories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (cat['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      color: cat['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      cat['name'] as String,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Icon(
                    PhosphorIcons.caretRight(),
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
