# Git and Validation

- Commit in focused milestones.
- Run `swift build` before source commits.
- Run `./scripts/package-app.sh` when changes affect bundle packaging or launch shape.
- Husky pre-commit runs `npm run build`.
- Do not push unless explicitly requested.
- Do not commit `.build/`, `.swiftpm/`, `dist/`, or `node_modules/`.
