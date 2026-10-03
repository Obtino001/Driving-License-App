# Astra core UX redesign report

## Quiz redesign

- Replaced the overflowing AppBar count and default progress bar with a compact question header and painted lane progress track.
- Questions now have editorial hierarchy, flexible answer cards, and a VisualScenario illustration slot. The slot collapses when no artwork exists and accepts SVG, raster assets such as WebP, or a future custom widget.
- Correct answers use a restrained success surface; wrong choices use a muted red surface and a four-pixel movement. The correct answer is highlighted after selection.
- The explanation expands within the scroll area, while the Next action stays at the bottom. Question changes use a short in-place fade and translation.
- Quiz loads the requested category before showing questions, avoiding a brief display of Road Rules when entering another topic.

## Learning journey redesign

- Replaced the generic card list with a connected vertical route and distinct completed, current, and upcoming states. All topics remain browsable.
- Added category line motifs, visible current progress, overall exploration summary, and a custom module detail sheet.
- The detail sheet shows practiced questions and answer accuracy from existing Drift progress records. Accuracy is shown as unavailable until an answer exists.
- Module progress reloads after returning from practice.

## Road Signs and Flashcards redesign

- Rebuilt Signs around a featured study mode, sign quiz entry, compact category filters, an editorial browse list, and an educational detail sheet.
- Added seven local study signs across Regulatory, Warning, Guide, Construction, and Railroad categories. Their artwork is scalable SVG; text labels are rendered by Flutter for reliable readability.
- Flashcards now share that catalog, with a controlled 260 ms flip, a visible study position, sign meaning, and a common mistake on the reverse side.
- The existing Traffic Signs practice route remains the Sign Quiz entry.

## Shared motion and visual primitives

- EditorialHeader: shared typography and contextual opening.
- RoadProgressTrack: animated, painted lane and position marker.
- VisualScenario: optional, format-aware illustration slot for practice questions.
- ModuleMotif, LearningRoutePainter, and sign SVG artwork: lightweight vector identity.
- Learn and Signs routes use the same restrained 260 ms fade and upward translation as Practice.
- Painters are isolated by repaint boundaries where appropriate. Animations stop after transitions; the flashcard controller is disposed.

## Bug and responsive fixes

- Removed escaped interpolation from Quiz, Learn, and Flashcards. A source search found no remaining escaped template expressions in lib.
- Removed the Quiz header overflow and fixed positioning of its explanation and CTA.
- Responsive widget tests cover 360, 393, and 430 px at 1.3× text scale, long question and answer copy, question 10 of 10, 100% module progress, long category names, sign filtering and detail, flashcard reveal, and Quiz feedback.
- Ran dart format, flutter analyze (no issues), and flutter test (all tests passed). No RenderFlex overflow appeared in these checks.

## Files changed

- lib/features/practice/presentation/practice_quiz_screen.dart
- lib/features/practice/application/practice_quiz_controller.dart
- lib/features/learn/presentation/learn_screen.dart
- lib/features/learn/presentation/module_motif.dart
- lib/features/learn/application/learn_controller.dart
- lib/features/signs/presentation/signs_screen.dart
- lib/features/signs/presentation/flashcards_screen.dart
- lib/features/signs/presentation/widgets/sign_artwork.dart
- lib/features/signs/domain/study_sign.dart
- lib/core/widgets/editorial_header.dart
- lib/core/widgets/road_progress_track.dart
- lib/core/widgets/visual_scenario.dart
- lib/core/database/database_repository.dart
- lib/core/routing/app_router.dart
- assets/signs/*.svg, pubspec.yaml, test/core_ux_layout_test.dart

## Remaining work

- Mistakes and Onboarding remain on the earlier visual system, as requested for this phase. There is currently no global bottom navigation component; navigation is route based.
- The Drift RoadSigns table has no seeded rows. The new sign catalog is local presentation content and can later be migrated into that table without changing the question schema.
- The Sign Quiz still uses the existing text based Traffic Signs questions. Adding question specific sign artwork is a future content pass.
- The supplied attachment contained the written brief but no screenshots. Device screenshot review remains useful for final optical tuning.
