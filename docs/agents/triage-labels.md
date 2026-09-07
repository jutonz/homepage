# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the actual label strings used in this repo's issue tracker.

| Label in mattpocock/skills | Label in our tracker | Meaning                                  |
| -------------------------- | -------------------- | ---------------------------------------- |
| `needs-triage`             | `needs-triage`       | Maintainer needs to evaluate this issue  |
| `needs-info`               | `needs-info`         | Waiting on reporter for more information |
| `ready-for-agent`          | `ready-for-agent`    | Fully specified, ready for an AFK agent  |
| `ready-for-human`          | `ready-for-human`    | Requires human implementation            |
| `wontfix`                  | `wontfix`            | Will not be actioned                     |

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), use the corresponding label string from this table.

Edit the right-hand column to match whatever vocabulary you actually use.

## Notes for this repo

Issues live in Linear (see `docs/agents/issue-tracker.md`). Team `HOMEP` has **no labels defined
yet**, so there are no pre-existing names to collide with. Linear will not create a label on
first use — create it once, then apply it:

```bash
linear label create --team HOMEP        # then apply:
linear issue update <id> --add-label needs-triage
```

Check what already exists with `linear label list --team HOMEP`.

Use `--add-label` / `--remove-label` to change labels incrementally. Bare `-l/--label` replaces
the issue's entire label set, which will silently drop triage labels applied earlier.
