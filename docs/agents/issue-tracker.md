# Issue tracker: Linear (`linear`)

Issues for this repo live in Linear, in team **`HOMEP`** of the `jt-project42` workspace, and
are managed with the [`linear` CLI](https://github.com/schpet/linear-cli). Issue IDs look like
`HOMEP-24`. Workspace, team, and sort order are configured in `.linear.toml` at the repo root.

This repo's `CLAUDE.md` mandates `linear` for durable task tracking — do not use GitHub Issues
or markdown TODO lists. TodoWrite is fine as a single turn's execution checklist, but it is not
project state.

Most commands take an issue id as an optional argument. **Omit it and the CLI infers the issue
from the current git branch**, which is why the branch naming below matters.

## Conventions

- **Create an issue**: `linear issue create -t "..." -d "..." -p 2`
  Priority is `1`-`4` descending (`1` = urgent, `4` = low); omit for no priority.
  Add `-l <label>` (repeatable), `--parent HOMEP-12`
  for a sub-issue, `-s "Backlog"` to place it in a state, `--start` to claim it immediately.
  Prefer `--description-file <path>` over `-d` for anything with markdown structure.
  Pass `--no-interactive` in scripts and agent runs so it never blocks on a prompt.
- **Read an issue**: `linear issue view <id>` (includes comments by default; `--no-comments` to
  drop them). Add `-j/--json` when parsing. `linear issue url <id>` and
  `linear issue title <id>` print just those fields.
- **List and find work**: `linear issue list` is *your* issues, and defaults to the `unstarted`
  state — it is a personal inbox, not a team view. For anything broader use
  `linear issue query`, which defaults to all states and all assignees:
  ```bash
  linear issue query --team HOMEP -s backlog -s unstarted   # open work
  linear issue query --team HOMEP -s started                # in flight (incl. In Review)
  linear issue query --team HOMEP --search "food log" -j    # full-text, as JSON
  linear issue query --team HOMEP -U                        # unassigned only
  ```
  `-s/--state` takes state *types* (`triage`, `backlog`, `unstarted`, `started`, `completed`,
  `canceled`), not state names. `In Progress` and `In Review` are both type `started`, so
  filtering to exactly one of them means matching on the name in the output or via `linear api`.
- **Comment**: `linear issue comment add <id> "..."`; `linear issue comment list <id>` to read.
- **Labels**: `linear issue update <id> --add-label x --remove-label y`. Plain `-l/--label`
  **replaces the entire label set** — use the incremental flags unless you mean to reset.
- **Claim and start**: `linear issue start <id>` moves the issue to a started state and creates
  and checks out its branch. It does **not** set an assignee — run
  `linear issue update <id> -a self` as well to actually claim it. See "Branch and PR linking".
- **Send for review**: `linear issue update <id> -s "In Review"` once the PR is open.
- **Close**: `linear issue update <id> -s "Done"` — but only after the PR merges. See below.
- **Dependencies**: `linear issue relation add HOMEP-24 blocked-by HOMEP-12`. Relation types
  are `blocked-by`, `blocks`, `related`, and `duplicate`. Inspect with
  `linear issue relation list <id>`.

## Workflow states

Team `HOMEP` uses six states. Two of them share the `started` type, which matters when filtering:

| State         | Type        | Means                                        |
| ------------- | ----------- | -------------------------------------------- |
| `Backlog`     | `backlog`   | Filed, not scheduled                         |
| `Todo`        | `unstarted` | Scheduled, not begun                         |
| `In Progress` | `started`   | Being worked                                 |
| `In Review`   | `started`   | **PR is open and pending human review**      |
| `Done`        | `completed` | Shipped — the PR merged                      |
| `Canceled`    | `canceled`  | Will not be done                             |

**An issue reaches `Done` only after its PR merges.** While the PR is open it sits in
`In Review`; if review asks for changes, move it back to `In Progress`. Nothing goes straight
from `In Progress` to `Done`.

Confirm the current vocabulary with:

```bash
linear api '{ workflowStates(first: 50, filter: { team: { key: { eq: "HOMEP" } } }) { nodes { name type } } }'
```

## Branch and PR linking

The link between an issue and its work lives in the branch name, so there is nothing to record
by hand.

- **Start the work**: `linear issue start <id>` cuts a branch named for the issue and checks it
  out. `-b/--branch` overrides the name, `-f/--from-ref` sets what it branches from. Keep the
  issue identifier in the branch name; that substring is what every inference below depends on.
- **Which issue is this branch?**: `linear issue id` prints the identifier for the current
  branch. This is why `view`, `update`, `pr`, and friends can be called with no argument.
- **Commit message trailer**: `linear issue describe` prints the title plus a `Fixes` trailer
  linking the issue; `-r/--references` emits `References` instead, for a commit that touches the
  issue without closing it.
- **Open the PR**: `linear issue pr` creates the GitHub PR with the issue's details and prefixes
  the identifier onto the title. `--draft`, `--base`, and `-T/--template` are available.
- **Link the PR back**: `linear issue link <id> <pr-url>`. This workspace has **no GitHub
  integration installed**, so Linear does not discover PRs on its own — the branch name and the
  commit trailer link the other direction only. Without this step the issue shows no PR at all,
  and nothing moves it to `Done` when the PR merges.
- **Attach anything else**: `linear issue link <id> <url>` for a URL,
  `linear issue attach <id> <filepath>` for a file.

## Hierarchy

Sub-issues give parent/child hierarchy: `linear issue create --parent HOMEP-12 ...`, where
the parent is given as its `TEAM-NUMBER` code. `linear issue view <parent>` renders the tree.
`linear issue query` has no parent filter, so to list children programmatically drop to the API:

```bash
linear api '{ issues(filter: { parent: { number: { eq: 12 } } }) { nodes { identifier title } } }'
```

### Wayfinding operations

Used by `/wayfinder`. The **map** is a parent issue labelled `wayfinder:map` holding the Notes /
Decisions-so-far / Fog body; **tickets** are its sub-issues, labelled `wayfinder:research`,
`wayfinder:prototype`, `wayfinder:grilling`, or `wayfinder:task`. Labels are not inherited by
sub-issues in Linear, so apply each child's label explicitly. Block with
`linear issue relation add <blocked> blocked-by <blocker>`. Resolve a ticket by commenting the
answer, moving it to `Done`, then appending a context pointer to the map's description.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo treats GitHub PRs as feature
requests; `/triage` reads this flag.)_

When set to `yes`, use `gh pr list/view/diff/comment` against `jutonz/homepage` to read the
request, then mirror it into a Linear issue and triage it there. Linear is the system of record
either way — labels and states live on the issue, not the PR.

## When a skill says "publish to the issue tracker"

Run `linear issue create --no-interactive` and report the returned identifier.

## When a skill says "fetch the relevant ticket"

Run `linear issue view <id>`, which includes the comment thread.

## The open-to-merged playbook

`/linear-to-pr` (in `.claude/skills/`) walks one issue from open to merged in nine steps:
`read` → `claim` → `branch` → `implement` → `verify` → `commit` → `review` → `pr` → `close`.
It is user-invoked and will not trigger on its own — type it.

## Git policy

Do not run `git commit`, `git push`, or open a PR as part of these skills unless the user
explicitly asks. Report what changed and what you would run next, then wait. See "Session
Completion" in `CLAUDE.md`.
