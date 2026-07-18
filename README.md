# LockApp-vlv

LockApp-vlv is a native macOS menu bar utility for blocking access to selected applications with an app-controlled password flow.

The first version is inspired by AppLocker behavior: a locked menu panel, a configurable list of protected apps, and a full-screen visual overlay when a protected app becomes active. The reference product listing describes password protection for individual apps and privacy-focused app locking; LockApp-vlv keeps the scope narrower by excluding Touch ID, Bluetooth ID, Network ID, subscriptions, private gallery, and private notes.

## Features

- Native Swift/AppKit/SwiftUI macOS app.
- Menu bar icon with the master password before showing protected apps.
- Protected application list selected from installed `.app` bundles.
- Opaque full-screen password overlay when a protected app becomes active.
- Master password prompt on the overlay without exposing the protected app name.
- Shortcut to close the protected application: `Shift + Option + Command + Esc`.
- Launch at login preference.
- Language preference: English by default, Spanish (Mexico) available with flag labels.
- Master password stored in Keychain.
- MIT licensed.

## Default Password

The master password starts as:

```text
vlv
```

You can change or reset the master password from Settings.

## Commands

```bash
swift build
./scripts/package-app.sh
open /Users/vlv/Sites/SideProjects/lockapp-vlv/dist/Lockapp-vlv.app
```

Only open the packaged app when you want to launch the GUI locally.

## Development

Install Husky once after cloning:

```bash
npm install
```

Husky runs `npm run build`, which maps to `swift build`, before each commit.

## Security Notes

LockApp-vlv is an overlay-based app blocker. It does not modify or sandbox other applications. A protected app can remain running behind the password screen, and the app can close it by calling the normal macOS termination API through the configured keyboard shortcut.

This project is suitable as a personal privacy utility and prototype. It is not a replacement for macOS account security, managed device controls, or enterprise endpoint protection.

## License

MIT
