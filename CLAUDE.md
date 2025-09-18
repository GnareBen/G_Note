# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
g_task is a Flutter task management application implementing Clean Architecture with offline-first capability and background synchronization using SQLite and WorkManager.

## Development Commands

### Essential Commands
- `flutter pub get` - Install/update dependencies
- `flutter run` - Run in development mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter test` - Run all tests
- `flutter test test/path/to/test.dart` - Run specific test file
- `flutter analyze` - Run static analysis with flutter_lints

### Clean & Rebuild
- `flutter clean` - Clean build artifacts
- `flutter pub cache clean` - Clear pub cache if dependency issues

## Architecture Overview

The project follows Clean Architecture with three distinct layers:

### Domain Layer (`lib/features/tasks/domain/`)
- **Entities**: Core business objects (Task entity)
- **Use Cases**: Business logic operations (GetTasks, CreateTask, UpdateTask, DeleteTask, SyncTasks)
- **Repository Interfaces**: Abstract contracts for data operations

### Data Layer (`lib/features/tasks/data/`)
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**:
  - Local: SQLite implementation using sqflite
  - Remote: API client using Dio
- **Repository Implementation**: Coordinates local and remote sources, handles offline-first logic

### Presentation Layer (`lib/features/tasks/presentation/`)
- **BLoC**: TaskBloc manages all task-related state using flutter_bloc
- **Pages**: TasksListPage (main), TaskFormPage (create/edit)
- **Widgets**: Reusable UI components

## Key Technical Details

### State Management
Uses BLoC pattern with flutter_bloc. All task operations go through TaskBloc which emits states (TaskLoading, TaskLoaded, TaskError).

### Dependency Injection
Uses GetIt service locator initialized in `lib/injection_container.dart`. BLoCs are registered as factories, use cases and repositories as lazy singletons.

### Offline-First Synchronization
- Tasks have `is_synced` field tracking sync status
- Background sync runs hourly via WorkManager
- Manual sync available through app bar button
- Repository coordinates local writes with remote sync attempts

### Database Schema
SQLite table `tasks` with columns:
- id (TEXT PRIMARY KEY)
- title (TEXT)
- description (TEXT)
- is_completed (INTEGER 0/1)
- created_at (TEXT ISO8601)
- updated_at (TEXT ISO8601)
- is_synced (INTEGER 0/1)

### API Configuration
- Base URL: `http://192.168.1.64:8000/api`
- Tasks endpoint: `/tasks`
- 30-second timeout
- JSON content-type

### Error Handling
Uses Either type from dartz for functional error handling:
- ServerFailure, CacheFailure, NetworkFailure types
- Exceptions mapped to failures in repository layer
- BLoC converts failures to user-friendly error states

## Working with Features

When modifying or adding features:
1. Start with domain layer (entity, use case, repository interface)
2. Implement data layer (model, data sources, repository)
3. Add presentation layer (BLoC events/states, UI)
4. Register dependencies in injection_container.dart
5. Handle offline scenarios in repository implementation

## Testing Approach
Currently minimal tests. When adding tests:
- Unit test use cases with mock repositories
- Test BLoC with bloc_test package
- Widget test pages with mock BLoCs
- Integration test critical user flows