# Build Instructions 🏗️

Follow these steps to compile and build the final Release APK for TaskFlow.

## Prerequisites

Ensure you have the following installed on your machine:
1.  **Flutter SDK** (version 3.24.0 or higher).
2.  **Dart SDK** (comes bundled with Flutter).
3.  **Android Studio** with the Android SDK, SDK Command-line Tools, and SDK Build-Tools installed.
4.  A correctly configured **`ANDROID_HOME`** environment variable pointing to your Android SDK location (e.g., `C:\Users\<YourUser>\AppData\Local\Android\Sdk` on Windows or `~/Library/Android/sdk` on macOS).

## Step 1: Install Dependencies
Open a terminal in the root directory of the project and run:
```bash
flutter pub get
```

## Step 2: Code Generation (If necessary)
If you made any changes to the Isar Models or Riverpod Providers, you must run the build runner to regenerate the `.g.dart` files:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Step 3: Build the Release APK
To compile the highly optimized, obfuscated release APK, run the following command:
```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### Why use `--obfuscate`?
Obfuscation hides your Dart code symbols, making it significantly harder to reverse-engineer the application. The `--split-debug-info` flag saves the symbol map to the specified directory, allowing you to de-obfuscate crash logs later if needed.

## Step 4: Locate the APK
Once the build process completes successfully, the final APK will be located at:
```
<project-root>/build/app/outputs/flutter-apk/app-release.apk
```

You can now transfer this file to your Android device and install it.
