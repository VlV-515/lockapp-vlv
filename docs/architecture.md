# Architecture

LockApp-vlv is a Swift Package Manager executable packaged as a macOS `.app`.

## Runtime Shape

- `AppDelegate` owns lifecycle, status item, popover, settings window, app monitor, and overlay controller.
- `AppState` bridges SwiftUI views with persisted settings.
- `AppSettings` stores local preferences in `UserDefaults`.
- `KeychainPasswordStore` stores menu and master passwords in Keychain.
- `ApplicationMonitor` watches `NSWorkspace` activation changes and periodically checks the frontmost application.
- `LockOverlayController` creates one high-level overlay window per screen.

## Locking Model

The app does not inject into, modify, or sandbox other apps. It detects when a configured app is frontmost and places a full-screen overlay above it. Unlocking removes the overlay. Closing the protected app calls `terminate()` on the `NSRunningApplication`.

## Language Model

English is the default language. Spanish (Mexico) is available from Settings and affects app UI copy.
