---
description: Capture state for session continuity
subtask: false
---

# /handoff - Session Continuity

Capture current state for context compaction or session end.

**Input:** `$ARGUMENTS` - Bead ID  
**Output:** `.beads/artifacts/{bead_id}/handoffs/{YYYY-MM-DD}_handoff.md`

---

## When to Use

| Trigger | Trigger |
|---------|---------|
| Context ~60% full | Before risky operation |
| End of work session | Switching tasks |
| Long-running implementation | Periodic checkpoint |

---

## Phase 1: Gather State

```bash
git rev-parse HEAD && git branch --show-current && git status --porcelain
bd show $ARGUMENTS
```

For child beads: include parent bead ID and parent's plan.md phase.

---

## Phase 2: Write Handoff

`.beads/artifacts/{bead_id}/handoffs/{YYYY-MM-DD}_handoff.md`:

```markdown
---
date: {ISO timestamp}
bead: {bead_id}
parent: {parent_id or null}
repository: {repo name}
git_commit: {SHA}
branch: {branch}
plan_phase: {current phase from plan.md}
status: {open|in_progress|blocked}
---

# Handoff: {bead_id}

## Current Task
{What was being worked on}

## Critical References
| File | Line | Why |
|------|------|-----|
| {file} | {line} | {reason needed on resume} |

## Parent Context
<!-- If child bead -->
- Parent: {parent_id}
- Plan phase: {phase N of M}
- Siblings: {other child beads and their status}

## Recent Changes
- {file}: {what changed}

## Learnings
1. **{Gotcha/Fence/Edge}**: {description with file:line}

## Verification Status
| Check | Status | Notes |
|-------|--------|-------|
| Build | ✅/❌ | {details} |
| Tests | ✅/❌ | {details} |
| Lint | ✅/❌ | {details} |

## Action Items
1. **Immediate**: {next step}
2. **Then**: {following step}

## Blockers
- [ ] {unresolved question/decision}

---
Resume: `/rehydrate {bead_id}`
```

---

## Phase 3: Sync

```bash
bd sync --pull
```

---

## Rules

| Rule | Rationale |
|------|-----------|
| Ground all claims with `file:line` | Verifiable on resume |
| Include verification status | Know what passed/failed |
| Track parent context for child beads | Understand hierarchy |
| Use frontmatter for structured data | Machine-readable |
