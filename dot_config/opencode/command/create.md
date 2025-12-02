---
description: Create a new task with specification
agent: build
subtask: false
---

# Create New Task

Interview to understand the task, then create a bead and specification.

## Guardrails

- **No code during this phase** - Only create specification documents
- **Identify ambiguity first** - Ask clarifying questions before writing spec
- **Keep scope tight** - Better to under-scope than over-scope
- **Explicit is better than implicit** - Document assumptions

## Steps

Track these as TODOs and complete one by one:

### Step 1: Interview

Ask these questions (one at a time):

1. **What** do you want to build/fix/change?
2. **Why** is this needed? What problem does it solve?
3. **How** will we know it's done? (acceptance criteria)

### Step 2: Clarify Ambiguity

If answers are vague or ambiguous:
- Ask follow-up questions
- Propose specific solutions
- Get explicit confirmation

**If you cannot identify a clear scope, STOP and ask for clarification.**

### Step 3: Create Bead

```bash
bd create "$ARGUMENTS" -t task -p 2 --json | jq -r '.id'
```

Use type:
- `bug` - Something broken
- `feature` - New capability
- `task` - General work
- `epic` - Large multi-part work
- `chore` - Maintenance

### Step 4: Write Specification

Create `.beads/artifacts/<bead-id>/spec.md`:

```markdown
---
date: [timestamp]
bead: [id]
type: [type]
priority: [0-3]
---

# [Title]

## Problem Statement
[What problem are we solving? Why does it matter?]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2

## Success Criteria
- [How we know it's done - measurable]

## Out of Scope
- [What we're explicitly NOT doing]

## Assumptions
- [What we're assuming to be true]
```

### Step 5: Validate & Confirm

Before presenting:
- [ ] All requirements are testable
- [ ] Success criteria are measurable
- [ ] Scope is realistic for one work unit

Present the spec and ask:

> Does this correctly capture what you want? Ready to proceed?

**WAIT for human approval before continuing.**

## Reference

- `bd list` - See existing beads
- `bd show <id>` - View bead details
- `ls .beads/artifacts/` - Check existing artifacts
