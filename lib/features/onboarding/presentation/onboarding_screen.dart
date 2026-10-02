import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/motion/app_motion.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _nextPage() {
    if (_currentIndex < 3) {
      _pageController.nextPage(
        duration: AppMotion.expressive,
        curve: AppMotion.standardEasing,
      );
    } else {
      context.go('/home');
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
      backgroundColor: AppColors.primaryDark,
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
                text: _currentIndex == 3 ? "Let's Go" : "Continue",
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
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            PhosphorIcons.carProfile(PhosphorIconsStyle.fill),
            color: AppColors.primaryAccent,
            size: 64,
          ),
          const SizedBox(height: 24),
          Text(
            "Master the California Road.",
            style: Theme.of(context).textTheme.displayLarge
                ?.copyWith(color: AppColors.textInverse),
          ),
          const SizedBox(height: 16),
          Text(
            "The most efficient, modern way to pass your DMV written exam.",
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatPreparingFor() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What are you preparing for?",
            style: Theme.of(context).textTheme.displayMedium
                ?.copyWith(color: AppColors.textInverse),
          ),
          const SizedBox(height: 48),
          _buildSelectableCard("California Class C", true),
          const SizedBox(height: 16),
          _buildSelectableCard("Motorcycle", false),
          const SizedBox(height: 16),
          _buildSelectableCard("Commercial (CDL)", false),
        ],
      ),
    );
  }

  Widget _buildWhenIsTest() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "When is your test?",
            style: Theme.of(context).textTheme.displayMedium
                ?.copyWith(color: AppColors.textInverse),
          ),
          const SizedBox(height: 48),
          _buildSelectableCard("This week", false),
          const SizedBox(height: 16),
          _buildSelectableCard("1-2 weeks", true),
          const SizedBox(height: 16),
          _buildSelectableCard("Later", false),
          const SizedBox(height: 16),
          _buildSelectableCard("Just practicing", false),
        ],
      ),
    );
  }

  Widget _buildStudyPlanReveal() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
            color: AppColors.primaryAccent,
            size: 80,
          ),
          const SizedBox(height: 32),
          Text(
            "Your plan is ready.",
            style: Theme.of(context).textTheme.displayMedium
                ?.copyWith(color: AppColors.textInverse),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "We've customized your learning path based on your exam date.",
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableCard(String title, bool isSelected) {
    return AnimatedContainer(
      duration: AppMotion.quick,
      curve: AppMotion.standardEasing,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryAccent : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryAccent
              : AppColors.textTertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: isSelected
                    ? AppColors.primaryDark
                    : AppColors.textInverse,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
              color: AppColors.primaryDark,
            ),
        ],
      ),
    );
  }
}
