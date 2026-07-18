# LockApp-vlv Agent Guide

LockApp-vlv is a public native macOS utility. Treat it as a Swift/AppKit/SwiftUI project, not a web app.

## Start Here

- Read `.codex/project-brief.md` before planning product or architecture work.
- Read `.codex/rules/*.md` before editing source code.
- Use `.codex/skills/lockapp-vlv-development/SKILL.md` for implementation tasks.
- Use `.codex/agents/*.md` when spawning or role-playing specialized agents.

## Stack

- Swift Package Manager executable.
- AppKit lifecycle and menu bar integration.
- SwiftUI menu panel, preferences, and lock overlay.
- `NSWorkspace` application activation monitoring.
- `SMAppService` launch-at-login support.
- Keychain for passwords.
- `UserDefaults` for local preferences and protected app metadata.

## Commands

- `swift build`: compile debug build and validate source changes.
- `./scripts/package-app.sh`: create `dist/Lockapp-vlv.app` with a release build and ad-hoc signing.
- `open /Users/vlv/Sites/SideProjects/lockapp-vlv/dist/Lockapp-vlv.app`: launch packaged app only when explicitly requested.

Full command reference: `docs/commands.md`

## Git

This repo uses focused local commits. Do not push unless explicitly asked.

## Important Constraints

- Do not replace the native stack with Electron, Tauri, React, or a web UI.
- Keep user-facing app copy in English by default.
- Keep Spanish (Mexico) as an optional UI language.
- Do not add Touch ID, Bluetooth ID, Network ID, subscriptions, private gallery, or private notes unless explicitly requested later.
- Do not version generated build outputs: `.build/`, `.swiftpm/`, and `dist/` stay ignored.
- Do not run long-lived GUI commands in automation unless the user asks to open the app.

## Source Map

- `Sources/LockAppVLv/App`: app lifecycle, status item, packaging constants, overlay window coordination.
- `Sources/LockAppVLv/Core`: locked app model.
- `Sources/LockAppVLv/Services`: settings, Keychain, and app monitoring.
- `Sources/LockAppVLv/UI`: SwiftUI panel, preferences, and overlay views.
- `docs/architecture.md`: implementation overview.
