---
name: upgrade-node
description: Upgrade this project's Node.js (to latest LTS) and/or Yarn (to latest 4.x stable), committing the change to the current branch.
---

# Upgrade Node.js / Yarn

This project pins Node and Yarn in three files total. The upgrades are
mechanical, but two things trip people up:

- **"Latest LTS Node" is not "highest version number."** Odd majors (25) are
  never LTS, and a fresh even major (26) isn't LTS until it's promoted months
  after release. You want the newest version whose `lts` field is set.
- **"Latest Yarn" is not what `npm view yarn version` says.** That command
  returns *classic* Yarn 1.x (1.22.x), which is a different, frozen product.
  This repo uses modern Yarn (the 4.x "berry" line) via the `packageManager`
  field. Pin from the `@yarnpkg/cli-dist` `latest` dist-tag instead.
- **`@types/node` tracks the Node *major*, not the "latest" tag.** Its major
  version mirrors the Node major (Node 24 → `@types/node` 24.x), so when you
  bump Node you must also resync `@types/node` to the newest release *in that
  major* — otherwise `npm` hands you a higher major (e.g. 25.x) that describes
  a runtime you aren't on. This is part of the Node upgrade, in the same PR.

Node and Yarn are independent — bumping one doesn't require the other. For
reference, the prior upgrades in this repo show the exact diff shape:

