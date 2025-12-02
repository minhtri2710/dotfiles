---
description: Quick fix bypassing full workflow for small changes
agent: build
subtask: false
---

# Quick Fix

For changes that are:
- Low risk
- < 15 minutes work
- Well-understood
- Self-contained

**No bead, no artifacts, just git.**

## When to Use

✅ Typo fixes
✅ Small bug fixes with obvious solution
✅ Config tweaks
✅ Dependency updates
✅ Documentation fixes

❌ New features (use /create)
❌ Complex debugging (use /debug)
❌ Risky changes (use full workflow)

## Step 1: Describe

What are you fixing?

> Describe the change in one sentence.

## Step 2: Verify Scope

```bash
git status --short
```

If there are existing uncommitted changes, STOP:
> Stash or commit existing work first.

## Step 3: Implement

Make the change directly. Keep it minimal.

## Step 4: Verify

```bash
npm run build
npm test
npm run lint
```

**All must pass.**

## Step 5: Commit

```bash
git add -A
git commit -m "fix: [one-line description]"
```

## Step 6: Done

```markdown
## Quick Fix Complete

Commit: `[sha]`
Change: [description]
Verified: ✅

Push when ready: `git push`
```
