---
name: bead-to-pr
description: Take a bead from open to merged — branch, implement, verify, commit, review, open the PR.
disable-model-invocation: true
---

# Bead to PR

Drives the `bead-to-pr` formula, which is the source of truth for what each step does.
This skill decides which wisp to work; the wisp's steps say what to do.

## 1. Resolve the wisp

Take the bead id from the invocation, or ask for it.

Check for an existing run before creating one:

```
bd mol wisp list
```

A `bead-to-pr` wisp already open for this bead is the run to continue — resume it. Pouring
a second one gives two parallel wisps with no relationship, and the ticket ends up half-done
in each. With no wisp for this bead:

```
bd mol wisp bead-to-pr --var bead=<bead-id>
```

Report the root id. It is how the human resumes this run in a later session.

## 2. Walk the steps

```
bd mol current <root>    # where the run is now
bd show <step-id>        # this step's instructions — the actual commands
bd close <step-id>       # once they are carried out
```

Work one step at a time, in dependency order. `bd show` on a step returns the commands to
run: treat that text as the spec and carry it out, then close the step. A closed step means
its instructions ran, so the run's progress stays true to what actually happened.

Beads conventions the steps rely on: `docs/agents/issue-tracker.md`.

## 3. Stop at the gate

The `close` step is blocked by a **human gate**. Once `pr` is closed, the run is finished for
this session: report the PR URL and the root id, and leave the gate for the human to resolve
when the PR merges.

## 4. Close it out

When the human confirms the merge, resolve the gate and work the final step:

```
bd gate list
bd gate resolve <gate-id>
```

Then `bd show` the `close` step and follow it — it closes the bead and squashes the wisp into
a digest.

## Done when

Every step is closed and the bead is closed, or the run is parked at the gate with the PR URL
reported. A step left open is work still outstanding.
