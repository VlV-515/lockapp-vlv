# macOS Native Rules

- Use AppKit for lifecycle, menu bar, windows, and system integrations.
- Use SwiftUI for app-owned views when practical.
- Use `SMAppService` for launch at login.
- Use `NSWorkspace` to observe frontmost app changes.
- Use Keychain for passwords.
- Do not require Xcode project files unless a future feature needs entitlements or signing configuration.
- Do not run `open .../Lockapp-vlv.app` unless explicitly requested.
