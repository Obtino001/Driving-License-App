# DriveWise: DMV Practice Test & Mock Simulator

Welcome to the **DriveWise** Flutter application repository! This app is designed to be a premium, modern, and highly polished driving theory test prep app, built with a focus on fast practice, smart analytics, and realistic mock tests.

## 📱 Overview

DriveWise helps users pass their driving theory and road signs tests by utilizing a smart mastery system that tracks their weaknesses. It feels like a mix of a modern fintech app and Duolingo, prioritizing beautiful UI/UX, smooth micro-interactions, and intelligent study recommendations over cluttered, traditional study apps.

### ✨ Key Features Built So Far:

1. **Premium Onboarding**
   - Clean, 4-step onboarding flow to set up user preferences, location, experience level, and daily goals.
2. **Personalized Home Dashboard**
   - A beautiful overview featuring "Continue Learning" progress cards, Weekly Activity charts, Daily Challenges, and quick actions for Mock Tests and Road Signs.
3. **Smart Practice & Mastery System**
   - Questions are categorized, and the app tracks exactly which questions the user gets wrong.
   - **Mastery Levels**: Questions progress from *New* → *Learning* → *Improving* → *Mastered* based on consecutive correct answers.
   - **Mistakes Dashboard**: Users can review their weak areas and practice specific questions they've failed.
4. **Realistic Mock Tests**
   - Timed simulation of the real driving test.
   - Beautiful Results breakdown showing accuracy, time taken, and a grid of passed/failed questions.
5. **Gamification & Retention**
   - Daily Streaks with fire animations.
   - Daily Goals tracking.
   - Leveling and XP tracking.
6. **Road Signs Library**
   - Categorized glossary of road signs, their meanings, and visual representations.
7. **Profile & Settings**
   - Fully featured settings page supporting Dark Mode toggles, notification preferences, sound/haptics, and data reset.
8. **Monetization Architecture**
   - Abstractions in place for `AdsService` and `SubscriptionService` so AdMob or RevenueCat can be plugged in later.
   - Premium upgrade screen with a clean feature comparison.

## 🏗️ Architecture & Tech Stack

This project strictly adheres to a **Clean Architecture** approach tailored for Flutter.

- **Framework**: Flutter
- **State Management**: Riverpod (`flutter_riverpod`)
- **Local Database**: SQLite (`sqflite`) for offline-first capabilities.
- **Routing**: Standard Navigator 2.0 / `MaterialPageRoute` (clean, predictable routing).

### Folder Structure
```text
lib/
├── app/                  # App shell and root widget
├── core/                 # Shared utilities, constants, themes, layout spacing
│   ├── config/           # AppConfig for multi-region Flavors
│   ├── data/             # Database seeder and LocalDatabase instance
│   ├── theme/            # Colors, typography, spacing (8pt system)
│   └── utils/            # Pure logic calculators (Streak, Mastery)
└── features/             # Feature-first modules
    ├── home/             # Dashboard, Quick Actions, Weekly Progress
    ├── mock_test/        # Mock test logic, timer, and results UI
    ├── onboarding/       # Setup screens
    ├── practice/         # Question models, Quiz UI, Mistakes dashboard, Repositories
    ├── premium/          # Upsell UI
    ├── profile/          # Settings and user stats
    ├── progress/         # Global progress tracking
    └── road_signs/       # Flashcards and sign categories
```

## 🌍 Multi-Region White-labeling

The app is built to be launched across multiple regions (e.g., US States, UK DVLA, Canada) **using the exact same codebase**. 

- Uses **Dart Defines** to inject the region at build time.
- Data is seeded from `assets/data/<region>/` JSON files dynamically.
- To build the UK version, use:
  ```bash
  flutter run --dart-define=REGION=uk
  ```
- To build the default generic US version, use:
  ```bash
  flutter run --dart-define=REGION=us_generic
  ```

## 🧪 Testing Infrastructure

The app is thoroughly tested to ensure production readiness:
- **Unit Tests**: Full coverage for pure business logic like `StreakCalculator`, `MasteryCalculator`, `QuizSessionNotifier`, and `MockTestNotifier`.
- **Widget Tests**: Screen rendering, layout constraint validation (preventing `RenderFlex` overflows), and user interaction simulation for `HomeScreen`, `MockTestSessionScreen`, and `QuizSessionScreen`.

## 🚀 What's Next?
- Integrate real AdMob and Billing credentials.
- Add Road Sign Quiz interactive components.
- Prepare regional question packs (JSON files) for store variants.
