---
name: lockapp-vlv-development
description: Build and maintain the native macOS LockApp-vlv app.
---

Use this skill when editing LockApp-vlv source, packaging, settings, docs, or validation.

## Workflow

1. Read `AGENTS.md`, `.codex/project-brief.md`, and `.codex/rules/*.md`.
2. Keep changes scoped to the requested behavior.
3. Prefer native AppKit or SwiftUI APIs over external dependencies.
4. Validate with `swift build`.
5. Run `./scripts/package-app.sh` when packaging, app metadata, or launch behavior changes.
6. Commit focused milestones when requested or when creating the project from scratch.

## Product Boundaries

- Default password: `vlv`.
- Use one master password for both the menu panel and the lock overlay.
- No Touch ID, Bluetooth ID, Network ID, upgrade, or subscription features.
- Launch at login remains configurable.
- English default UI, Spanish (Mexico) optional.
