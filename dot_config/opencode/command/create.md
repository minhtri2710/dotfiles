---
description: Interview user → create bead with spec artifact
subtask: false
---

# /create - Structured Task Intake

Interview → Classify → Create Bead → Write Spec.

## Input

`$ARGUMENTS` - Initial task description (can be vague)

---

## Phase 1: Problem Interview

**⚠️ GATE: Must have clear answers before proceeding.**

Ask ONE question at a time (max 3-5 total):

| # | Question | Purpose |
|---|----------|---------|
| 1 | What specific problem are you solving? | WHY, not WHAT |
| 2 | Who is affected and how? | User impact |
| 3 | How will we know when it's done? | Observable success |
| 4 | What's explicitly OUT of scope? | Boundaries |
| 5 | Any technical/timeline constraints? | Limitations |

**Rules:** Wait for response. Probe vague answers ("What do you mean by 'better'?"). Summarize before proceeding. **Minimum: Clear answers to 1-3.**

---

## Phase 2: Classify

| Type | Criteria | Priority |
|------|----------|----------|
| `bug` | Something broken | P0-P1 |
| `feature` | New capability | P1-P2 |
| `task` | Refactor, chore | P2-P3 |
| `epic` | Multiple subtasks | P1-P2 |

**Title:** Generate specific, action-oriented (e.g., "Fix null pointer in UserService.getProfile when user has no avatar"). **GATE: Confirm title with user.**

---

## Phase 3: Find Dependencies (Parallel)

```typescript
background_task(agent="developer", prompt=`List open beads. Find related to: {task_description}. Return: parent epics, blockers.`)
background_task(agent="explore", prompt=`Search semantic memory for: {task_description}. Return: prior decisions, patterns.`)
background_output(task_id="...")
```

Ask: "Is this related to existing work? Does it depend on or block anything?"

---

## Phase 4: Create Bead

```bash
bd create --from-template {template} "{title}" --priority {priority}
bd update {bead_id} --path deep
mkdir -p .beads/artifacts/{bead_id}
```

---

## Phase 5: Write Spec

Write to `.beads/artifacts/{bead_id}/spec.md`:

```markdown
# Spec: {title}

**Bead**: {bead_id} | **Type**: {type} | **Created**: {date}

## Problem Statement
{Why this change is needed}

## Requirements
### MUST (Critical)
- [ ] {requirement}

### SHOULD (Important)
- [ ] {requirement}

## Scope
**In:** {items}
**Out:** {items with reasons}

## Success Criteria
- [ ] {testable criterion}

## Open Questions
- {question}
```

**GATE: Present spec. WAIT for user approval.**

---

## Phase 6: Report & Route

```
## Task Created
**Bead**: {bead_id} | **Title**: {title} | **Type**: {type}
**Spec**: .beads/artifacts/{bead_id}/spec.md

**Next**: Simple (1-2 files) → `/build` | Complex (3+) → `/research` → `/plan`
```

---

## Rules

| Rule | Rationale |
|------|-----------|
| Interview first | Clear requirements prevent rework |
| Generate + confirm title | Ensure shared understanding |
| Write spec before work | Reference point for completion |
| Default to action | After confirm, create immediately |
| Artifacts are LOCAL-ONLY | `.beads/artifacts/` in .gitignore, never commit |
