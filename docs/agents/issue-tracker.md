# Issue tracker: beads (`bd`)

Issues and specs for this repo live in the local beads database under `.beads/`, managed
with the `bd` CLI. Issue IDs look like `homepage-40m`. This repo's `CLAUDE.md` mandates
`bd` for all task tracking — do not use GitHub Issues, TodoWrite, or markdown TODO lists.

Run `bd prime` once per session for the full workflow context.

## Conventions

- **Create an issue**: `bd create --title "..." --description "..." --type=task|bug|feature|epic --priority=2`
  Priority is `0`-`4` (0 = critical, 2 = medium, 4 = backlog), never `high`/`low`.
  Add `--labels a,b`, `--parent <id>` for a hierarchical child, `--acceptance "..."`,
  `--design "..."`, `--notes "..."`. Use `bd q "title"` for quick capture (prints only the ID).
- **Read an issue**: `bd show <id>` for details and dependencies; `bd comments <id>` for
  the comment thread. Add `--json` to either when parsing.
- **List issues**: `bd list --status open --json`. Filter with `--label`, `--label-any`,
  `--exclude-label`, `--assignee`, `--sort`. Use the comma-separated form for multiple
  statuses (`--status open,in_progress`) — repeating `-s` silently overwrites.
- **Find work**: `bd ready` (unblocked and open), `bd blocked`, `bd search <query>`.
- **Comment**: `bd comment <id> "..."` (or `--stdin` / `--file notes.txt` for long bodies).
- **Apply / remove labels**: `bd label add <id> <label>` / `bd label remove <id> <label>`.
  `bd update <id> --add-label x --remove-label y` also works.
- **Claim**: `bd update <id> --claim` (atomically sets assignee to you and status to
  `in_progress`). Assign to someone else with `bd assign <id> <name>`.
- **Send for review**: `bd update <id> -s in_review` once a PR is open and waiting on a
  human. See "The `in_review` status" below.
- **Close**: `bd close <id> --reason="..."`. Close several at once: `bd close <id1> <id2>`.
  `bd close <id> --suggest-next` shows what the close unblocked.

## The `in_review` status

`in_review` is a custom status (category `wip`) on top of beads' built-in set. It means
**a PR is open and pending human review**. Confirm the vocabulary with `bd statuses`.

- **Move into it**: `bd update <id> -s in_review`, immediately after opening the PR.
- **Move out of it**: `bd close <id> --reason="..."` when the PR merges — `closed` is beads'
  only terminal state, so it is what "resolved" means here. If review asks for changes,
  move back with `bd update <id> -s in_progress`.
- **Find them**: `bd list --status in_review`.

The status lives in the beads database, not in `.beads/config.yaml`, so it travels with
`bd dolt push` / `bd dolt pull` rather than with a git-tracked file. It was registered with:

```
bd config set status.custom "in_review:wip"
```

Appending another custom status later means rewriting that whole comma-separated value —
`bd config set status.custom "in_review:wip,other:wip"` — since the key is replaced, not merged.

**Never run `bd edit`** — it opens `$EDITOR` and blocks the agent. Use `bd update` with
inline flags instead.

Do not run `bd dolt push`, `git commit`, or `git push` as part of these skills unless the
user explicitly asks. This repo runs the conservative agent profile.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo treats GitHub PRs as feature
requests; `/triage` reads this flag.)_

When set to `yes`, use `gh pr list/view/diff/comment` against `jutonz/homepage` to read the
request, then mirror it into a `bd` issue and triage it there. Beads is the system of record
either way — labels and states live on the bead, not the PR.

## When a skill says "publish to the issue tracker"

Run `bd create` and report the returned ID.

## When a skill says "fetch the relevant ticket"

Run `bd show <id>`, plus `bd comments <id>` when the discussion matters.

## Wayfinding operations

Used by `/wayfinder`. The **map** is an epic, and **tickets** are its children.

- **Map**: `bd create --type=epic --labels wayfinder:map --title "..." --description "..."`,
  holding the Notes / Decisions-so-far / Fog body. Update the body with
  `bd update <map> --description "..."` or append with `bd note <map> "..."`.
- **Child ticket**: `bd create --parent <map> --labels wayfinder:<type> --title "..."`,
  where `<type>` is `research`, `prototype`, `grilling`, or `task`. Children inherit the
  parent's labels unless `--no-inherit-labels` is passed, so strip `wayfinder:map` from
  children. List them with `bd children <map>`.
- **Blocking**: `bd dep add <blocked> <blocker>` (equivalently `bd dep <blocker> --blocks
  <blocked>`). Inspect with `bd dep tree <id>` or `bd show <id>`; `bd dep cycles` catches
  loops. A ticket is unblocked once every blocker is closed.
- **Frontier query**: `bd ready --json` already excludes blocked issues; narrow to the map's
  children and drop any with an assignee. First in map order wins.
- **Claim**: `bd update <id> --claim`, the session's first write.
- **Resolve**: `bd comment <id> "<answer>"`, then `bd close <id> --reason="..."`, then
  append a context pointer to the map's Decisions-so-far.
