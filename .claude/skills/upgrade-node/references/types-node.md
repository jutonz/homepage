# Upgrade @types/node

Run this only when `check-versions.sh` reports `@types/node` `BEHIND`.

Its major mirrors the Node major, so npm's `latest` tag points at a runtime
this project does not run. The `LATEST` column already holds the newest release
inside the right major. This package drifts on its own, because DefinitelyTyped
ships between Node releases, so upgrade it whenever the table says `BEHIND`,
whether or not Node moved.

## Set the range

Set the caret range in `apps/client/assets/package.json`:

```json
"@types/node": "^24.19.0"
```

## Verify

```bash
.claude/skills/upgrade-node/scripts/verify-assets.sh
```

The install picks up the new range, and the typecheck inside that script proves
the new definitions still compile.

## Stage

```bash
git add apps/client/assets/package.json apps/client/assets/yarn.lock
```
