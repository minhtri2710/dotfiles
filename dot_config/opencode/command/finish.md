---
description: Coach review, quality gates, and close bead
subtask: false
---

# /finish - Review & Complete

Coach gate → Close → Cleanup → Commit.

## Input & Flags

`$ARGUMENTS` - Bead ID

| Flag | Effect |
|------|--------|
| `--no-commit` | Skip auto-commit |
| `--docs-only` | Review documentation only |

---

## Phase 1: Coach Gate

**Read ALL artifacts first:** spec.md, plan.md, research.md before finishing.

```bash
/coach $ARGUMENTS
```

Coach validates: build, tests, lint, requirements compliance with `file:line` evidence.

**If NOT APPROVED:** Address gaps, re-run `/finish`.

## Phase 2: Graph Health

```bash
bv --robot-insights | jq '.Cycles'
```

Must have: no cycles, no orphans.

## Phase 3: Close Bead

**Hierarchy rule:** Parent cannot close until ALL children closed.

```bash
OPEN_CHILDREN=$(bd list --parent $ARGUMENTS --status open,in_progress,blocked --json)
if [ -n "$OPEN_CHILDREN" ]; then
  echo "Cannot close epic: child beads still open"
  exit 1
fi
bd close $ARGUMENTS --reason "Coach approved: all requirements verified"
```

## Phase 4: Cleanup

**Keep:** `spec.md` | **Delete:** `research.md`, `plan.md`, `handoffs/`

```bash
rm -f .beads/artifacts/{bead_id}/research.md .beads/artifacts/{bead_id}/plan.md
rm -rf .beads/artifacts/{bead_id}/handoffs/
```

## Phase 5: Commit & Push

```bash
/commit  # unless --no-commit
git push origin HEAD  # Push to remote after commit
```

**Constraints:**
- `/commit` only commits locally. `/finish` owns the push step.
- **NEVER commit artifacts** - `.beads/artifacts/` must be in .gitignore

## Phase 6: Check Parent

```bash
bd show {parent_epic_id}
bd ready --parent {parent_epic_id}
```

| Status | Suggest |
|--------|---------|
| More ready tasks | `/build {next_task_id}` |
| All done | `/finish {parent_epic_id}` |
| Some blocked | Report blockers |

---

## 3-Strike Rule

After 3 consecutive NOT_APPROVED: `bd update $ARGUMENTS --status blocked` → escalate with failure reasons.

## Quick Reference

| Outcome | Action |
|---------|--------|
| All pass | Close → commit |
| Fail | Fix → retry |
| 3 failures | Block → escalate |
