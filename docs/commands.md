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
./scripts/package-app.sh 1.1.0
```

Creates and ad-hoc signs:

```text
dist/Lockapp-vlv.app
```

The packaging step copies `Resources/AppIcon.icns` into the app bundle and declares it with `CFBundleIconFile`.

This app is ad-hoc signed only. It is not Developer ID signed and not notarized.

## Package Release

```bash
./scripts/package-release.sh 1.1.0
```

Creates:

```text
dist/LockApp-vlv-1.1.0-macos-unsigned.zip
dist/LockApp-vlv-1.1.0-macos-unsigned.zip.sha256
```

Verify from `dist`:

```bash
cd dist
shasum -a 256 -c LockApp-vlv-1.1.0-macos-unsigned.zip.sha256
```

## Prepare SourceForge Mirror

```bash
./scripts/prepare-sourceforge-release.sh 1.1.0
```

Creates `dist/sourceforge/v1.1.0/` with the ZIP, checksum, and release notes.

## Publish SourceForge Mirror

```bash
./scripts/publish-sourceforge.sh 1.1.0 vlv lockapp-vlv
```

Requires working SourceForge SSH access. The script keeps normal SSH host-key verification enabled.

## Open Packaged App

```bash
open /Users/vlv/Sites/SideProjects/lockapp-vlv/dist/Lockapp-vlv.app
```

This launches the GUI app. Agents should only run it when explicitly asked.
