---
description: Design options and implementation planning with interactive review
subtask: false
---

# /plan - Interactive Planning

Options → Choose → Detail → Walk Through → Child Beads.

## Input & Flags

`$ARGUMENTS` - Bead ID (must have spec.md, should have research.md)

| Flag | Effect |
|------|--------|
| `--quick` | Single option, minimal discussion |
| `--confirm-only` | Present plan, yes/no only |

---

## Principles

| Principle | Meaning |
|-----------|---------|
| **ETC** | Easy To Change later |
| **Tracer Bullets** | Working end-to-end first |
| **Orthogonality** | Independent components |
| **Design it Twice** | 2+ approaches before committing |
| **Deep Modules** | Simple interfaces, complex internals |
| **Chesterton's Fence** | Explain WHY before changing |

---

## Phase 0: Validate

```bash
# Child bead check
bd show $ARGUMENTS --json | jq -e '.parent_id' && echo "STOP: Plan at EPIC level, not child bead"
```

**BLOCK if child bead** → direct to `/plan {parent_id}` or `/build {bead_id}`.

**Read research COMPLETELY** before planning. Don't skim.

---

## Phase 1: Gather Context

```bash
skill("beads")
bd show $ARGUMENTS
cat .beads/artifacts/{bead_id}/spec.md
cat .beads/artifacts/{bead_id}/research.md
```

**BLOCK if**: No spec.md → run `/create` first.

```typescript
background_task(agent="explore", prompt=`Analyze key files from research.md. Return: patterns, interfaces (file:line)`)
background_task(agent="explore", prompt=`Find similar features to model after (file:line)`)
background_task(agent="librarian", prompt=`Best practices for {technology}: docs, pitfalls`)
```

---

## Phase 2: Design Options

**GATE: WAIT for user to choose before proceeding.**

```
## Design Options for {title}

### Option A: {name}
**Approach**: {description}
**Pros**: {list} | **Cons**: {list}
**Effort**: S/M/L | **Risk**: L/M/H

### Option B: {name}
...

### Recommendation
Option {X} because {reasoning}.

Which approach?
```

---

## Phase 3: Risk Assessment

| Level | Criteria | Plan Detail |
|-------|----------|-------------|
| Low | 1-2 files, understood | Brief, minimal phases |
| Medium | 3-5 files, some unknowns | Detailed, clear phases |
| High | 6+ files, critical, unknowns | Comprehensive, coach checkpoints |

---

## Phase 4: Write plan.md

`.beads/artifacts/{bead_id}/plan.md`:

```markdown
# Plan: {title}
**Bead**: {bead_id} | **Date**: {date} | **Risk**: L/M/H

## Chosen Approach
**Option**: {chosen} | **Rationale**: {why}

## Phases

### Phase 1: {name}
**Goal**: {accomplishes}
**Files**: `path/file.ts` - {change}
**Changes**: 1. {specific}
**Success**: [ ] {criterion}
**Verify**: [ ] lsp_diagnostics clean

### Phase 2: {name}
**Depends on**: Phase 1
...

## Testing
- Unit: {tests}
- Integration: {tests}
- Manual: [ ] {check}

## Rollback
1. {step}

## Out of Scope
- {item} → new bead
```

---

## Phase 5: Walk Through

**High-risk phases**: Present individually, wait for approval.
**Low-risk phases**: Group, ask for concerns.

---

## Phase 6: Create Child Beads

**GATE: ONLY after user explicitly approves.**

For 2+ phases:

```bash
bd create "[Phase 1] {name}" --type task --parent {bead_id} --description "$(cat <<'EOF'
## Context
{1-2 sentences}

## Key Changes
- `file.ts` - {what}

## Patterns
- See `similar_file:line`

## Success
- [ ] {criterion}

## References
- Plan: .beads/artifacts/{bead_id}/plan.md
EOF
)"

bd dep add {phase2_id} {phase1_id}
```

Rich descriptions enable standalone execution. Bad: "Implement phase 1". Good: "Add UserProfile with avatar upload. Files: src/components/UserProfile.tsx. Handle: validation, progress, errors."

---

## Phase 7: Finalize

```
## Plan Approved
**Plan**: .beads/artifacts/{bead_id}/plan.md

| ID | Phase | Description | Blocked By |
|----|-------|-------------|------------|
| {id_1} | 1 | {desc} | - |
| {id_2} | 2 | {desc} | {id_1} |

**Next**: /build {id_1}
```

---

## Epistemic Hygiene

| Say | Not |
|-----|-----|
| "I verified in `file:line`" | "I believe..." |
| "Research shows X at `file:line`" | "It seems like..." |

---

## Rules

| Rule | Rationale |
|------|-----------|
| Read research completely | Don't skim before planning |
| Spec must exist first | Plan needs requirements |
| Present options interactively | User chooses |
| Child beads ONLY after approval | Prevents waste |
| Rich child descriptions | Must enable standalone execution |
| WAIT for acknowledgment | Alignment |
| Push back with evidence | Don't be a yes-machine |
| Explain WHY before changing | Chesterton's Fence |
