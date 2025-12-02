---
description: Create implementation plan from research
agent: plan
subtask: false
---

# Create Implementation Plan

Design the approach for bead: $ARGUMENTS

## Guardrails

- **No code during this phase** - Only create plan documents
- **Favor minimal implementation** - Add complexity only when required
- **Keep changes tightly scoped** - One concern per phase
- **Verify before proceeding** - Check all required context exists

## Prerequisites

Load research first:

```bash
cat .beads/artifacts/$ARGUMENTS/research.md 2>/dev/null || echo "No research - run /research first"
```

**If no research exists, STOP and run /research first.**

## Steps

Track these as TODOs and complete one by one:

### Step 1: Review Context

Before planning, verify you understand:
- [ ] What files need changes? (from research.md)
- [ ] What patterns to follow? (from codebase)
- [ ] What risks exist? (from research.md)

### Step 2: Design Approach

Consider these in order:
1. **Smallest possible change** - What's the minimum diff?
2. **Existing patterns** - What similar code exists to match?
3. **Testing strategy** - How will we verify?
4. **Rollback plan** - How do we undo if wrong?

### Step 3: Break Into Phases

Each phase MUST:
- Be independently verifiable (can test after this phase alone)
- Have clear success criteria (pass/fail, no ambiguity)
- Take < 30 minutes (if longer, split it)

### Step 4: Write Plan

Save to `.beads/artifacts/$ARGUMENTS/plan.md`:

```markdown
---
date: [timestamp]
bead: $ARGUMENTS
approach: [chosen approach]
estimated_effort: [time]
---

# Plan: [title]

## Overview
[What we're building - 1-2 sentences]

## Approach
[High-level strategy]

## NOT Doing
- [Explicit out-of-scope item]

---

## Phase 1: [name]

### Changes
- [ ] `path/file.ts` - [change description]

### Verification
- [ ] Build passes
- [ ] Tests pass
- [ ] [Specific check for this phase]

---

## Phase 2: [name]

### Changes
- [ ] `path/file.ts` - [change description]

### Verification
- [ ] Build passes
- [ ] Tests pass

---

## Testing Strategy

### New Tests
- [ ] `file.test.ts` - [what it tests]

### Coverage
- [ ] Happy path
- [ ] Edge cases
- [ ] Error handling

---

## Commands

```bash
npm run build
npm test
npm run lint
```
```

### Step 5: Validate Plan

Before presenting:
- [ ] Every phase has verification steps
- [ ] No phase exceeds 30 minutes
- [ ] Testing strategy covers requirements from spec
- [ ] Out-of-scope section explicitly lists what we're NOT doing

### Step 6: Get Approval

Present plan and ask:

> Plan ready for review. Approve this approach?

**WAIT for human approval before /implement.**

## Reference

- `cat .beads/artifacts/$ARGUMENTS/spec.md` - Original requirements
- `cat .beads/artifacts/$ARGUMENTS/research.md` - Research findings
- `bd show $ARGUMENTS` - Bead details
- `codesearch` - API patterns and library examples
- `websearch` - Best practices and documentation
