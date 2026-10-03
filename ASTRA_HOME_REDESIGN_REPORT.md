# Astra Home redesign report

## Problems fixed

- Removed escaped Dart interpolation from Home, so readiness, mistakes, and daily progress show values.
- Replaced fixed, competing rows with constrained text and flexible layouts. A widget test found and fixed a recommendation action overflow at narrow widths.
- Removed the fabricated 12% starting readiness and three-day streak. Readiness now reflects explored questions across the ten learning categories. The daily goal reflects distinct questions whose latest answer was recorded today.
- Home reloads stored progress when users return from learning, practice, signs, or mistakes.
- Replaced the generic card grid and the old daily-goal layout.

## Visual decisions

- The asphalt hero is the screen's signature: a curved route, traveled lime segment, moving position marker, large editorial percentage, and restrained supporting copy.
- The screen now flows from status to a recommended topic, quick actions, today's goal, and a journey preview.
- Recommendation, sign, and mistake surfaces use different semantic colors while sharing typography, spacing, and restrained geometry.
- Outfit remains the typeface. Its numerical display and clear body text fit the existing identity.

## Motion decisions

- Central motion tokens now cover 100, 160, 260, 420, and 720 ms with controlled cubic curves.
- The hero count and road position animate together on entrance and value changes. The controller is disposed with the widget; reduced-motion settings bypass the sequence.
- Action surfaces have subtle press scaling. The daily progress track animates to a new value. Practice entry uses a 260 ms fade and small upward translation.

## Components created

- `ReadinessJourneyHero`, `RoadProgressPainter`, `TodayRecommendationCard`, `QuickActions`, `DailyGoalCard`, and `JourneyPreview`.

## Files modified

- `lib/features/home/presentation/home_screen.dart`
- `lib/features/home/presentation/widgets/home_sections.dart`
- `lib/features/home/presentation/widgets/road_progress_painter.dart`
- `lib/features/home/application/home_controller.dart`
- `lib/core/database/database_repository.dart`
- `lib/core/motion/app_motion.dart`
- `lib/core/widgets/app_button.dart`
- `lib/core/routing/app_router.dart`
- `test/home_layout_test.dart`

## Validation and performance

- Ran `dart format`, `flutter analyze` (no issues), and `flutter test` (all passed).
- Layout tests cover 360, 393, and 430 px widths at 1.3× text scale; readiness 0, 64, 99, and 100%; daily progress 0 and 10; 123 mistakes; a 123-day streak chip; and long topic names. No RenderFlex overflow remained in these checks.
- The road is painted from one path metric, wrapped in a repaint boundary, and animated only when needed. There are no looping decorative animations, blurs, or elevation effects.

## Remaining visual improvements

- A device screenshot review remains useful for tuning optical spacing and color on real displays. The supplied attachment contained the written brief but no image file.
- Historical answer events are not stored, so a trustworthy streak cannot yet be calculated. The chip stays hidden until real streak data exists.
- The daily goal uses the latest answer date per question. Repeating the same question is intentionally counted once.
