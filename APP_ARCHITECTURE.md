# App Architecture

## Overview
The application follows a Feature-First architecture to ensure scalability, maintainability, and clear separation of concerns.

## 1. Technical Stack
- **Framework**: Flutter
- **State Management**: Riverpod (for robust, reactive, and testable state management)
- **Navigation**: `go_router` (for declarative routing and deep linking capabilities)
- **Local Persistence**: Drift + SQLite (for offline-first capabilities, storing user progress and questions)
- **Models**: Freezed + `json_serializable` (for immutable data classes and JSON parsing)
- **Assets**: SVG (`flutter_svg`) + WebP (for optimized vector and raster graphics)

## 2. Directory Structure

```text
lib/
  main.dart             // Entry point
  app.dart              // MaterialApp configuration
  core/
    theme/              // Theme data, color tokens, text styles
    motion/             // Motion tokens, custom curves, animated widgets
    database/           // Drift database setup and DAOs
    routing/            // go_router configuration
    widgets/            // Shared UI components (buttons, cards, dialogs)
    utils/              // Helper functions, constants, extensions
  features/
    onboarding/
      presentation/     // Screens and widgets specific to onboarding
      application/      // Controllers and services
      domain/           // Entities and models
      data/             // Repositories
    home/
    learn/
    practice/
    exam/
    signs/
    mistakes/
    progress/
    settings/
```

## 3. Separation of Concerns
Each feature should ideally be self-contained and follow Clean Architecture principles loosely at the feature level:

- **Presentation**: Flutter widgets, Riverpod providers (`StateNotifierProvider` or `AsyncNotifierProvider`) acting as controllers. Contains UI logic.
- **Application (Services)**: Coordinates data flow between Presentation and Data layers. Contains business logic.
- **Domain**: Pure Dart classes, entities, enums. Independent of Flutter or external libraries.
- **Data (Repositories)**: Interfaces with external APIs or local databases (Drift). Returns domain models.

## 4. Offline First Strategy
- **Questions & User Data**: Stored entirely locally using Drift SQLite.
- **Syncing (Future)**: Repositories are designed with interfaces, allowing an easy swap or sync mechanism with Supabase later without affecting presentation logic.

## 5. Performance Guidelines
- Use `const` constructors aggressively.
- Keep widgets small and modular.
- Avoid large widget trees that rebuild entirely. Use granular Riverpod providers (`ref.watch(provider.select(...))`) to rebuild only what's necessary.
- Compress large images to WebP; use SVGs for UI icons and scalable illustrations.
