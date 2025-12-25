# Product Guidelines - Duplicate File Finder

## 1. Tone and Voice
- **Trustworthy & Cautious:** As the application handles file deletion, the language must be professional and unambiguous.
- **Clarity Over Brevity:** Explain *why* a file is being flagged and the consequences of its removal.
- **High-Friction Destructive Actions:** Operations like "Empty Trash" or "Batch Delete" must require clear user confirmation.

## 2. Visual Identity & UX
- **Native Experience:** Adhere to macOS and Windows design patterns (e.g., sidebars on Mac, standard toolbars on Windows).
- **Accessibility:** High contrast text and clear status indicators are mandatory.
- **Feedback Loops:** Use visual cues (icons and colors) to distinguish between files kept, marked for deletion, or skipped due to errors.
- **Platform Synergy:** Support OS-specific shortcuts (e.g., `Cmd + Backspace` vs `Delete`) and native appearance (Dark Mode).

## 3. Error Handling & Recovery
- **Fail Safe & Skip:** If a file cannot be accessed or deleted, log the error, skip it, and continue the batch operation.
- **Retry Mechanism:** Provide a clear "Retry Skipped Files" option after a batch operation finishes.
- **Safe State:** Never leave the file system in an ambiguous state; use the System Trash/Recycle Bin as a buffer.

## 4. Development & Contribution Standards
- **Atomic Commits:** Every commit must represent a single logical change. 
- **Commit Granularity:** Maintain an average of 5 files or less per commit to ensure high auditability and easier rollbacks.
- **Modernity:** Always use the most recent, stable architecture patterns and dependency versions (minimum 1 month post-release).
- **Automation First:** Every build or setup step must be automated to allow any contributor to start working on Mac or Windows with zero manual prerequisite installation where possible.