- Yarn 4.15.0 → 4.16.0: [#4249](https://github.com/jutonz/homepage/pull/4249) (one line)
- Node 24.15.0 → 24.16.0: [#4250](https://github.com/jutonz/homepage/pull/4250) (two files)

`gh pr diff 4249` / `gh pr diff 4250` to see them.

Make the change on whatever branch is currently checked out — commit there,
each upgrade as its own commit. If the user asks for only one of the two,
just do that one.

## Node upgrade

### Step 1 — Pick the target version

Find the newest **LTS** release. The `lts` field in the official dist index
is the source of truth — when it's a string (a codename like "Krypton"), that
release is LTS; when it's `false`, it isn't.

```bash
curl -s https://nodejs.org/dist/index.json \
  | python3 -c "import json,sys; d=json.load(sys.stdin); v=next(x for x in d if x['lts']); print(v['version'], v['lts'])"
```

That prints the single newest LTS version (e.g. `v24.16.0 Krypton`). Use that
`X.Y.Z` (drop the leading `v`).

Sanity-check it against what `mise` can actually install, since `.tool-versions`
is consumed by mise:

```bash
mise ls-remote node | grep '^24\.'   # substitute the major you picked
```

If the current pin already equals the latest LTS, say so and stop — there's
nothing to upgrade. (Don't jump to a non-LTS major just to produce a diff.)

### Step 2 — Edit the two runtime files

These are the only files that pin the Node runtime. CI reads the version from
`.tool-versions` (via the `steps.versions.outputs.nodejs` mise step in
`.github/workflows/elixir.yml`), so there's no separate CI version to touch.

| File | Line to change |
|---|---|
| `.tool-versions` | `nodejs X.Y.Z` |
| `Dockerfile` | `ARG NODE_VERSION=X.Y.Z` (near the top) |

### Step 3 — Install the new Node

```bash
mise install                      # fetch the new node locally
node --version                    # confirm it matches the new pin
corepack enable                   # re-wire the yarn shim for the new node
```

`corepack enable` matters because each Node install ships its own Corepack,
and Corepack is what resolves the `packageManager`-pinned Yarn. A fresh Node
without it leaves `yarn` either missing or still pointing at the old runtime's
shim — so the verify commands below would silently run on the wrong Node, or
fail outright with "command not found."

> The freshly-installed Node may not be on `PATH` in the current shell yet
> (the old shim can still win). Prefix the verify commands with `mise exec --`
> — e.g. `mise exec -- node --version` — so they actually run under the new
> runtime. Confirm `mise exec -- node --version` prints the new version before
> trusting any later check.
>
> **Run Yarn as `mise exec -- corepack yarn …`, not `mise exec -- yarn …`.**
> `corepack enable` writes the `yarn` shim into whichever Node is on `PATH` at
> the time — which is still the *old* install, since the new one isn't on
> `PATH` yet. So `mise exec -- yarn` resolves to a shim built for the old
> runtime (or fails outright with `"yarn" couldn't exec process: No such file
> or directory`). Going through Corepack directly — `mise exec -- corepack
> yarn install`, `mise exec -- corepack yarn typecheck` — always resolves the
> `packageManager`-pinned Yarn under the new Node. Use this `corepack yarn`
> form for every Yarn command in Steps 4 and 5 below.

### Step 4 — Resync `@types/node` to the new major

`@types/node`'s major must match the Node major you just installed. Find the
newest release *in that major* (substitute `24` for whatever major you're on):

```bash
cd apps/client/assets
mise exec -- corepack yarn npm info "@types/node" --json \
  | python3 -c "import json,sys; vs=[v for v in json.load(sys.stdin)['versions'] if v.startswith('24.')]; print(vs[-1])"
```

Set that as the `@types/node` caret range in `apps/client/assets/package.json`
(e.g. `"@types/node": "^24.13.2"`). If it already points at the right major,
there's nothing to change here. The `yarn install` in Step 5 picks up the new
range and `yarn typecheck` proves it didn't break the build.

### Step 5 — Verify

The frontend toolchain runs on Node, so the meaningful check is that the
assets still install, lint, typecheck, and build under the new version. From
`apps/client/assets/` (a plain `yarn install` so the lockfile absorbs the
`@types/node` change, then re-run `--immutable` to prove CI will pass):

```bash
cd apps/client/assets
mise exec -- corepack yarn install              # absorb the @types/node bump into yarn.lock
mise exec -- corepack yarn install --immutable  # must now pass clean (this is what CI runs)
mise exec -- corepack yarn lint --check
mise exec -- corepack yarn typecheck
mise exec -- corepack yarn bundle:css
MIX_ENV=prod mise exec -- corepack yarn bundle:js   # one-shot build; see below
```

**Build `bundle:js` with `MIX_ENV=prod`, otherwise it never exits and prints
nothing.** `bundle:js` (`scripts/compile_static.mjs`) branches on `MIX_ENV`:
the default (non-prod) path calls esbuild's `context().watch()`, which builds
once and then *stays running with zero output* — there's no "build finished"
line to wait for, so a foreground run just hangs and a backgrounded run leaves
an empty log. Setting `MIX_ENV=prod` takes the `build()` path instead, which
compiles once, prints the output bundle sizes plus `⚡ Done`, and exits 0 — a
real pass/fail signal. (`bundle:css` is plain `postcss` and exits on its own;
it prints nothing on success, which is fine.)

Then **always** run the Docker build, which exercises the `node_builder` stage
end-to-end against `node:X.Y.Z` and is the real proof the pin is valid (slower,
but don't skip it):

```bash
docker build -t testin . && docker rmi testin
```

Confirm the log shows it pulling `node:X.Y.Z` (grep the output for `node:24` or
your major) and that the build exits 0 before calling the upgrade verified.

### Step 6 — Commit

Commit on the current branch. The runtime bump and the `@types/node` resync are
each their own commit (the `@types/node` change carries `yarn.lock` with it):

```bash
git add .tool-versions Dockerfile
git commit -m "upgrade node to X.Y.Z"

git add apps/client/assets/package.json apps/client/assets/yarn.lock
git commit -m "match @types/node to installed node <major>.x"
```

## Yarn upgrade

### Step 1 — Pick the target version

Pin from the modern Yarn distribution, **not** the legacy `yarn` npm package:

```bash
curl -s https://registry.npmjs.org/@yarnpkg/cli-dist \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['dist-tags']['latest'])"
```

That prints the latest stable 4.x (e.g. `4.17.0`). If the current
`packageManager` field already equals it, there's nothing to do.

### Step 2 — Set the version

This repo manages Yarn through Corepack — there's no bundled release in
`.yarn/releases` and no `yarnPath`, so the entire change is the one
`packageManager` line in `apps/client/assets/package.json`. The clean way to
make that edit (and let Corepack verify the release exists) is:

```bash
cd apps/client/assets
yarn set version X.Y.Z --only-if-needed
```

That rewrites `"packageManager": "yarn@X.Y.Z"` for you. Editing the line by
hand produces an identical diff if you prefer. Either way, confirm the diff is
*just* that one line — if `yarn set version` also created `.yarn/releases/` or
a `yarnPath` entry, drop those; this project intentionally relies on Corepack
to fetch Yarn, matching [#4249](https://github.com/jutonz/homepage/pull/4249).

### Step 3 — Reinstall and verify

Run a plain `yarn install` (no `--immutable`) so the new Yarn writes any
metadata it owns into the lockfile — the `__metadata.version` / cache-key
fields can shift between Yarn releases. Letting the install regenerate the
lockfile now keeps it consistent and avoids a surprise failure in CI, which
runs `yarn install --immutable` and errors if the committed lockfile doesn't
already match.

```bash
cd apps/client/assets
yarn --version                    # should report the new version
yarn install                      # update yarn.lock to match the new Yarn
yarn install --immutable          # re-run: now it must pass with no changes
```

Most patch/minor bumps leave `yarn.lock` untouched, but don't assume it —
`git status` after the install tells you the truth. If `yarn.lock` did change,
commit it alongside `package.json`.

### Step 4 — Commit

Commit on the current branch. Include `yarn.lock` only if Step 3 actually
changed it:

```bash
git add apps/client/assets/package.json apps/client/assets/yarn.lock
git commit -m "upgrade yarn to X.Y.Z"
```

## Keep each upgrade its own commit

Node and Yarn are independent and each diff is tiny, so a separate commit per
upgrade keeps history easy to read and to revert or bisect later if some
subtle build behavior changes. Don't fold both into one commit.
