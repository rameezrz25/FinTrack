# FinTrack

**FinTrack** is a modern, privacy-focused, offline-first portfolio tracking application built with Flutter. It helps you track your Net Worth across various asset classes (Stocks, Crypto, Gold, Real Estate, Loans, etc.) in a unified, beautiful interface.

## ✨ Features

-   **Cross-Platform**: Runs natively on macOS, Windows, Linux, iOS, Android, and Web from a single codebase.
-   **Privacy & Offline-First**: All data is stored locally using Hive. No servers, no tracking.
-   **Multi-Currency**: Toggle between USD and INR in real-time.
-   **Dynamic Dashboard**:
    -   **Grid Layout**: Beautiful, responsive grid view of asset categories.
    -   **Themes**:  Switch between **Light**, **Dark**, and **Sepia** modes.
    -   **Animations**: Smooth entry animations and micro-interactions.
-   **Comprehensive Asset Management**:
    -   Track Stocks, Crypto, Gold, Real Estate, Cash, Loans, and more.
    -   Calculate Profit/Loss automatically.
    -   Add assets directly from their category context.
    -   Track both Buy Price and Current Price.

## 🛠 Tech Stack

-   **Framework**: Flutter 3.x
-   **Language**: Dart
-   **State Management**: Flutter Riverpod
-   **Navigation**: GoRouter
-   **Local Database**: Hive (NoSQL)
-   **UI/UX**: Material 3, Google Fonts, Flutter Animate, Fl_Chart

## Prerequisites

-   [Flutter SDK](https://docs.flutter.dev/get-started/install) (Latest Stable)
-   **macOS**: Xcode (for macOS and iOS support)
-   **Windows**: Visual Studio 2022 with "Desktop development with C++" workload
-   **Linux**: CMake, Ninja, GTK development headers (e.g., `libgtk-3-dev`)

## Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/rameezrz25/FinTrack.git
    cd FinTrack
    ```

2.  **Navigate to the project directory:**
    ```bash
    cd fin_track
    ```

3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Generate code (Hive adapters, Riverpod providers):**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

## Running the App

### 🍎 macOS
```bash
flutter run -d macos
```

### 🪟 Windows
Enable Windows desktop support:
```bash
flutter config --enable-windows-desktop
```
Run the app:
```bash
flutter run -d windows
```

### 🐧 Linux
Enable Linux desktop support:
```bash
flutter config --enable-linux-desktop
```
Run the app:
```bash
flutter run -d linux
```

### 📱 Mobile (iOS & Android)
**iOS Simulator:**
```bash
open -a Simulator
flutter run -d iphone
```

**Android Emulator:**
```bash
flutter emulators --launch <emulator_id>
flutter run -d android
```

### 🌐 Web
```bash
flutter run -d chrome
```

## Project Structure
-   `lib/core`: Theme, constants, utils.
-   `lib/data`: Data persistence (Hive), repositories implementation.
-   `lib/domain`: Business entities, repository interfaces.
-   `lib/presentation`: Screens, widgets, state management (Riverpod).

## Key Commands
-   **Analyze code:** `flutter analyze`
-   **Run tests:** `flutter test`
-   **Build Release (macOS):** `flutter build macos --release`
