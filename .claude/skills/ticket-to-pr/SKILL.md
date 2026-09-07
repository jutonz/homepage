---
name: ticket-to-pr
description: Take a Linear issue from open to merged — branch, implement, verify, commit, review, open the PR.
disable-model-invocation: true
---

# Ticket to PR

The repeatable playbook for taking one Linear issue from open to merged. Work the steps in
order, one at a time. Conventions this relies on: `docs/agents/issue-tracker.md`.

Take the issue id from the invocation, or ask for it. Everything below assumes `HOMEP-24`.

## 1. Read

```bash
linear issue view HOMEP-24
```

Read the description and the comment thread. Note the **Acceptance Criteria** section — step 4
checks the diff against it, so know what it says before writing code.

## 2. Claim and branch

```bash
linear issue start HOMEP-24
linear issue update HOMEP-24 -a self
```

`start` moves the issue to a started state and creates and checks out a branch named for the
issue. It does **not** set an assignee, so claim it explicitly — an issue sitting in a started
state with nobody on it reads as unclaimed work.

**Resuming an earlier run:** check for an existing branch first
(`git branch --list '*homep-24*'`) and check it out instead. Starting again cuts a second branch
and leaves the work split across both.

Confirm you are on the right branch at any point with `linear issue id`.

## 3. Implement

Do the work. **Do not commit.** The commit comes after the gates are green, so that one ticket
lands as exactly one commit.

## 4. Verify

Run the gates that the change touches:

```bash
mix test
cd apps/client/assets && yarn lint --check && yarn typecheck
```

Then re-read the acceptance criteria and walk **each one** against the actual diff. Tick the
boxes by rewriting the description:

```bash
linear issue view HOMEP-24 --json --no-comments | python3 -c 'import json,sys; print(json.load(sys.stdin)["description"])' > /tmp/desc.md
# edit /tmp/desc.md, changing "- [ ]" to "- [x]" for what the diff actually satisfies
linear issue update HOMEP-24 --description-file /tmp/desc.md
```

`--description-file` **replaces the whole description**, so round-trip the existing body through
a file rather than retyping it — passing only the changed lines silently destroys the rest.

An unmet criterion stops the run here. Go back to step 3 or raise it with the human.

## 5. Commit

Stage the whole change at once — one ticket, one commit:

```bash
git add -A
git commit -m "$(linear issue describe)"
```

`linear issue describe` prints the title plus a `Fixes` trailer linking the issue. Use
`linear issue describe -r` for `References` instead when the commit should not close it.

## 6. Review

Run the `mattpocock-skills:code-review` skill against the merge-base before anything is pushed.
Amend its fixes into the single commit (`git commit --amend`) rather than stacking a second one.

## 7. Open the PR

```bash
git push -u origin HEAD
linear issue pr                                    # prints the PR URL
linear issue link HOMEP-24 <pr-url>
linear issue update HOMEP-24 -s "In Review"
```

`linear issue pr` builds the GitHub PR from the issue and prefixes the identifier onto the title.

**The link step is not optional.** This workspace has no GitHub integration installed, so Linear
never learns the PR exists on its own — the branch name and commit trailer point at the issue,
not the reverse. Skip it and the issue shows no PR, and nothing will move it on merge.

Report the PR URL. **The run is finished for this session.**

## 8. Close — only after the merge

An issue reaches `Done` when its PR merges, not when it is opened. Do not run this step on your
own initiative; wait for the human to confirm the merge.

```bash
linear issue update HOMEP-24 -s "Done"
```

If review asks for changes instead, move it back with `-s "In Progress"` and return to step 3.

## Git policy

This repo does not commit or push without being asked. Steps 5 and 7 do both, which is the point
of the playbook — invoking it is the authorisation. But do not run them ahead of their turn, and
do not push anything the verify step has not cleared.

## Done when

The PR is open, the issue is in `In Review`, and the PR URL is reported — or the human has
confirmed the merge and the issue is `Done`. Anything less is work still outstanding.
