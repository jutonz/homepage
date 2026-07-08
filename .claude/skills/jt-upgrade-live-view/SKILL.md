---
name: jt-upgrade-live-view
allowed-tools: Read, Edit, Write, Bash, Grep, Glob, WebFetch, WebSearch
---

# Upgrade Phoenix LiveView

LiveView ships as two coupled halves: a **hex package** (the server) and
an **npm package** (the JS client). They speak a shared wire protocol and
are published in lockstep, so they must be pinned to the *same* version —
a mismatch means the client and server disagree over the wire and you get
subtle, hard-to-debug breakage in production.

Dependabot only ever bumps one half at a time. So the core job of this
skill is: figure out which half a branch bumped, bring the *other* half up
to the same version, install both, commit the sync, then read the upstream
changelog and hand back a risk-rated report the user can act on.

Invoked manually on a dependabot branch that bumps `phoenix_live_view`.

## Where the versions live

- **Frontend (JS client)** — exact pin in `apps/client/assets/package.json`
  (`"phoenix_live_view": "X.Y.Z"`), resolved in `apps/client/assets/yarn.lock`.
- **Backend (hex)** — a `~>` constraint in `apps/client/mix.exs`
  (`{:phoenix_live_view, "~> X.Y.Z"}`), resolved to an exact version in
  `mix.lock` at the repo root.

Work through the phases below in order. Use a todo list so nothing is
skipped — the value here is in doing the boring sync + verification so the
user doesn't have to.

## 1. Detect frontend vs backend — on the branch's own commits

**Gotcha that will bite you:** dependabot branches are frequently *behind*
`main`. A raw `git diff main` then shows main's newer, unrelated deps as if
*this* branch removed them — total noise. Always diff against the merge
base so you see only what this branch actually changed:

```bash
BASE=$(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main)
git diff "$BASE"...HEAD --stat
git diff "$BASE"...HEAD -- apps/client/assets/package.json mix.lock apps/client/mix.exs
```

Classify from that diff:

- Touches `apps/client/assets/package.json` / `yarn.lock` → **frontend** upgrade.
- Touches root `mix.lock` (and sometimes `apps/client/mix.exs`) → **backend** upgrade.

Read the **old** and **new** `phoenix_live_view` versions straight out of
the diff. The new version is the **target `T`** that both halves must land
on. If the branch isn't a `phoenix_live_view` bump (or the tree is dirty /
you're not on the bump branch), stop and say so rather than guessing.

## 2. Sync the other half to `T`

Both halves must equal `T` exactly. Bump whichever one dependabot left behind.

**Frontend upgrade** (package.json is already at `T` — sync the backend):

- Check the `apps/client/mix.exs` constraint permits `T`. It's a `~>` range,
  so a patch/minor bump *inside* the range needs no edit. Only edit if `T`
  crosses the ceiling (e.g. constraint `~> 1.2.3`, `T` is `1.3.0` → bump to
  `~> 1.3.0`).
- Move the lock **surgically**: `mix deps.unlock phoenix_live_view` then
  `mix deps.get`. Do *not* use `mix deps.update phoenix_live_view` — on a
  dependabot branch whose lock is behind the registry it re-resolves the
  whole tree and drags **unrelated siblings** up with it, polluting the diff.
- It's fine — expected — for `phoenix_live_view`'s *own* transitive deps to
  move if the new version genuinely requires it; that's part of the upgrade,
  and the user is OK with transitive-dep bumps. What you're avoiding is
  packages that move *only* because the branch lock is stale, not because
  LiveView needs them. Tell the two apart with the dep tree:

  ```bash
  mix deps.tree | grep -iE "phoenix_live_view|<pkg>"
  ```

  Anything nested under `phoenix_live_view` is a genuine transitive and may
  float. A sibling that lives under a different parent is not. (Example seen
  in practice: `cowboy`/`cowlib` sit under `plug_cowboy`, the web-server
  adapter — *not* under `phoenix_live_view` — so a PLV bump should leave them
  alone. `deps.unlock phoenix_live_view` + `deps.get` does exactly that.)
