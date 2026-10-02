import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/motion/app_motion.dart';
import '../../../core/utils/haptics.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  int _currentIndex = 0;
  bool _isFlipped = false;

  final List<Map<String, String>> _dummySigns = [
    {
      'name': 'Stop',
      'meaning':
          'Come to a complete stop before the crosswalk or intersection.',
      'type': 'Regulatory',
    },
    {
      'name': 'Yield',
      'meaning': 'Slow down and be ready to stop to let any vehicle, bicyclist, or pedestrian pass.',
      'type': 'Regulatory',
    },
    {
      'name': 'No U-Turn',
      'meaning': 'You cannot make a U-turn in this location.',
      'type': 'Regulatory',
    },
  ];

  void _flipCard() {
    AppHaptics.selection();
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _nextCard() {
    AppHaptics.buttonPress();
    setState(() {
      _isFlipped = false;
      if (_currentIndex < _dummySigns.length - 1) {
        _currentIndex++;
      } else {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("Flashcards"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                "\${_currentIndex + 1}/\${_dummySigns.length}",
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.textTertiary),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedSwitcher(
                    duration: AppMotion.standard,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          final rotateAnim = Tween(
                            begin: pi,
                            end: 0.0,
                          ).animate(animation);
                          return AnimatedBuilder(
                            animation: rotateAnim,
                            child: child,
                            builder: (context, widget) {
                              final isUnder =
                                  (ValueKey(_isFlipped) != widget?.key);
                              var tilt =
                                  ((animation.value - 0.5).abs() - 0.5) * 0.003;
                              tilt *= isUnder ? -1.0 : 1.0;
                              final value = isUnder
                                  ? min(rotateAnim.value, pi / 2)
                                  : rotateAnim.value;
                              return Transform(
                                transform: Matrix4.rotationY(value)
                                  ..setEntry(3, 0, tilt),
                                alignment: Alignment.center,
                                child: widget,
                              );
                            },
                          );
                        },
                    child: _isFlipped
                        ? _buildBack(_dummySigns[_currentIndex])
                        : _buildFront(_dummySigns[_currentIndex]),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isFlipped ? _nextCard : _flipCard,
                  child: Text(
                    _isFlipped
                        ? (_currentIndex == _dummySigns.length - 1
                              ? "Finish"
                              : "Next Sign")
                        : "Reveal Answer",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFront(Map<String, String> sign) {
    return Container(
      key: const ValueKey(false),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.trafficSign(PhosphorIconsStyle.fill),
                size: 48,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "What does this sign mean?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack(Map<String, String> sign) {
    return Container(
      key: const ValueKey(true),
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                sign['type']!,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.textInverse),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              sign['name']!,
              style: Theme.of(context).textTheme.displaySmall
                  ?.copyWith(color: AppColors.primaryAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              sign['meaning']!,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppColors.textInverse),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
