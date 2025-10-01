# Samgyup Serve

An ordering app for a Korean BBQ restaurant.

---

## Getting Started 🚀

### Prerequisites

- Flutter SDK (>=3.35.0)
- Melos, See [Melos Documentation](https://melos.invertase.dev/getting-started#installation) for installation instructions.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/dawnj26/samgyup_serve.git
   cd samgyup_serve
   ```
2. Bootstrap Melos:
   ```bash
   melos bootstrap
   ```
3. Install dependencies and generate necessary files:
   ```bash
   melos run generate
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

**Production:**

```bash
melos run release-prod
```
