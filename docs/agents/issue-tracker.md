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

## Branch and PR metadata

A ticket in flight records where it is being built and, once a PR exists, where to review
it. Both live in the bead's metadata map as **strings**.

| Key      | Value                                                               |
| -------- | ------------------------------------------------------------------- |
| `branch` | The git branch name, e.g. `jt/scope-food-log`                        |
| `pr`     | The full PR URL, e.g. `https://github.com/jutonz/homepage/pull/4440` |

- **Set the branch** when you claim the ticket and cut the branch:
  `bd update <id> --set-metadata branch=jt/scope-food-log`
- **Set the PR** when you open it, alongside the move to `in_review`:
  `bd update <id> --set-metadata pr=https://github.com/jutonz/homepage/pull/4440 -s in_review`
- **Read**: `bd show <id>` prints a `METADATA` block; `bd show <id> --json` exposes `metadata`.
- **Find**: `bd list --metadata-field branch=jt/scope-food-log` for an exact match,
  `bd list --has-metadata-key pr` for every ticket with a PR open.
- **Clear**: `bd update <id> --unset-metadata pr`.

Always store the PR as the full URL, never the bare number — `--set-metadata pr=4440` is
stored as the *integer* `4440`, which breaks `--metadata-field` matching and reads badly in
JSON. A URL is unambiguously a string.

`bd query` does not understand metadata fields; only the `bd list` flags above filter on
them. Metadata is part of the bead, so it exports to `.beads/issues.jsonl` and travels with
`bd dolt push`.

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

## Workflow formulas

Formulas are workflow templates in `.beads/formulas/*.formula.json`. They are git-tracked;
the instances they create are not. `bd formula list` / `bd formula show <name>` inspect them.

### `bead-to-pr`

The repeatable playbook for taking one bead from open to merged, in nine sequential steps:
`read` → `claim` → `branch` → `implement` → `verify` → `commit` → `review` → `pr` → `close`.

```
bd mol wisp bead-to-pr --var bead=homepage-4fm
```

Driven by the `/bead-to-pr` skill in `.claude/skills/`, which pours or resumes the wisp and
walks its steps. That skill is user-invoked, so nothing discovers it on its own — type it.

`bead` is the only variable, and it is required.

**The branch comes from the ticket, not from an argument.** The `branch` step reads
`metadata.branch` off the bead and checks that branch out if it is set; if it is empty, it
constructs `jt/<slug>`, writes it back with `--set-metadata branch=...`, *then* checks out.
Recording before checking out is what makes a resumed or handed-off run land on the same
branch instead of cutting a second one. Formula variables have no defaults — every `{{var}}`
must be supplied at pour time — so an optional `branch` argument was not an option.

**A ticket lands as one commit**, so nothing is committed until the gates are green:
`implement` deliberately does not commit, `verify` runs the gates, and `commit` stages the
whole change at once. `review` then runs the `mattpocock-skills:code-review` skill against
the merge-base before anything is pushed, and its fixes are amended into that single commit.

**`verify` checks acceptance criteria, not just tests.** After the gates pass it re-reads
`acceptance_criteria` off the bead, walks each one against the diff, and ticks the boxes with
`bd update <id> --acceptance "..."`. That flag *replaces* the whole field, so every criterion
has to be passed back — ticking one by sending only that line silently drops the rest. An
unmet criterion stops the run before the commit step.

**`pr` closes the loop on both metadata fields.** It records the PR URL and moves the bead to
`in_review` in a single `bd update <id> --set-metadata pr=<url> -s in_review`, reading the URL
back from `gh pr view --json url -q .url` rather than retyping it.

**It is vapor, not liquid.** `bd mol wisp` creates *ephemeral* issues — local-only, absent
from `bd ready`, `bd list`, and `.beads/issues.jsonl`, never synced by `bd dolt push`. Use
`bd mol wisp`, never `bd mol pour`, or the nine checklist steps become permanent tracker noise.

- **Progress**: `bd mol show <root>`, `bd mol progress <root>`, `bd mol current <root>`.
- **Advance**: `bd close <step-id>` as each step completes.
- **Finish**: `bd mol squash <root> --summary "..."` to leave one persistent digest bead,
  or `bd mol burn <root> --force` to discard the run entirely (it prompts without `--force`).

The final step carries a **human gate**, so `close` stays blocked until you run
`bd gate resolve <gate-id>` (find it with `bd gate list`). That enforces the rule that a bead
is closed only after its PR merges — `in_review` is where it sits until then.

A `gh:pr` gate would auto-resolve on merge, but `--await-id` needs the PR number, which does
not exist when the wisp is poured. `bd gate discover` only backfills `gh:run` gates, not
`gh:pr`. Hence the human gate.

**Authoring gotchas** (learned the hard way):

- The name key is `formula`, not `name` — `{"formula": "bead-to-pr", ...}`. Using `name`
  fails with the confusing `formula: name is required`.
- Validate with `bd cook <path> --var k=v` before pouring; it resolves and type-checks
  without writing to the database.
- Variable `default` values are declared but **not honored** — `bd cook --mode=runtime`
  still errors `Missing: <var>`. Every `{{var}}` in the file must be supplied at pour time,
  so anything optional has to be resolved by a step at runtime rather than interpolated.
- A step description that spans multiple lines inside a quoted shell argument renders badly
  (`bd show` eats the leading `-` of continuation lines). Keep such examples on one logical
  line, e.g. `--acceptance "$(printf -- '- [x] one\n- [x] two\n')"`.
- Avoid `<angle-bracket>` placeholders in step descriptions. They survive in storage but the
  `bd show` renderer strips them, so `pr=<full-url>` displays as `pr=`. Use bare tokens like
  `PR_URL` instead.
- Wisps are garbage-collected only when you run `bd mol wisp gc` — nothing expires on a
  timer. But `gc` deletes wisps untouched for `--age` (default 1h) regardless of a pending
  gate, so a run parked waiting on review is deletable. Squash before a long wait.
