# Upgrade Yarn

Run this only when `check-versions.sh` reports yarn `BEHIND`. The target is the
`LATEST` column of that table.

This repo manages Yarn through Corepack. There is no bundled release in
`.yarn/releases` and no `yarnPath`, so the whole change is one
`packageManager` line in `apps/client/assets/package.json`.

## Set the version

```bash
.claude/skills/upgrade-node/scripts/bump_node_dep.sh yarn X.Y.Z
```

The script runs `yarn set version`, which rewrites the `packageManager` line and
makes Corepack confirm the release exists. It then deletes any `.yarn/releases/`
or `yarnPath` that `yarn set version` writes, because this project relies on
Corepack to fetch Yarn, matching
[#4249](https://github.com/jutonz/homepage/pull/4249). Confirm the diff holds
the `packageManager` line alone.

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
