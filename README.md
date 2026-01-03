# FinTrack

**FinTrack** is an offline-first portfolio tracking application built with Flutter. It helps you track your investments across various asset classes (Stocks, Crypto, Real Estate, etc.) with real-time profit/loss calculation.

## Features

-   **Multi-Asset Tracking**: Support for Stocks, Crypto, Gold, Real Estate, and more.
-   **Privacy Focused**: All data is stored locally on your device using Hive.
-   **Cross-Platform**: Runs on macOS, Windows, Linux, iOS, and Android.
-   **Analytics**: Dashboard with total net worth and portfolio allocation.

## Tech Stack

-   **Framework**: Flutter
-   **State Management**: Riverpod
-   **Database**: Hive (NoSQL)
-   **Navigation**: GoRouter
-   **UI**: Material 3

## Getting Started

1.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

2.  **Generate Code**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

3.  **Run the App**

    **macOS**
    ```bash
    flutter run -d macos
    ```

    **Windows**
    ```bash
    flutter config --enable-windows-desktop
    flutter run -d windows
    ```

    **Linux**
    ```bash
    flutter config --enable-linux-desktop
    flutter run -d linux
    ```

    **Web**
    ```bash
    flutter run -d chrome
    ```