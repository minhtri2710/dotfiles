---
description: Continue work from handoff document
agent: build
subtask: false
---

# Resume from Handoff

Continue work on bead: $ARGUMENTS

## Step 1: Find Latest Handoff

```bash
ls -t .beads/artifacts/$ARGUMENTS/handoffs/*.md 2>/dev/null | head -1
```

## Step 2: Load Handoff

Read the latest handoff document:

```bash
cat $(ls -t .beads/artifacts/$ARGUMENTS/handoffs/*.md | head -1)
```

## Step 3: Verify State

Check current state matches handoff:

!`git status --short`
!`git branch --show-current`
!`git log --oneline -3`

If branch differs:
```bash
git checkout [branch from handoff]
```

## Step 4: Load Context

Read related artifacts:
- `spec.md` - Original requirements
- `research.md` - Codebase findings
- `plan.md` - Approved approach

## Step 5: Summarize

```markdown
## Resumed: $ARGUMENTS

### From Handoff
- Date: [date]
- Last action: [what was done]

### Current State
- Branch: [branch]
- Status: [clean/dirty]

### Next Steps (from handoff)
1. [next action]
2. [following action]

### Blockers
- [any blockers noted]

Ready to continue. What would you like to do?
```

## Step 6: Continue

Based on handoff next steps:
- If implementation incomplete → continue /implement
- If tests needed → write tests
- If review needed → /review
- If ready to finish → /finish
