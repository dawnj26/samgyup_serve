# Samgyup Serve

An ordering app for a Korean BBQ restaurant.

---

## Getting Started 🚀

### Prerequisites
 - Flutter SDK (>=3.35.0)
 - Make (for Bash/Linux/macOS users)

### Installation

#### For Bash/Linux/macOS
1. Clone the repository:
   ```bash
   git clone https://github.com/dawnj26/samgyup_serve.git
   cd samgyup_serve
   ```
2. Install dependencies and generate necessary files:
   ```bash
   make generate
   ```

#### For Windows
1. Clone the repository:
   ```cmd
   git clone https://github.com/dawnj26/samgyup_serve.git
   cd samgyup_serve
   ```
2. Install dependencies:
   ```cmd
   flutter pub get
   ```
   For packages, recursively get dependencies:
   ```cmd
   for /d %i in (packages\*) do if exist "%i\pubspec.yaml" (cd /d "%i" && flutter pub get && cd /d "%~dp0")
   ```
3. Generate necessary files:
   ```cmd
   dart run build_runner build --delete-conflicting-outputs
   ```
   For packages with build_runner, recursively generate:
   ```cmd
   for /d %i in (packages\*) do if exist "%i\pubspec.yaml" (findstr /C:"build_runner:" "%i\pubspec.yaml" >nul && (cd /d "%i" && dart run build_runner build --delete-conflicting-outputs && cd /d "%~dp0"))
   ```

### Running the App
1. Connect a device or start an emulator.
2. Run the app with your preferred flavor:

   **Development:**
   ```bash
   flutter run --flavor development --target lib/main_development.dart
   ```

   **Staging:**
   ```bash
   flutter run --flavor staging --target lib/main_staging.dart
   ```

   **Production:**
   ```bash
   flutter run --flavor production --target lib/main_production.dart
   ```

### Building the App
To build the app for a specific flavor, use the following commands:

#### For Bash/Linux/macOS
   **Staging:**
   ```bash
   make release-stg
   ```

   **Production:**
   ```bash
   make release-prod
   ```

#### Windows
   **Staging:**
   ```bash
   flutter build apk --split-per-abi --flavor staging --target lib/main_staging.dart
   ```

   **Production:**
   ```bash
   flutter build apk --split-per-abi --flavor production --target lib/main_production.dart
   ```
