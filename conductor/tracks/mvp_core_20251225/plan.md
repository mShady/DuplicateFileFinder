# Plan: MVP - Core Scanning, Visualization, and Safe Deletion

## Phase 1: Project Scaffolding & Automation [checkpoint: ea04eef]
- [x] Task: Initialize Flutter Desktop project for Mac and Windows. [d59edcf]
- [x] Task: Create `Makefile` with `setup`, `build`, and `test` commands. [b0b2cdf]
- [x] Task: Configure `analysis_options.yaml` with strict linting rules. [b93aac9]
- [x] Task: Implement basic navigation and window setup. [f1a42eb]
- [x] Task: Conductor - User Manual Verification 'Phase 1: Scaffolding' (Protocol in workflow.md)

## Phase 2: Local Storage & Native Integration [checkpoint: e02c88c]
- [x] Task: Set up Drift (SQLite) database schema for file metadata. [2ec89b5]
- [x] Task: Implement native platform channel for 'Move to Trash' (macOS/Swift). [1bc0649]
- [x] Task: Implement native platform channel for 'Move to Trash' (Windows/C++). [a580367]
- [x] Task: Implement native platform channel for 'Reveal in Finder/Explorer'. [f9ab58c]
- [x] Task: Conductor - User Manual Verification 'Phase 2: Data & Native' (Protocol in workflow.md)

## Phase 3: Optimized Scanning Engine
- [x] Task: Implement File System Walker in a Dart Isolate. [67dd5ab]
- [x] Task: Implement Stage 1: Size-based grouping and filtering. [76bd55e]
- [x] Task: Implement Stage 2: 4KB Partial Hashing logic in Isolate. [db65732]
- [x] Task: Implement file hashing logic (SHA-256) in Dart. [63d5159]
- [ ] Task: Implement scanning progress reporting to the UI.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Scanner' (Protocol in workflow.md)

## Phase 4: Results UI & Selection Logic
- [ ] Task: Build Expandable/Collapsible Duplicate Group UI components.
- [ ] Task: Implement Selection Summary footer with real-time size calculation.
- [ ] Task: Build the Double Confirmation dialog for batch deletion.
- [ ] Task: Connect UI actions to Scanning Engine and Native Trash logic.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: UI & Deletion' (Protocol in workflow.md)
