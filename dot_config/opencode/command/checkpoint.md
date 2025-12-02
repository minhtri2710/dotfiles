---
description: Mid-session context compression
agent: build
subtask: false
---

# Checkpoint

Compress context mid-session.

## When to Use

- Context getting large
- Completed a logical unit
- Before switching focus
- At natural breakpoint

## Step 1: Summarize Work

```markdown
## Checkpoint

### Completed
- [x] [Task 1]
- [x] [Task 2]

### In Progress
- [ ] [Current task]

### Key Decisions
- [Decision 1 - why]
- [Decision 2 - why]

### Files Modified
- `file.ts` - [what changed]

### Current State
- Branch: [branch]
- Tests: passing/failing
- Build: passing/failing
```

## Step 2: Prune Context

Safe to forget:
- Exploration that led nowhere
- Intermediate debugging steps
- Raw tool output (keep summary)
- Files fully reviewed (keep conclusions)

Keep in context:
- Current task and goals
- Key file references
- Decisions and rationale
- Blockers and questions

## Step 3: Confirm

```markdown
## Context Compressed

Retained:
- [Key item 1]
- [Key item 2]

Pruned:
- [Removed item 1]
- [Removed item 2]

Ready to continue.
```
