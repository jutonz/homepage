---
name: upgrade-elixir
description: Upgrade this project's Elixir, Erlang/OTP, and Debian base image versions, split into a deps-prep PR and a version-bump PR.
allowed-tools: Read, Edit, Write, Bash, Grep, Glob
---

# Upgrade Elixir / Erlang / Debian

This project pins Elixir, Erlang/OTP, and the Debian base image in four
specific files. Bumping them across a major Elixir release usually fails the
build for reasons that have nothing to do with the version numbers themselves
— some hex dep uses syntax that was deprecated two releases ago, or a stdlib
function that's now been removed. The fix is mechanical once you know where
to look.

The job is to land the upgrade as **two stacked PRs** so each is small,
reviewable, and bisectable:

1. **deps prep PR** — backwards-compatible dep bumps and code migrations
   that fix things on the *new* Elixir without breaking the *current* one.
   Merge this first.
2. **version bump PR** — flips the four version pins. Stacked on (1), then
   rebased onto `main` after (1) merges.

Past examples in this repo: PRs [#4006](https://github.com/jutonz/homepage/pull/4006),
[#4253](https://github.com/jutonz/homepage/pull/4253) (deps prep), and
[#4255](https://github.com/jutonz/homepage/pull/4255) (version bump). Skim
one before starting so you know the shape of the diff.

## Step 1 — Pick target versions

Use `mise ls-remote` as the source of truth — it lists exactly what `mise`
can install, which is exactly what `.tool-versions` accepts.

```bash
mise ls-remote elixir | tail -30   # find latest 1.X.Y-otp-N
mise ls-remote erlang | tail -30   # find latest matching OTP N
```

Pick the latest stable `X.Y.Z-otp-N` Elixir (skip `-rc`s unless the user
asked) and the latest matching `N.x.y` Erlang. **The OTP majors must match.**
If Elixir's latest is `-otp-29`, Erlang must be `29.x.y`.

For the Debian base in the Dockerfile, find the newest dated `bullseye-*`
tag on Docker Hub:

```bash
curl -s "https://hub.docker.com/v2/repositories/library/debian/tags/?page_size=20&ordering=last_updated&name=bullseye" \
  | python3 -c "import json,sys; [print(t['name'],'-',t['last_updated']) for t in json.load(sys.stdin)['results']]"
```

Pick the most recent `bullseye-YYYYMMDD` (not `-slim`, not the rolling
`bullseye` tag — we want a pinned date).

**Verify the three-way combination exists on Docker Hub before editing
anything.** The `hexpm/elixir` image needs an exact tag matching all three:

```bash
TAG="1.20.1-erlang-29.0.2-debian-bullseye-20260610"   # substitute your versions
curl -sf "https://hub.docker.com/v2/repositories/hexpm/elixir/tags/${TAG}/" \
  | python3 -c "import json,sys; print('FOUND:', json.load(sys.stdin)['name'])" \
  || echo "NOT FOUND — pick a different Debian date and retry"
```

If the tag doesn't exist, walk the Debian date backwards a few entries until
you find one that does. hexpm tends to publish images for one Debian date
per Erlang point release.

## Step 2 — Update the four files

These are the *only* files that pin versions. Don't grep around looking for
others.

| File | What to change |
|---|---|
| `.tool-versions` | `elixir X.Y.Z-otp-N` and `erlang N.x.y` lines |
| `Dockerfile` | The `ARG ELIXIR_VERSION=`, `ARG OTP_VERSION=`, `ARG DEBIAN_VERSION=` lines at the top |
| `.github/workflows/elixir.yml` | The `env:` block with `ELIXIR_VERSION:` and `ERLANG_VERSION:` |
| `mix.exs` (repo root) | The `elixir: "~> X.Y"` line in `project/0` |

Note that `.tool-versions` uses `X.Y.Z-otp-N` (e.g. `1.20.1-otp-29`) while
the Dockerfile splits Elixir and OTP into separate ARGs. The CI workflow
uses bare version strings.

After editing `.tool-versions`, run `mise install` to actually fetch and
build the new Erlang/Elixir locally — without this, every subsequent
`mix` command runs against the *old* versions (or fails if mise is
configured to fail on missing tools). Erlang compiles from source so
expect this to take several minutes the first time.

```bash
mise install
```

## Step 3 — Surface dep fallout with `docker build`

Run a Docker build before touching deps — it's the fastest way to make every
dep recompile against the new BEAM and surface what breaks:

```bash
docker build -t homepage:elixir-upgrade-test .
```

Two categories of failure show up here.

### Category A — old syntax in a hex dep

The classic: Elixir 1.20 stopped accepting single-quoted strings (`'lib'`)
as a charlist that quacks like a string list. Any dep with a stale
`mix.exs` using the old syntax fails to compile. The error looks like:

```
** (Mix) :elixirc_paths should be a list of string paths, got: [~c"lib"]
```

The fix is to bump the dep to a version published after the author cleaned
this up. Find the latest on hex:

```bash
curl -s https://hex.pm/api/packages/<dep-name> \
  | python3 -c "import json,sys; [print(r['version']) for r in json.load(sys.stdin)['releases'][:8]]"
```

Update the constraint in the relevant `apps/*/mix.exs`, then:

```bash
mix deps.update <dep-name>
```

If `mix deps.update` complains about a transitive constraint (e.g.
"telemetry_poller 0.4 requires telemetry ~> 0.4 but websockex 0.5 needs
telemetry ~> 1.0"), unlock the conflicting transitives one at a time until
the resolver finds a solution:

```bash
mix deps.unlock telemetry telemetry_poller cowboy_telemetry
mix deps.update <dep-name>
```

Don't pre-emptively unlock everything — do it iteratively so you can see
exactly which deps moved and why.

### Category B — deprecated stdlib call in our code

Elixir 1.20 added a `--warnings-as-errors`-fatal deprecation for
`Logger.add_backend/1`. This project uses it for Sentry. Replace with the
modern OTP logger handler API:

```diff
-{:ok, _} = Logger.add_backend(Sentry.LoggerBackend)
+:logger.add_handler(:sentry_handler, Sentry.LoggerHandler, %{})
```

Future major releases will surface other deprecations the same way — read
the error, then read the Elixir changelog for that release. Don't paper
over deprecations with `Code.compiler_options(warnings_as_errors: false)`
or similar; the project CI runs `mix compile --warnings-as-errors` and you
need it clean.

## Step 4 — Verify locally

Run these in order. If any fail, fix before moving on.

```bash
mise exec -- mix deps.get               # must produce no diff in mix.lock
mise exec -- mix compile --warnings-as-errors
mise exec -- mix dialyzer               # PLT auto-rebuilds for the new OTP
mise exec -- mix test
docker build -t homepage:elixir-upgrade-test .
```

`mix exec --` is important on the first run: until you `cd` out and back in,
the shim cache may still resolve `elixir` to the old version. `mise exec --`
bypasses the cache.

`mix dialyzer` rebuilds the PLT against the new OTP modules — this takes a
minute or two but is automatic. If it fails with stale-PLT errors, delete
`_plts/` and rerun.

When you're done verifying, **delete the test Docker image** so it doesn't
linger:

```bash
docker rmi homepage:elixir-upgrade-test
```

## Step 5 — Split into two PRs

Now untangle the diff into the prep PR and the bump PR.

**Prep PR contents** (must be backwards-compatible with the *current* Elixir):

- Updates to `apps/*/mix.exs` (dep version constraints)
- `mix.lock` updates
- Any code migrations like the `Logger.add_backend` → `:logger.add_handler`
  swap. These are safe on the old Elixir too — `:logger.add_handler` is a
  standard OTP function that exists in every supported OTP version.

**Bump PR contents** (depends on prep PR being merged first):

- `.tool-versions`
- `Dockerfile`
- `.github/workflows/elixir.yml`
- `mix.exs` (the `elixir: "~> X.Y"` line)

The mechanics, assuming you've made all changes on a single working tree:

```bash
# Branch 1: deps prep
git checkout -b chore/bump-deps-for-elixir-X.Y main
git stash push -m "version-bump" -- \
  .tool-versions Dockerfile .github/workflows/elixir.yml mix.exs
# Verify on current Elixir that the deps changes still compile:
mise exec -- mix deps.get && mise exec -- mix compile --warnings-as-errors
git add -A && git commit -m "bump deps for elixir X.Y compatibility"
git push -u origin HEAD
gh pr create --base main --title "bump deps for elixir X.Y compatibility" --body "..."

# Branch 2: version bump, stacked on deps prep
git checkout -b chore/elixir-X.Y-otp-N
git stash pop
git add -A && git commit -m "upgrade to elixir X.Y.Z and erlang otp N.x.y"
git push -u origin HEAD
gh pr create --base chore/bump-deps-for-elixir-X.Y \
  --title "upgrade to elixir X.Y.Z and erlang otp N.x.y" --body "..."
```

**After the prep PR merges, the bump PR's base branch will be deleted** (if
the merge used `--delete-branch`, which is this repo's default). GitHub
auto-closes PRs whose base branch is deleted. Recover by rebasing onto the
new `main` and opening a fresh PR — GitHub can't reopen a PR whose base
no longer exists:

```bash
git fetch origin
git checkout main && git pull
git checkout chore/elixir-X.Y-otp-N
git rebase main
git push --force-with-lease
gh pr create --base main --title "..." --body "..."
```

Mention in the new PR's body that it supersedes the auto-closed one.

## Why two PRs

The prep PR can ride current CI (current Elixir, current Erlang) and prove
the dep bumps and code migrations don't regress anything. If something goes
wrong post-merge, revert is one PR, not two intertwined commits. The bump
PR then has a clean diff of *just* version pins — easy to review, easy to
revert, easy to bisect if the BEAM upgrade itself caused a subtle behavior
change weeks later.

Lumping it into one PR works too, but you give up the bisectability and
the reviewer has to mentally separate "is this dep bump correct?" from
"is this BEAM upgrade safe?" — two different questions deserving separate
attention.

## Quick reference: prior upgrade PRs

When in doubt, mimic the shape of a recent upgrade:

- Elixir 1.18 → 1.19: [#4006](https://github.com/jutonz/homepage/pull/4006)
- Elixir 1.19 → 1.20 prep: [#4253](https://github.com/jutonz/homepage/pull/4253)
- Elixir 1.19 → 1.20 bump: [#4255](https://github.com/jutonz/homepage/pull/4255)

`gh pr diff <num>` to see exactly what changed.
