# Tech Stack - Duplicate File Finder

## 1. Core Framework & Language
- **Frontend/App Framework:** [Flutter](https://flutter.dev/) (Latest Stable)
- **Language:** Dart
- **Rationale:** Provides a high-performance, single-codebase solution for macOS and Windows with a native look and feel, and a seamless path to mobile (Android/iOS) in the future.

## 2. Architecture & Concurrency
- **Concurrency Model:** [Dart Isolates](https://api.dart.dev/stable/dart-isolate/Isolate-class.html)
- **Pattern:** Use dedicated background Isolates for heavy file-system walking and content hashing (CRC64 or SHA-256) to ensure the UI remains buttery smooth even during full-disk scans.
- **State Management:** Provider or Riverpod (latest) for reactive UI updates as duplicates are discovered.

## 3. Data Storage
- **Local Database:** [SQLite](https://sqlite.org/) via the [Drift](https://drift.simonbinder.eu/) (formerly Moor) library.
- **Rationale:** Drift provides a reactive, type-safe Dart API over SQLite, perfect for persisting file signatures, scan history, and user preferences locally.

## 4. Platform Integration (Native Operations)
- **Method:** [Native Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
- **macOS:** Swift implementation for Full Disk Access requests and `NSFileManager` trash operations.
- **Windows:** C++ implementation for Administrator elevation checks and `SHFileOperation` to safely move duplicates to the Recycle Bin.

## 5. Development & Automation (Local-First)
- **Task Runner:** [Makefile](https://www.gnu.org/software/make/)
- **Automation Goals:**
    - `make setup`: Automated environment check and dependency installation (`flutter pub get`, etc.).
    - `make build`: Platform-aware build commands for macOS and Windows.
    - `make test`: Executes all unit and widget tests locally.
- **Local CI/CD:** All validation, linting, and building logic is contained within the repository to ensure the project can be fully managed without reliance on external cloud runners like GitHub Actions.
