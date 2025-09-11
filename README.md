# Samgyup Serve

An ordering app for a Korean BBQ restaurant.

---

## Getting Started 🚀

### Prerequisites

- Flutter SDK (>=3.35.0)
- Make (for Bash/Linux/macOS users)
- PowerShell (for Windows users)

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
   ```powershell
   git clone https://github.com/dawnj26/samgyup_serve.git
   cd samgyup_serve
   ```
2. Install dependencies:
   ```powershell
   flutter pub get
   ```
   For packages, recursively get dependencies:
   ```powershell
   ./build.ps1 deps
   ```
3. Generate necessary files:
   ```powershell
   ./build.ps1 generate-only
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

```powershell
./build.ps1 release-stg
```

**Production:**

```powershell
./build.ps1 release-prod
```
