---
description: Restore session from handoff document
subtask: false
---

# /rehydrate - Restore from Handoff

Restore context from a previous `/handoff` document.

**Input:** `$ARGUMENTS` - Bead ID with existing handoff  
**No handoff?** Use `/start {bead_id}` instead.

---

## Phase 1: Find & Read Handoff

```bash
ls -t .beads/artifacts/$ARGUMENTS/handoffs/*.md | head -1
cat {latest_handoff}
```

No files → "No handoff found. Use `/start $ARGUMENTS` instead."

---

## Phase 2: Verify Git State

```bash
git rev-parse HEAD
git branch --show-current
git status --porcelain
```

### Divergence Scenarios

| Scenario | Detection | Action |
|----------|-----------|--------|
| **Matches** | commit == handoff.git_commit | Proceed |
| **Commit changed** | commit != handoff.git_commit | Show `git log --oneline {old}..{new}`, ask to proceed |
| **Branch different** | branch != handoff.branch | Warn, ask to checkout or proceed |
| **Dirty working tree** | porcelain not empty | Ask: stash, commit, or proceed |
| **Files missing** | referenced files don't exist | List missing, ask how to proceed |

---

## Phase 3: Load Artifacts

```bash
cat .beads/artifacts/{bead_id}/spec.md
cat .beads/artifacts/{bead_id}/plan.md      # if exists
cat .beads/artifacts/{bead_id}/research.md  # if exists
```

---

## Phase 4: Present Restored Context

```markdown
## Restored: {bead_id}

**From**: {handoff date} | **Phase**: {plan_phase} | **Status**: {status}

### State Comparison
| Field | Handoff | Current | Match |
|-------|---------|---------|-------|
| Commit | {old} | {new} | ✅/⚠️ |
| Branch | {old} | {new} | ✅/⚠️ |
| Clean | {yes/no} | {yes/no} | ✅/⚠️ |

### Restored Learnings
{learnings from handoff}

### Verification Status (from handoff)
| Check | Status |
|-------|--------|
| Build | {status} |
| Tests | {status} |

### Next Actions
1. {immediate from handoff}
2. {then from handoff}

### Blockers
{blockers from handoff}

→ Continue: `/build {bead_id}`
```

---

## Phase 5: Resume

```bash
bd update $ARGUMENTS --status in_progress
```

Create TodoWrite from action items in handoff.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No handoff found | Use `/start {bead_id}` |
| Git diverged significantly | Review changes with `git diff`, decide to reset or continue |
| Artifacts missing | Check `.beads/artifacts/`, may need `/research` again |
| Bead not found | `bd list` to find correct ID |
