---
name: upgrade-phoenix
description: Use when on a dependabot branch that bumps phoenix, phoenix_html, or phoenix_live_view — any package published as both a hex package and an npm package, where dependabot has moved only one half and the two are now out of step.
allowed-tools: Read, Edit, Write, Bash, Grep, Glob, WebFetch, WebSearch
---

# Upgrade the Phoenix stack

Three of this repo's dependencies ship as two coupled halves: a **hex
package** (the server) and an **npm package** (the JS client). Each pair is
published in lockstep — for `phoenix` 1.8.13, hex and npm went out two
minutes apart — and the halves speak a shared wire protocol. They must be
pinned to the *same* version. A mismatch means client and server disagree
over the wire, and you get subtle, hard-to-debug breakage in production.

Dependabot only ever bumps one half at a time. So the core job of this skill
is: figure out which *pair* a branch bumped and which *half*, bring the other
half up to the same version, install both, commit the sync, then read the
upstream changelog and hand back a risk-rated report the user can act on.

Invoked manually on a dependabot branch.

## The three pairs

Everything package-specific lives in this table. The phases below are
identical whichever row you are on.

| Pair | npm key in `apps/client/assets/package.json` | hex dep in `apps/client/mix.exs` | JS surface to grep | Extra check |
|---|---|---|---|---|
| `phoenix` | `"phoenix"` | `{:phoenix, "1.8.13"}` — **exact pin** | `Socket`, `.channel(` | — |
| `phoenix_html` | `"phoenix_html"` | `{:phoenix_html, "~> 4.3.0"}` — range | imports from `phoenix_html` | — |
| `phoenix_live_view` | `"phoenix_live_view"` | `{:phoenix_live_view, "~> 1.2.3"}` — range | `LiveSocket`, `Hooks`, `phx-` | `mix format --check-formatted` |

Resolved hex versions live in `mix.lock` at the repo root; resolved npm
versions in `apps/client/assets/yarn.lock`.

The **constraint style column records what was there when this skill was
written — always re-read the actual line.** Whether it is an exact pin or a
`~>` range changes what phase 2 has to edit, and constraints get retightened
over time.

`phoenix_live_view`'s extra check exists because the root `.formatter.exs`
loads `plugins: [Phoenix.LiveView.HTMLFormatter]`, so a LiveView bump can
silently reformat every `.heex` file in the repo.

Work through the phases below in order. Use a todo list so nothing is
skipped — the value here is in doing the boring sync + verification so the
user doesn't have to.

## 1. Detect the pair and the half — on the branch's own commits

**Gotcha that will bite you:** dependabot branches are frequently *behind*
`main`. A raw `git diff main` then shows main's newer, unrelated deps as if
*this* branch removed them — total noise. Always diff against the merge base
so you see only what this branch actually changed:

```bash
BASE=$(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main)
git diff "$BASE"...HEAD --stat
git diff "$BASE"...HEAD -- apps/client/assets/package.json mix.lock apps/client/mix.exs
```

Classify from that diff:

- Touches `apps/client/assets/package.json` / `yarn.lock` → **frontend** bump.
- Touches root `mix.lock` (and often `apps/client/mix.exs`) → **backend** bump.

Read the **old** and **new** versions straight out of the diff, and note which
of the three pairs moved. The new version is the **target `T`** that both
halves must land on.

`phoenix` is usually backend-initiated (dependabot tracks hex), while
`phoenix_live_view` is usually frontend-initiated. Don't assume either —
read the diff.

If the branch isn't a bump of one of the three pairs, if it bumps more than
one pair at once, or if the tree is dirty / you're not on the bump branch,
stop and say so rather than guessing.

## 2. Sync the other half to `T`

Both halves must equal `T` exactly. Bump whichever one dependabot left behind.

### Backend bump (mix.lock is at `T` — sync the frontend)

- **Verify `T` exists on npm before editing anything.** The halves publish in
  lockstep but not atomically, and npm additionally carries parallel `1.5.x` /
  `1.6.x` / `1.7.x` lines for `phoenix`, so npm's `latest` tag is *not* a safe
  target. `T` comes from the branch diff, never from `latest`:

  ```bash
  curl -s "https://registry.npmjs.org/<npm_key>" \
    | python3 -c "import json,sys; print('<T>' in json.load(sys.stdin)['versions'])"
  ```

  If that prints `False`, npm hasn't published `T` yet. Stop and report it —
  do not substitute a nearby version.
