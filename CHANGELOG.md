# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-07-26 - Production Release

### Added
- **Core Engine**: Fully implemented Isar NoSQL database for lightning-fast CRUD operations.
- **State Management**: Migrated entire app state to Riverpod `AsyncNotifier` for predictable, immutable state flows.
- **UI/UX**: Implemented full Material 3 design system with dynamic Dark/Light themes.
- **Animations**: Added `animations` package for Shared Axis page transitions.
- **Dashboard**: Interactive home screen with daily progress indicators.
- **Calendar**: Added `table_calendar` integration for visual task scheduling.
- **Statistics**: Integrated `fl_chart` for weekly productivity visualization.
- **Notifications**: Deployed `flutter_local_notifications` with timezone support and Exact Alarm permissions.
- **Background Actions**: Implemented headless isolates for "Snooze" and "Done" notification buttons.
- **Backup & Restore**: Added functionality to export/import raw `.isar` database files using `file_picker`.
- **Assets**: Generated and implemented high-quality, minimalistic app launcher icons and splash screens.

### Improved
- **Memory Footprint**: Migrated all static list rendering in `HomePage` to `SliverList.builder` to ensure 60fps scrolling on massive datasets.
- **Widget Tree**: Heavily optimized the widget tree using `const` constructors to prevent unnecessary repaints.
- **Manifest**: Hardened `AndroidManifest.xml` by stripping all non-essential permissions.

### Fixed
- Resolved all `flutter analyze` warnings, achieving a strict 0-issue codebase.
- Fixed `TextEditingController` memory leaks in `TaskFormPage`.

### Technical Notes
- Built using Flutter SDK v3.24+ and Dart 3.
- Production APK is configured for `--obfuscate` and `isShrinkResources = true`.
