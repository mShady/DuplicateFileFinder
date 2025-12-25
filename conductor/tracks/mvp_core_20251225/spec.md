# Specification: MVP - Core Scanning, Visualization, and Safe Deletion

## 1. Overview
The goal of this track is to implement the core functionality of the Duplicate File Finder app. This includes an optimized scanning engine, a responsive results UI, and a safe deletion workflow.

## 2. Functional Requirements
- **Directory Selection:** User can select a folder or drive to scan.
- **Optimized Scanning Engine:**
    - Stage 1: Filter by File Size.
    - Stage 2: 4KB Partial Content Hashing for size-matched files.
    - Stage 3: Full Content Hashing (SHA-256) for partial-hash matches.
- **Background Processing:** All scanning and hashing must happen in Dart Isolates.
- **Duplicate Visualization:**
    - Group files by their full hash.
    - Expandable/Collapsible groups.
    - Display file path, size, and modification date.
- **File Actions:**
    - "Reveal in Finder" (macOS) / "Open in Explorer" (Windows).
    - "Open File" using default system handler.
- **Safe Batch Delete:**
    - Mark multiple files for deletion.
    - Persistent footer showing selection count and total size.
    - Double confirmation dialog before execution.
    - Move files to System Trash/Recycle Bin via native platform channels.
- **Permissions:** Just-in-time permission requests for file access.

## 3. Technical Requirements
- **Framework:** Flutter (Desktop).
- **Concurrency:** Dart Isolates for scanning logic.
- **Storage:** SQLite (Drift) to store file metadata and scan results.
- **Platform Integration:** Native Swift (macOS) and C++ (Windows) for trash operations and shell actions.
- **Performance:** UI must remain responsive (>60 FPS) during heavy scans.

## 4. UI/UX Design
- Native-look UI using standard Flutter widgets for macOS/Windows.
- Progress dashboard during scanning (current file, progress bar, estimated time).
- High-contrast selection indicators.
