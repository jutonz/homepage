# Upgrade the Node runtime

Run this only when `check-versions.sh` reports node `BEHIND`. The target is the
`LATEST` column of that table, which is already the newest LTS.

Confirm mise can install the target, since mise is what consumes
`.tool-versions`:

```bash
mise ls-remote node | grep '^24\.'   # substitute the major you picked
```

## Edit the two runtime files

These are the only files that pin the runtime. CI reads the version from
`.tool-versions` through the `steps.versions.outputs.nodejs` mise step in
`.github/workflows/elixir.yml`, so CI needs no separate edit.

| File | Line |
|---|---|
| `.tool-versions` | `nodejs X.Y.Z` |
| `Dockerfile` | `ARG NODE_VERSION=X.Y.Z`, near the top |

`check-versions.sh` compares these two and reports a `MISMATCH` when they
disagree, so re-run it after the edit.

## Install

```bash
mise install
mise exec -- node --version   # must print the new version
corepack enable
```

Each Node install ships its own Corepack, and Corepack resolves the
`packageManager`-pinned Yarn. Run `corepack enable` after every Node install so
the Yarn shim belongs to the new runtime.

## Verify

```bash
.claude/skills/upgrade-node/scripts/verify-assets.sh
```

Then build the image, which exercises the `node_builder` stage against
`node:X.Y.Z` and is the real proof the pin resolves:

```bash
docker build -t testin . && docker rmi testin
```

Run the Docker build every time. It is slow and it is the only check that
proves the tag exists upstream. Confirm the log pulls `node:X.Y.Z` and that the
build exits 0.

## Stage

```bash
git add .tool-versions Dockerfile
```

A Node bump often leaves `@types/node` `BEHIND`, because its major tracks the
Node major. Re-run `check-versions.sh` afterward and handle it as its own
commit.
