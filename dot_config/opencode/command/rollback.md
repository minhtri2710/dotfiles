---
description: Recover from failed implementation
agent: build
subtask: false
---

# Rollback

Recover when implementation goes wrong.

## Step 1: Assess Damage

!`git status --short`
!`git diff --stat`

## Step 2: Choose Recovery Strategy

### Option A: Discard All Changes (Nuclear)

If everything is broken and you want to start fresh:

```bash
git reset --hard HEAD
git clean -fd
```

⚠️ **This deletes ALL uncommitted changes.**

### Option B: Stash for Later

If changes might be useful later:

```bash
git stash push -m "rollback: [reason]"
```

Recover later with: `git stash pop`

### Option C: Partial Reset

If only some files are broken:

```bash
git checkout HEAD -- path/to/broken/file.ts
```

### Option D: Revert Last Commit

If the last commit was bad:

```bash
git revert HEAD --no-edit
```

## Step 3: Document What Went Wrong

Create handoff with learnings:

```markdown
## Rollback: [bead-id]

### What Happened
[What went wrong]

### Root Cause
[Why it failed]

### Learnings
- [What we learned]
- [What to do differently]

### State After Rollback
- Branch: [branch]
- HEAD: [sha]
- Uncommitted: [yes/no]
```

## Step 4: Next Steps

1. Update the plan with new information
2. Consider smaller steps
3. Add more verification checkpoints
4. Resume with `/start [bead-id]`

## Emergency Commands

```bash
# See what you're about to lose
git diff

# Create safety backup branch
git branch backup-before-rollback

# Hard reset to specific commit
git reset --hard [sha]

# Recover accidentally deleted file
git checkout HEAD~1 -- path/to/file
```
