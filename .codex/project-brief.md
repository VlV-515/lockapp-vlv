# LockApp-vlv Project Brief

LockApp-vlv is a public native macOS menu bar utility for blocking selected applications behind an app-controlled password overlay.

## Goals

- Let users choose installed macOS applications to protect.
- Require the master password before showing the protected app list.
- Show a full-screen overlay when a protected app becomes active.
- Require a master password to remove that overlay.
- Avoid exposing the protected app name in the overlay.
- Allow closing the protected app with `Shift + Option + Command + Esc`.
- Support launch at login as a configurable setting.
- Keep UI copy in English by default.
- Support Spanish (Mexico) from Settings.
- Store the master password in Keychain.

## Non-Goals

- No Touch ID.
- No Bluetooth ID.
- No Network ID.
- No subscription or upgrade system.
- No private gallery.
- No private notes.
- No enterprise device management claims.
- No App Store publication workflow unless requested later.

## Current Implementation

- SwiftPM macOS executable named `Lockapp-vlv`.
- Packaged app display name `LockApp-vlv`.
- Menu bar accessory app.
- SwiftUI popover and settings window.
- AppKit full-screen overlay windows.
- `scripts/package-app.sh` creates `dist/Lockapp-vlv.app`.
