# Product Guide - Duplicate File Finder

## Vision
A high-performance desktop application for macOS and Windows designed to reclaim storage space by identifying and managing duplicate files. The app focuses on content-based identification to ensure absolute accuracy.

## Core Features
- **Byte-for-Byte Matching:** Detects strictly identical files by comparing content, ignoring filenames or metadata.
- **Flexible Scanning:**
    - Support for scanning the entire hard drive (including system/temp directories).
    - Targeted scanning for specific folders or drives.
- **Onboarding & Permissions:** Streamlined process to request necessary full-disk access permissions on macOS and Windows.
- **Smart Selection Engine:**
    - Automatically mark files for deletion based on:
        - Newest/Oldest files.
        - Path depth (keep simplest/shortest paths).
        - "Select all except oldest/newest" logic for quick bulk management.
- **Safe Deletion Workflow:**
    - **Batch Delete:** Mark multiple files and commit deletion in one action.
    - **System Integration:** Deleted files are moved to the System Trash (macOS) or Recycle Bin (Windows).
    - **Undo Support:** Clear guidance on how to restore files from the trash.

## User Experience & UI
- **Native Aesthetic:** Utilizes standard macOS and Windows UI controls to provide a familiar and trustworthy experience.
- **Real-time Feedback:**
    - **Background Scanning:** Results populate as they are found without locking the UI.
    - **Progress Dashboard:** Visual status of scan progress, time estimates, and the current directory being processed.
- **Performance:**
    - **Incremental Scanning:** Caches file signatures to speed up subsequent scans by only processing new or modified files.

## Technical Constraints
- **Privacy First:** 100% local processing; no data ever leaves the machine.
- **Cross-Platform Readiness:** Built with a tech stack that supports Mac and Windows today, with a clear path to mobile (Android/iOS) in the future.
- **Modernity:** Use the latest stable versions of dependencies (released >1 month ago) and modern architecture patterns.
- **Automation:** Fully automated setup and build process for Mac and Windows (no manual prerequisites).
- **Version Control:** Granular git commits (avg 5 files) for high traceability.