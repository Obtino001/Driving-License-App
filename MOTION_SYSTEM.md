# Motion System

## Philosophy
Motion is a core product feature. It communicates hierarchy, state, progress, feedback, navigation, and accomplishment. The app targets 60fps and avoids unnecessary rebuilds or expensive blur animations.

## 1. Motion Tokens (Durations)
- `quick`: `160ms` (Snappy interactions, color changes, hover states, toggles)
- `standard`: `280ms` (Card expansions, standard page transitions, sheet reveals)
- `expressive`: `420ms` (Score reveals, complex progress animations, full-page onboarding transitions)
- `hero`: `600ms+` (Reserved for major celebrations, test completion, milestone achievements)

## 2. Motion Curves
Flutter uses `Curves` class. We will use tasteful spring and ease curves.

- `standardEasing`: `Curves.easeOutCubic` (Elements entering the screen - fast in, slow out)
- `standardAccelerate`: `Curves.easeInCubic` (Elements exiting the screen - slow in, fast out)
- `springSubtle`: `SpringDescription(mass: 1, stiffness: 100, damping: 15)` (Button presses, quiz option selection)
- `springExpressive`: `SpringDescription(mass: 1, stiffness: 200, damping: 12)` (Score reveals, error shakes, dynamic list population)

## 3. Important Interactions

### 1. Button Press Feedback
- **Action**: Scale down slightly (to `0.97`) and adjust opacity/color on tap down.
- **Duration**: `quick`.
- **Curve**: `standardEasing`.

### 2. Quiz Option Selection
- **Action**: Selected card scales up slightly, border thickens, background color transitions.
- **Duration**: `quick`.
- **Curve**: `springSubtle`.

### 3. Answer Reveal (Correct/Incorrect)
- **Correct**: Card background pulses `success` color, checkmark scales in (`standard`).
- **Incorrect**: Card background flashes `danger`, subtle horizontal shake (`springExpressive`).

### 4. Explanation Panel Reveal
- **Action**: Panel slides up from below the options, fading in.
- **Duration**: `standard`.
- **Curve**: `Curves.easeOutQuint`.

### 5. Progress Indicator Updates
- **Action**: Active track width animates smoothly to the new percentage.
- **Duration**: `standard`.
- **Curve**: `Curves.easeOut`.

### 6. Test Completion Animation
- **Action**: Expressive hero animation. Large score text scales up (`expressive`), circular progress rings draw themselves, confetti/particles (if applicable) fire.

### 7. Bottom Navigation Transition
- **Action**: Fade through transition or subtle slide. 
- **Duration**: `standard`.

## 4. Performance & Accessibility Guidelines
- **Use `Transform` widgets** (Scale, Translate, Rotate) instead of animating layout constraints (width/height) when possible.
- **Avoid animating `BoxShadow`** or `BackdropFilter` frequently.
- **Respect Accessibility**: Check `MediaQuery.of(context).disableAnimations`. If true, bypass long/complex animations and instantly change states.
