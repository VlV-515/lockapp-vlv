# Command Reference

Use these commands for both human and Codex workflows.

## Build

```bash
swift build
```

Compiles the debug SwiftPM executable.

## Package App

```bash
./scripts/package-app.sh
```

Creates and ad-hoc signs:

```text
dist/Lockapp-vlv.app
```

## Open Packaged App

```bash
open /Users/vlv/Sites/SideProjects/lockapp-vlv/dist/Lockapp-vlv.app
```

This launches the GUI app. Agents should only run it when explicitly asked.
