import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/motion/app_motion.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/road_progress_track.dart';
import '../domain/study_sign.dart';
import 'widgets/sign_artwork.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flip;
  int _index = 0;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _flip = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  void _toggleReveal() {
    AppHaptics.selection();
    final next = !_revealed;
    setState(() => _revealed = next);
    if (MediaQuery.disableAnimationsOf(context)) {
      _flip.value = next ? 1 : 0;
    } else if (next) {
      _flip.forward();
    } else {
      _flip.reverse();
    }
  }

  void _advance() {
    AppHaptics.buttonPress();
    if (_index == studySigns.length - 1) {
      context.pop();
      return;
    }
    _flip.value = 0;
    setState(() {
      _index++;
      _revealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sign = studySigns[_index];
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Close flashcards',
                    onPressed: () => context.pop(),
                    icon: Icon(PhosphorIcons.x()),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'SIGN STUDY',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 11,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${_index + 1} / ${studySigns.length}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              RoadProgressTrack(progress: (_index + 1) / studySigns.length),
              const SizedBox(height: 20),
              Expanded(
                child: Semantics(
                  button: true,
                  label: _revealed
                      ? 'Hide sign meaning'
                      : 'Reveal sign meaning',
                  child: GestureDetector(
                    onTap: _toggleReveal,
                    child: AnimatedBuilder(
                      animation: _flip,
                      builder: (context, _) {
                        final t = AppMotion.standardEasing.transform(
                          _flip.value,
                        );
                        final back = t >= .5;
                        final angle = back ? (t - 1) * math.pi : t * math.pi;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, .0007)
                            ..rotateY(angle),
                          child: _SignFlashcardFace(sign: sign, revealed: back),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                text: !_revealed
                    ? 'Reveal meaning'
                    : _index == studySigns.length - 1
                    ? 'Finish study  →'
                    : 'Next sign  →',
                onPressed: _revealed ? _advance : _toggleReveal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignFlashcardFace extends StatelessWidget {
  const _SignFlashcardFace({required this.sign, required this.revealed});
  final StudySign sign;
  final bool revealed;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: revealed ? AppColors.primaryDark : AppColors.surface,
      borderRadius: BorderRadius.circular(21),
      border: revealed ? null : Border.all(color: const Color(0xFFDDE2DA)),
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 340),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sign.category.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: revealed
                    ? AppColors.primaryAccent
                    : AppColors.textSecondary,
                fontSize: 11,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 28),
            SignArtwork(sign: sign, size: revealed ? 128 : 170),
            const SizedBox(height: 28),
            if (!revealed) ...[
              Text(
                'What does this sign mean?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to reveal',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ] else ...[
              Text(
                sign.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge
                    ?.copyWith(color: AppColors.surface, fontSize: 27),
              ),
              const SizedBox(height: 9),
              Text(
                sign.meaning,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xFFE1E8DF)),
              ),
              const SizedBox(height: 20),
              Text(
                'WATCH FOR THIS',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primaryAccent,
                  fontSize: 10,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                sign.commonMistake,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: const Color(0xFFD0DACF)),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
