# SourceForge Mirror Workflow

SourceForge is a secondary mirror for LockApp-vlv release assets. GitHub Releases remains the primary public download channel.

Default values:

- Username: `vlv`.
- Project name: `lockapp-vlv`.
- Remote host: `frs.sourceforge.net`.
- Remote folder: `/home/frs/project/lockapp-vlv/v1.1.0`.

## Prepare Local Mirror Folder

```bash
./scripts/prepare-sourceforge-release.sh 1.1.0
```

Expected folder:

```text
dist/sourceforge/v1.1.0/
```

Expected files:

```text
LockApp-vlv-1.1.0-macos-unsigned.zip
LockApp-vlv-1.1.0-macos-unsigned.zip.sha256
README-v1.1.0.md
```

## Publish

Only run this after SourceForge SSH access is configured and the host key has been verified.

```bash
./scripts/publish-sourceforge.sh 1.1.0 vlv lockapp-vlv
```

The script uses `ssh` and `scp`. It does not disable `StrictHostKeyChecking`.

If SSH is not ready, leave the local folder prepared and publish later with the same command.
