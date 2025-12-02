---
description: Pre-PR code review
agent: reviewer
subtask: true
---

# Review Changes

Self-review before PR.

## Step 1: Check Status

!`git branch --show-current`
!`git diff main --stat`

## Step 2: Run Checks

```bash
npm run build
npm test
npm run lint
```

All must pass.

## Step 3: Check for Issues

```bash
# Console.logs
git diff main --unified=0 | grep "^+" | grep "console\." || echo "None"

# Any casts
git diff main --unified=0 | grep "^+" | grep ": any" || echo "None"

# TODOs
git diff main --unified=0 | grep "^+" | grep -E "TODO|FIXME" || echo "None"
```

## Step 4: Spawn Reviewer

```
@reviewer: Review changes between main and HEAD.

Focus on:
- Logic errors
- Missing error handling
- Security issues
- Performance
```

## Step 5: Report

```markdown
## Review Summary

### Checks
- Build: ✓/✗
- Tests: ✓/✗
- Lint: ✓/✗

### Critical (Must Fix)
- `file.ts:45` - [issue]

### Suggested
- `file.ts:78` - [issue]

### Verdict
[READY / NEEDS FIXES]
```
