---
name: upgrade-node
description: Upgrade this project's Node.js (to latest LTS), Yarn (to latest 4.x stable), or @types/node (to latest within the Node major), each as its own commit on a pushed branch.
---

# Upgrade Node.js / Yarn / @types/node

This project pins three tools that move on independent schedules. Upgrade each
one the table below reports as `BEHIND`, and give each its own commit.

## Step 1 — Find what is behind

```bash
.claude/skills/upgrade-node/scripts/check-versions.sh
```

```
TOOL           PINNED       LATEST       STATUS
node           24.21.0      24.21.0      current
yarn           4.18.0       4.18.1       BEHIND
@types/node    24.13.4      24.19.0      BEHIND

Behind: yarn @types/node
```

The script holds the three version rules that are easy to get wrong by hand:
newest LTS rather than highest number for Node, `@yarnpkg/cli-dist` rather than
the frozen `yarn` 1.x package, and newest release *within the Node major* for
`@types/node`. Trust its `LATEST` column over any figure you derive yourself.

Report every `current` tool as done and leave it alone. When the summary says
all are current, say so and stop.

## Step 2 — Upgrade each behind tool

| Tool | Procedure |
|---|---|
| node | [`references/node.md`](references/node.md) |
| yarn | [`references/yarn.md`](references/yarn.md) |
| @types/node | below |

Read a reference only for a tool the table marks `BEHIND`.

### @types/node

Its major mirrors the Node major, so `npm`'s `latest` tag points at a runtime
this project does not run. The `LATEST` column already holds the newest release
inside the right major. Set it as the caret range in
`apps/client/assets/package.json`:

```json
"@types/node": "^24.19.0"
```

This drifts on its own, because DefinitelyTyped ships between Node releases.
Upgrade it whenever the table says `BEHIND`, whether or not Node moved.

Verify, which picks up the new range and proves the types still compile:

```bash
.claude/skills/upgrade-node/scripts/verify-assets.sh
```

Then stage `apps/client/assets/package.json` and `apps/client/assets/yarn.lock`.

## Step 3 — Branch, commit, push

Check the current branch first. On `main`, cut `upgrade-<tool>-<version>` and
work there. On any other branch, commit in place.

Commit each tool separately, staging the files its procedure names. Node and
Yarn are independent and each diff is small, so one commit per tool keeps the
history easy to read, revert, and bisect. Write the subject and body by the
commit rules in `~/.claude/CLAUDE.md`.

Push the branch when the commits land. Leave the pull request for the user to
open.
