# Upgrade Yarn

Run this only when `check-versions.sh` reports yarn `BEHIND`. The target is the
`LATEST` column of that table.

This repo manages Yarn through Corepack. There is no bundled release in
`.yarn/releases` and no `yarnPath`, so the whole change is one
`packageManager` line in `apps/client/assets/package.json`.

## Set the version

```bash
cd apps/client/assets
yarn set version X.Y.Z --only-if-needed
```

That rewrites `"packageManager": "yarn@X.Y.Z"` and makes Corepack confirm the
release exists. Editing the line by hand gives an identical diff.

Confirm the diff holds that one line alone. When `yarn set version` also writes
`.yarn/releases/` or a `yarnPath` entry, delete both: this project relies on
Corepack to fetch Yarn, matching
[#4249](https://github.com/jutonz/homepage/pull/4249).

## Verify

```bash
.claude/skills/upgrade-node/scripts/verify-assets.sh
```

The plain `yarn install` inside that script lets the new Yarn rewrite the
`__metadata.version` and cache-key fields it owns, and the `--immutable` run
that follows proves CI will accept the result.

## Stage

Most patch and minor bumps leave `yarn.lock` alone. Run `git status` to see
which happened, and stage the lockfile when it changed.

```bash
git add apps/client/assets/package.json apps/client/assets/yarn.lock
```
