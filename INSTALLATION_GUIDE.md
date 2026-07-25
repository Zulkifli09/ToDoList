# 📱 Installation & Build Guide

Since this source code requires an Android SDK to compile the final `.apk`, follow this guide to build and install **TaskFlow** on your local machine.

## 🛠️ Step 1: Prepare the Environment
1. Ensure you have **Flutter SDK** installed (v3.24+).
2. Ensure you have **Android Studio** installed along with the Android SDK.
3. Open your terminal and run `flutter doctor` to ensure there are no missing toolchains (especially the Android Toolchain).

## 🚀 Step 2: Build the Release APK
Navigate to the root directory of this project (`ToSoListApk`) in your terminal and run this exact command:

```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

This command will:
- Compile a highly optimized `release` build.
- Enable `isMinifyEnabled` and `isShrinkResources` (configured in `build.gradle.kts`) to remove unused code and assets.
- Obfuscate the Dart code to protect it from reverse engineering.

**Output Location:** Once finished, the APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

## 📲 Step 3: Install on Device
1. Transfer the `app-release.apk` to your Android device.
2. Tap the file to install it. You may be prompted to "Install from Unknown Sources".

## ⚙️ Step 4: System Configuration (Crucial for Notifications)

To ensure reminders fire exactly on time:

1. **Notification Permission**: When you set the first reminder, accept the prompt to allow notifications.
2. **Exact Alarms (Android 12+)**: Go to **Settings > Apps > TaskFlow > Alarms & reminders** and ensure it is **Allowed**. (The app requests this automatically).
3. **Battery Optimization**: If you are using a Xiaomi, Huawei, Samsung, or Oppo device, the OS might kill background processes.
   - Go to **Settings > Apps > TaskFlow > Battery**.
   - Change it to **Unrestricted** or **No Restrictions**.
