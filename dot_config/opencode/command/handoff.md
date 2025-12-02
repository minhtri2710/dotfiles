---
description: Capture state for session continuity
agent: build
subtask: false
---

# Handoff Session

Capture current state for bead: $ARGUMENTS

## When to Use

- Approaching context limit
- End of work session
- Before complex/risky operation
- Switching to different task

## Step 1: Capture Git State

!`git status --short`
!`git log --oneline -5`
!`git diff --stat`

## Step 2: Identify In-Progress Work

- What was being worked on?
- What's the current state?
- What's blocking (if anything)?

## Step 3: Create Handoff

Save to `.beads/artifacts/$ARGUMENTS/handoffs/[date]_handoff.md`:

```markdown
---
date: [ISO timestamp]
bead: $ARGUMENTS
branch: [branch]
commit: [HEAD sha]
---

# Handoff: $ARGUMENTS

## Current State
[What's done, what's in progress]

## Last Action
[What was just completed]

## Next Steps
1. [Immediate next action]
2. [Following action]
3. [After that]

## Blockers
- [Any blockers or questions]

## Context
- [Key files being modified]
- [Important decisions made]
- [Things to remember]

## Commands to Resume
```bash
git checkout [branch]
cd [directory]
npm test -- [specific test if relevant]
```

## Uncommitted Changes
[List or "none"]
```

## Step 4: Confirm

```markdown
## Handoff Created

Saved: `.beads/artifacts/$ARGUMENTS/handoffs/[file]`

To resume later:
```
/resume $ARGUMENTS
```
```

## Optional: Sync

If stopping work:

```bash
bd sync
git push
```