- Set the pair's key in `apps/client/assets/package.json` to `T` exactly.

### Frontend bump (package.json is already at `T` — sync the backend)

Read the constraint in `apps/client/mix.exs` and branch on its style:

- **Exact pin** (e.g. `{:phoenix, "1.8.13"}`) — you must **always** edit it to
  `T`. There is no range to absorb the bump.
- **`~>` range** (e.g. `{:phoenix_live_view, "~> 1.2.3"}`) — edit only if `T`
  crosses the ceiling (constraint `~> 1.2.3`, `T` is `1.3.0` → bump to
  `~> 1.3.0`). A patch or minor bump *inside* the range needs no edit.

Then move the lock **surgically**:

```bash
mix deps.unlock <pkg> && mix deps.get
```

Do *not* use `mix deps.update <pkg>` — on a dependabot branch whose lock is
behind the registry it re-resolves the whole tree and drags **unrelated
siblings** up with it, polluting the diff.

It's fine — expected — for the package's *own* transitive deps to move if the
new version genuinely requires it; that's part of the upgrade, and the user is
OK with transitive-dep bumps. What you're avoiding is packages that move
*only* because the branch lock is stale. Tell the two apart with the dep tree:

```bash
mix deps.tree            # read the indentation; do not grep it away
```

Indentation encodes depth, and **the same package can appear at more than one
depth** — grepping for a name alone throws away the answer you need. Three
cases, not two:

- **Nested under `<pkg>` only** → genuine transitive, may float.
- **Under a different parent only** → unrelated sibling; it must not move.
  (`cowboy`/`cowlib` sit under `plug_cowboy`, the web-server adapter, not
  under any of these three, so these bumps leave them alone.)
- **Both at once** → judge by whether the *new* `<pkg>` requires the version
  it moved to. Seen in practice on the `phoenix` 1.8.13 branch:

  ```
  │   ├── phoenix_pubsub ~> 2.1   <- transitive, required by phoenix
  ├── phoenix_pubsub ~> 2.0       <- also a direct dep in mix.exs
  ```

  `phoenix_pubsub` moving 2.2.0 → 2.3.0 there is legitimate: phoenix asks for
  `~> 2.1` and the direct constraint `~> 2.0` permits it. Say so in the report
  rather than flagging it as pollution.

`deps.unlock <pkg>` + `deps.get` produces exactly this — it moves the package
and whatever it genuinely requires, and nothing else.

Confirm `mix.lock` shows **exactly `T`** and that only `<pkg>` (plus genuine
transitives) moved. If it overshot to a newer patch published since, pin the
constraint tighter (`~> T`, or the exact `T`) so the halves match, and flag it.

### Check the pair's dependents (both directions)

All three pairs have other deps constraining them, so a minor or major bump
can violate a constraint the lock still satisfies only by luck. Confirm `T`
still satisfies every dependent:

```bash
grep -oE '\{:<pkg>, "[^"]*"' mix.lock | sort -u
```

That lists every constraint any dep places on `<pkg>`; check `T` against each
by hand. Remember Elixir's `~>` arity: two-segment `~> 1.4` means
`>= 1.4.0 and < 2.0.0`, three-segment `~> 1.8.0` means `>= 1.8.0 and < 1.9.0`.

For example `phoenix` is constrained by `phoenix_live_view`
(`~> 1.6.15 or ~> 1.7.0 or ~> 1.8.0`), `phoenix_ecto`, and
`phoenix_live_dashboard`; `phoenix_live_view` is constrained by `sentry`
(`~> 0.20 or ~> 1.0`) and `phoenix_live_dashboard` (`~> 1.0`). A clean
`mix deps.get` is good evidence, but say which constraints you checked.

If the two halves already match `T`, note it and skip to install — there's
nothing to sync.

## 3. Install both halves

Regenerate both lockfiles so they resolve cleanly, then verify the tree:

```bash
(cd apps/client/assets && yarn install)   # updates yarn.lock
mix deps.get                              # from repo root; updates mix.lock
mix compile --force
mix format --check-formatted
```

Capture the real exit code — `${PIPESTATUS[0]}` is bash-only and silently
empty in this repo's zsh; redirect to a file and check `$?` instead.

