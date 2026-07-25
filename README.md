# TaskFlow 🚀

<div align="center">
  <h3>The Ultimate Offline-First Productivity App</h3>
  <p>Minimalist. Secure. Blazing Fast.</p>
</div>

---

## 📖 Project Overview
TaskFlow is a production-grade Android application built with Flutter. Designed for professionals who value speed, privacy, and aesthetics, TaskFlow operates entirely offline using an embedded NoSQL database. It features a stunning Material 3 interface, smart background notifications, and comprehensive productivity analytics.

## ✨ Features
*   **Offline-First Core**: 100% local data storage powered by Isar Database. No cloud, no tracking.
*   **Premium Material 3 UI**: Clean, rounded aesthetics with dynamic Shared Axis Transitions and dark mode support.
*   **Smart Background Notifications**: Schedule exact alarms that survive device reboots. Includes lock-screen "Snooze" and "Done" actions.
*   **Interactive Calendar Grid**: Visualize your daily workload instantly.
*   **Productivity Analytics**: Animated charts tracking your daily and weekly task completion rates.
*   **Complete Data Ownership**: Export your entire database to a secure `.isar` file and restore it seamlessly on any device.

## 🏗️ Architecture
TaskFlow strictly follows **Clean Architecture**:
*   **Domain Layer**: Contains immutable `TaskModel` and abstract repository interfaces.
*   **Data Layer**: Implements `IsarTaskRepository` and raw database initializations.
*   **Presentation Layer**: Utilizes `Riverpod` (`AsyncNotifier`) for state management and `go_router` for declarative navigation.
*   **Services Layer**: Handles platform channels for local notifications and file system backups.

## 📁 Folder Structure
```text
lib/
├── core/             # Routing, Themes, and Global Providers
├── data/             # Local Isar DB & Repository Implementations
├── domain/           # Models and Repository Interfaces
├── features/         # Feature-based split (Home, Task, Calendar, Settings)
└── services/         # Notification & Backup Services
```

## 📦 Dependencies
- `flutter_riverpod` (State Management)
- `go_router` (Navigation)
- `isar` & `isar_flutter_libs` (NoSQL Database)
- `flutter_local_notifications` (Background Alarms)
- `timezone` (Alarm Scheduling)
- `animations` (Shared Axis Transitions)
- `fl_chart` (Analytics Data Visualization)
- `table_calendar` (Calendar Grid)

## 📲 Installation & Build Instructions
*(Note: To build this project, you must have Android Studio and the Android SDK installed, with `ANDROID_HOME` configured in your system environment variables).*

1. **Clone the repository.**
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run code generation (if modifying models):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **Compile the highly-optimized Release APK:**
   ```bash
   flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
   ```
5. **Install on device:** The final APK will be located at `build/app/outputs/flutter-apk/app-release.apk`. Transfer this file to your Android device to install.

## 🔔 How Notifications Work
TaskFlow uses a headless background isolate. When an alarm triggers, or when you press "Snooze" from the lock screen, the background isolate temporarily spins up an `Isar` instance, modifies the task's reminder timestamp, and reschedules the exact alarm without bringing the app into the foreground.

## ⚠️ Known Limitations
- **Aggressive Battery Managers**: Devices running MIUI (Xiaomi), EMUI (Huawei), or ColorOS (Oppo) may forcefully kill the notification listener. Users must manually set the app battery settings to "Unrestricted" to guarantee alarm precision.

---
*Built with ❤️ using Flutter.*
