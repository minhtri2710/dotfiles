---
description: Deep codebase exploration with interactive review
subtask: true
---

# /research - Interactive Exploration

Explore → Synthesize → Present → Iterate → Finalize.

**Mode**: Interactive (user invoked) or Autonomous (subtask from `/start`).

## Input & Flags

`$ARGUMENTS` - Bead ID (must have spec.md)

| Flag | Effect |
|------|--------|
| `--quick` | Internal scan only, skip external |
| `--precision` | Enable LSP/AST deep tracing |

---

## Phase 0: Validate

1. **Block child beads** - If ID contains `.`, stop:
   ```
   STOP: Cannot research child bead. Research at epic level.
   Parent: {parent_id} → /research {parent_id}
   ```

2. **Check spec.md exists** - `cat .beads/artifacts/{bead_id}/spec.md`
   - BLOCK if missing → `/create` first

---

## Phase 1: Understand

Read before spawning agents:
1. `bd show {bead_id}`
2. `.beads/artifacts/{bead_id}/spec.md`
3. `.beads/artifacts/{bead_id}/exploration-context.md` (if exists from `/start`)

**If exploration-context.md exists**: Skip locate/librarian in Phase 2 (already done).

---

## Phase 2: Parallel Exploration

### Sequence: Locate → Patterns → Analyze → External

**2a. Locate** (skip if exploration-context.md exists):
```typescript
background_task(agent="explore", prompt="Find files related to {component A}")
background_task(agent="explore", prompt="Find files related to {component B}")
```
**WAIT** for results.

**2b. Patterns**:
```typescript
background_task(agent="explore", prompt="Find similar implementations, patterns, conventions")
// --precision flag:
background_task(agent="explore", prompt="Trace call graph from {entry_point}")
```
**WAIT** for results.

**2c. Analyze**:
```typescript
background_task(agent="explore", prompt="Analyze how {component} works, data flow")
```
**WAIT** for results.

**2d. External** (skip if `--quick` or exploration-context.md has docs):
```typescript
background_task(agent="librarian", prompt="Best practices for {technology}")
```

---

## Chesterton's Fence

> Before changing code, explain WHY it exists. If you can't explain it, research deeper.

Document: `auth.ts:145` - Retry loop exists because OAuth tokens expire mid-request.

---

## Phase 3: Synthesize

Organize findings: **Architecture** | **Patterns** | **Dependencies** | **Risks** | **Chesterton's Fence**

---

## Phase 4: Write research.md

`.beads/artifacts/{bead_id}/research.md`:

```markdown
---
date: {ISO timestamp}
git_commit: {HEAD}
branch: {current branch}
bead: {bead_id}
---

## Summary
- Finding 1
- Finding 2

## Architecture
- `path/to/file.ts:123` - {purpose}

## Patterns
- `file.ts:67` - Pattern for {X}

## Dependencies
| Dependency | Type | Impact |
|------------|------|--------|
| {dep} | Hard/Soft | {impact} |

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| {risk} | H/M/L | H/M/L | {strategy} |

## Chesterton's Fence
- `file.ts:123` - {why it exists}

## Implementation Options
### Option A: {name}
- **Files**: {list with file:line}
- **Effort**: S/M/L
- **Pros/Cons**: {tradeoffs}

## Dependency Map
| Task | Depends On | Blocking |
|------|------------|----------|
| {task1} | - | {task2} |

## Test Strategy
| Component | Type | Priority |
|-----------|------|----------|
| {comp} | Unit/Integration | MUST/SHOULD |

## Suggested Sequence
1. {highest risk} - validates assumptions
2. {next} - depends on #1
```

---

## Phase 5: Present & Discuss

**If subtask**: Skip → return summary and exit.

**If interactive**:

```
## Research Findings: {bead_id}

**How it works**: {summary with file:line}
**Key discovery**: {most important finding}
**Potential approach**: Based on this, I think we should {X}

Does this match your understanding?
```

**GATE: WAIT for user response.**

| User Says | Action |
|-----------|--------|
| "Dig deeper on X" | Spawn new agent → update research.md → re-present |
| "That's wrong" | Investigate correction → revise → re-present |
| "Looks good" | Proceed to Phase 6 |

Push back with evidence if user's assumptions conflict with code.

---

## Phase 6: Finalize

**If subtask**:
```
Research complete for {bead_id}. Artifact: .beads/artifacts/{bead_id}/research.md
```

**If interactive**:
```
## Research Approved
**Artifact**: .beads/artifacts/{bead_id}/research.md
**Next**: /plan {bead_id}
```

---

## Epistemic Hygiene

| Say | Not |
|-----|-----|
| "I verified in `file.ts:123`" | "I believe..." |
| "I found 3 instances in..." | "There are probably..." |
| "I couldn't find evidence of..." | "There is no..." |

**Every claim MUST have `file:line` reference.**

---

## Rules

| Rule | Rationale |
|------|-----------|
| Block child beads | Research at epic level |
| Spec must exist | Research needs scope |
| Check exploration-context.md | Avoid redundant work |
| Every finding needs `file:line` | Verifiable |
| Push back with evidence | Don't blindly agree |