If any step fails, capture the error verbatim — a failed install is the
headline of the report, not something to paper over by hand-editing a lock.

`mix deps.get` may print "packages with security advisories". Run
`mix hex.audit` and check whether the flagged package is one this bump
actually moved. Pre-existing advisories on untouched deps (e.g. `cowlib`
under `plug_cowboy`) are **not** findings for this upgrade — report them as
explicitly out-of-scope noise so they neither inflate the risk rating nor get
silently dropped.

## 4. Commit the sync

If phases 2–3 changed any manifest or lockfile beyond what dependabot already
committed, commit exactly those files (`package.json`, `yarn.lock`, `mix.exs`,
`mix.lock`) with a message describing bringing the other half into sync — e.g.
`Sync phoenix frontend to 1.8.13`. Explain *why* in the body (lockstep wire
protocol, surgical unlock) rather than in inline comments. If nothing changed,
don't create an empty commit.

## 5. Review the changelog and upgrade notes, change by change

Sources of truth, both confirmed to resolve on the `v<version>` tag:

```bash
# changelog
https://raw.githubusercontent.com/phoenixframework/<pkg>/v<T>/CHANGELOG.md
# release notes — sometimes carries upgrade steps the changelog omits
https://api.github.com/repos/phoenixframework/<pkg>/releases/tags/v<T>
```

Pull them with `WebFetch` and read *every* entry in the range `(old, T]` — a
small-looking bump can still carry a deprecation or a changed default.

**For a minor or major bump, also find the upgrade guide.** Phoenix documents
breaking changes and required config edits in the `.0` release notes and in
separate upgrade guides, not in the per-patch changelog. Search for one before
concluding a minor bump is clean; say explicitly whether you found one.

Go through each individual entry and decide whether it's relevant to *this*
repo — don't summarize the changelog wholesale, judge each line:

```bash
# JS client changes — use the pair's row from the table
grep -rn "<js_surface>" apps/client/assets/js
# server changes — the affected macro/function/option/callback
grep -rn "<affected_api>" apps/client/lib
```

For each notable change call out: is it a breaking change, deprecation, changed
default, removed/renamed callback, or new required option — and does this
codebase actually touch the affected surface? "Breaking change in the
changelog" + "app never uses that API" = low real-world risk, and saying so
explicitly is the most useful thing this review produces.

## 6. Report

Output the review using this structure:

```markdown
# <pkg> Upgrade: <old> → <T> (<frontend | backend>-initiated)

## Overall risk: <Low | Medium | High>
<One-sentence bottom line: safe to merge as-is / merge after checking X /
needs changes first.>

## Sync performed
- Detected as: <pair>, <frontend | backend> bump (<files dependabot touched>).
- Constraint style: <exact pin | range>; <edited to T | already permits T>.
- Brought <the other half> to <T>: <what you edited, or "already in sync">.
- Dependents checked: <which constraints, and that T satisfies them>.
- Committed: <commit subject, or "nothing to commit">.

## Install
- `yarn install`: ✅ / ❌ (<detail>)
- `mix deps.get`: ✅ / ❌ (<detail>)
- `mix compile --force`: ✅ / ❌
- `mix format --check-formatted`: ✅ / ❌
- Pre-existing advisories (out of scope): <or "none">

## Changelog review (old → T)
Per entry — the change, and whether it touches this codebase:
- **<change>**: <breaking? deprecation? default change?>. App impact:
  <does the app use it? cite files if yes, else "not used">.
- Upgrade guide: <found + what it requires, or "none — patch bump">.

## Risks
<Bulleted, concrete. Empty is a valid answer — say "none identified" and why.
Don't invent risk to seem thorough.>

## Recommended upgrade steps
<Concrete follow-ups before/after merging: code changes for any deprecation the
app hits, a specific manual flow to exercise, or "none — patch bump, no touched
surface, installs clean.">
```

## Tone

Match the honesty bar of a careful engineer. The most valuable output is a
*justified* "safe to merge, nothing to do" when the evidence supports it —
earn it with the sync + install + changelog checks, don't hand-wave it.
Equally, don't soft-pedal a real problem: a failed install, a version mismatch
you couldn't reconcile, or a breaking change in used code is a High, full stop.
Prefer "the changelog says X and I confirmed the app uses it at
`apps/client/lib/foo.ex:42`" over "should be fine."
