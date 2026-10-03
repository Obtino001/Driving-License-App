import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/motion/app_motion.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/preferences/preferences_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _nextPage() async {
    AppHaptics.buttonPress();
    if (_currentIndex < 3) {
      _pageController.nextPage(
        duration: AppMotion.expressive,
        curve: AppMotion.standardEasing,
      );
    } else {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool('onboarding_complete', true);
      if (mounted) {
        context.go('/home');
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  _buildBrandIntro(),
                  _buildWhatPreparingFor(),
                  _buildWhenIsTest(),
                  _buildStudyPlanReveal(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AppButton(
                text: _currentIndex == 3 ? "Start my plan" : "Continue",
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandIntro() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              PhosphorIcons.steeringWheel(PhosphorIconsStyle.fill),
              color: AppColors.primaryAccent,
              size: 48,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "Your road\nto ready\nstarts here.",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  height: 1.05,
                  letterSpacing: -1.5,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            "The most efficient, modern way to pass your DMV written exam. No detours.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatPreparingFor() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What are you\npreparing for?",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 48),
          _buildSelectableCard("California Class C", true, () {}),
          const SizedBox(height: 16),
          _buildSelectableCard("Motorcycle", false, () {}),
          const SizedBox(height: 16),
          _buildSelectableCard("Commercial (CDL)", false, () {}),
        ],
      ),
    );
  }

  Widget _buildWhenIsTest() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "When is\nyour test?",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 48),
          _buildSelectableCard("This week", false, () {}),
          const SizedBox(height: 16),
          _buildSelectableCard("1-2 weeks", true, () {}),
          const SizedBox(height: 16),
          _buildSelectableCard("Later", false, () {}),
          const SizedBox(height: 16),
          _buildSelectableCard("Just practicing", false, () {}),
        ],
      ),
    );
  }

  Widget _buildStudyPlanReveal() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.check(PhosphorIconsStyle.bold),
              color: AppColors.primaryDark,
              size: 48,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "Your plan\nis ready.",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  height: 1.05,
                  letterSpacing: -1.5,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            "We've customized your learning path based on your exam date. Stick to the route.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableCard(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        AppHaptics.selection();
        onTap();
      },
      child: AnimatedContainer(
        duration: AppMotion.quick,
        curve: AppMotion.standardEasing,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryDark
                : AppColors.textTertiary.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
                    ),
              ),
            ),
            if (isSelected)
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.primaryAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