- Confirm `mix.lock` shows **exactly `T`** and that only `phoenix_live_view`
  (plus any of its genuine transitives) moved. If it overshot to a newer
  patch published since, that's a discrepancy — pin the constraint tighter
  (`~> T`) so the halves match, and flag it in the report.

**Backend upgrade** (mix.lock is at `T` — sync the frontend):

- Set `phoenix_live_view` in `apps/client/assets/package.json` to `T` exactly.

If the two halves already match `T`, note it and skip to install — there's
nothing to sync.

## 3. Install both halves

Regenerate both lockfiles so they resolve cleanly:

```bash
(cd apps/client/assets && yarn install)   # updates yarn.lock
mix deps.get                              # run from repo root; updates mix.lock
```

If either fails, capture the error verbatim — a failed install is the
headline of the report, not something to paper over by hand-editing a lock.

## 4. Commit the sync

If phases 2–3 changed any manifest or lockfile beyond what dependabot
already committed, commit exactly those files (package.json, yarn.lock,
mix.exs, mix.lock) with a message describing bringing the other half into
sync — e.g. `Sync phoenix_live_view backend to 1.2.6`. If nothing changed
(the halves were already aligned), don't create an empty commit.

## 5. Review the changelog, change by change

Source of truth: the `phoenixframework/phoenix_live_view` **CHANGELOG.md**
and GitHub **Releases**. Pull the notes with `WebFetch` and read *every*
entry in the range `(old, T]` — a small-looking bump can still carry a
deprecation or default change.

Go through each individual entry and decide whether it's relevant to *this*
repo — don't summarize the changelog wholesale, judge each line:

```bash
# JS client changes — hooks, colocated JS, socket setup
grep -rn "phoenix_live_view\|LiveSocket\|Hooks\|phx-" apps/client/assets/js | head -40
# server changes — the affected macro/function/option/callback
grep -rn "<affected_api>" apps/client/lib | head -40
```

For each notable change call out: is it a breaking change, deprecation,
changed default, removed/renamed callback, or new required option — and
does this codebase actually touch the affected surface? "Breaking change in
the changelog" + "app never uses that API" = low real-world risk, and
saying so explicitly is the most useful thing this review produces.

## 6. Report

Output the review using this structure:

```markdown
# LiveView Upgrade: <old> → <T> (<frontend | backend>-initiated)

## Overall risk: <Low | Medium | High>
<One-sentence bottom line: safe to merge as-is / merge after checking X /
needs changes first.>

## Sync performed
- Detected as: <frontend | backend> bump (<which files dependabot touched>).
- Brought <the other half> to <T>: <what you edited, or "already in sync">.
- Committed: <commit subject, or "nothing to commit">.

## Install
- `yarn install`: ✅ / ❌ (<detail>)
- `mix deps.get`: ✅ / ❌ (<detail>)

## Changelog review (old → T)
Per entry — the change, and whether it touches this codebase:
- **<change>**: <breaking? deprecation? default change?>. App impact:
  <does the app use it? cite files if yes, else "not used">.

## Risks
<Bulleted, concrete. Empty is a valid answer — say "none identified" and
why. Don't invent risk to seem thorough.>

## Recommended upgrade steps
<Concrete follow-ups the user should take before/after merging: code
changes for any deprecation the app hits, a specific manual flow to
exercise, or "none — patch bump, no touched surface, installs clean.">
```

## Tone

Match the honesty bar of a careful engineer. The most valuable output is a
*justified* "safe to merge, nothing to do" when the evidence supports it —
earn it with the sync + install + changelog checks, don't hand-wave it.
Equally, don't soft-pedal a real problem: a failed install, a version
mismatch you couldn't reconcile, or a breaking change in used code is a
High, full stop. Prefer "the changelog says X and I confirmed the app uses
it at `apps/client/lib/foo.ex:42`" over "should be fine."
