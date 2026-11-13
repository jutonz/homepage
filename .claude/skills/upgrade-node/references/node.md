# Upgrade the Node runtime

Run this only when `check-versions.sh` reports node `BEHIND`. The target is the
`LATEST` column of that table, which is already the newest LTS.

Confirm mise can install the target, since mise is what consumes
`.tool-versions`:

```bash
mise ls-remote node X.Y.Z   # substitute the LATEST version
```

## Edit the two runtime files

```bash
.claude/skills/upgrade-node/scripts/bump_node_dep.sh node X.Y.Z
```

The script sets `.tool-versions` and the `ARG NODE_VERSION` line in
`Dockerfile`, the only two files that pin the runtime. CI reads the version from
`.tool-versions` through the `steps.versions.outputs.nodejs` mise step in
`.github/workflows/elixir.yml`, so CI needs no separate edit.

`check-versions.sh` compares these two and reports a `MISMATCH` when they
disagree, so re-run it after the edit.

## Install

```bash
mise install
mise exec -- node --version   # must print the new version
mise exec -- npm install --global corepack
mise exec -- corepack --version   # must print a version
```

Node 25 and later do not bundle Corepack. Each Node install needs its own
Corepack from npm, and that package links the `yarn` shim for the new runtime.
Corepack then resolves the `packageManager`-pinned Yarn. Run the npm install
after every Node install.

## Verify

```bash
.claude/skills/upgrade-node/scripts/verify-assets.sh
```

Then build the image, which exercises the `node_builder` stage against
`node:X.Y.Z` and is the real proof the pin resolves:

```bash
docker build -t testin . && docker rmi testin
```

Run the Docker build every time. It is the only check that proves the tag
exists upstream. Confirm the log pulls `node:X.Y.Z` and that the build exits 0.

## Stage

```bash
git add .tool-versions Dockerfile
```

A Node bump often leaves `@types/node` `BEHIND`, because its major tracks the
Node major. Re-run `check-versions.sh` afterward and handle it as its own
commit.
