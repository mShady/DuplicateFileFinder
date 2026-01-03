# Specification: Error Reporting Enhancement

## 1. Overview
Current native action implementations (Move to Trash, Reveal in Finder) swallow exceptions in the Dart layer and return a simple boolean. This prevents the UI from showing meaningful error messages to the user (e.g., "Permission Denied", "File Not Found").

## 2. Requirements
- **Dart Layer:** Update `NativeActions` to throw specific exceptions or return a detailed Result object instead of `bool`.
- **Platform Layer:** Ensure native code (Swift/C++) returns structured error codes/messages.
- **UI:** (Future) Will need to handle these errors and display them.

## 3. Implementation Details
- Define a `NativeActionException` class with `code` and `message`.
- Update `moveToTrash` and `revealInFinder` to return `Future<void>` and throw `NativeActionException` on failure, or return `Future<Result<void, NativeError>>`.
