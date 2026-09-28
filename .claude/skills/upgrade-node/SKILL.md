---
name: upgrade-node
description: Upgrade this project's pinned Node.js, Yarn, or @types/node versions.
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

Trust the `LATEST` column over any version you derive yourself. The script
encodes one version rule per tool, each easy to get wrong by hand.

Report every `current` tool as done and leave it alone. When the summary says
all are current, say so and stop.

## Step 2 — Upgrade each behind tool

| Tool | Procedure |
|---|---|
| node | [`references/node.md`](references/node.md) |
| yarn | [`references/yarn.md`](references/yarn.md) |
| @types/node | [`references/types-node.md`](references/types-node.md) |

Read a reference only for a tool the table marks `BEHIND`.

Done when `check-versions.sh` reports every tool `current`.

## Step 3 — Branch, commit, push

Check the current branch first. On `main`, cut `upgrade-<tool>-<version>` and
work there. On any other branch, commit in place.

Commit each tool separately, staging the files its procedure names. Node and
Yarn are independent and each diff is small, so one commit per tool keeps the
history easy to read, revert, and bisect. Write the subject and body by the
commit rules in `~/.claude/CLAUDE.md`.

Push the branch when the commits land. Leave the pull request for the user to
open.

Done when `git status` is clean and each upgraded tool has its own pushed
commit.
