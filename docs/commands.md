# Command Reference

Use these commands for both human and Codex workflows.

## Build

```bash
swift build
```

Compiles the debug SwiftPM executable.

## Generate App Icon

```bash
./scripts/generate-app-icon.sh
```

Renders `Resources/AppIcon.png` and `Resources/AppIcon.icns` from the Swift drawing source used by the packaged app.

## Package App

```bash
./scripts/package-app.sh
```

Creates and ad-hoc signs:

```text
dist/Lockapp-vlv.app
```

The packaging step copies `Resources/AppIcon.icns` into the app bundle and declares it with `CFBundleIconFile`.

## Open Packaged App

```bash
open /Users/vlv/Sites/SideProjects/lockapp-vlv/dist/Lockapp-vlv.app
```

This launches the GUI app. Agents should only run it when explicitly asked.
