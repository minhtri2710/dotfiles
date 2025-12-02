---
description: Verify gates, commit, and close bead
agent: build
subtask: false
---

# Finish Task

Complete bead: $ARGUMENTS

## Guardrails

- **All gates must pass** - No exceptions
- **Verify before closing** - Don't trust memory, run checks
- **Conventional commits** - Follow commit message format
- **Sync before done** - Session not complete until pushed

## Prerequisites

Verify implementation is complete:

```bash
cat .beads/artifacts/$ARGUMENTS/plan.md 2>/dev/null || echo "No plan found"
```

Check all phases are marked complete in plan.md.

**If phases remain incomplete, STOP and return to /implement.**

## Steps

Track these as TODOs and complete one by one:

### Step 1: Final Verification

Run all quality gates:

```bash
npm run build
npm test
npm run lint
```

**ALL MUST PASS. If any fail, STOP and fix first.**

### Step 2: Self-Review

Quick review checklist:
- [ ] Any `console.log` left?
- [ ] Any `any` type casts?
- [ ] Any TODO comments left behind?
- [ ] Any commented-out code?

```bash
rg "console\.log|TODO|FIXME|any\s*\)" --type ts
```

### Step 3: Review Changes

```bash
git diff --stat
git diff --name-only
```

Verify changes match plan:
- [ ] Only expected files modified
- [ ] No unrelated changes included

### Step 4: Stage Changes

```bash
git add -A
git status
```

Review staged files before committing.

### Step 5: Create Commit

Use conventional commit format:

```bash
git commit -m "feat($ARGUMENTS): [summary]

- [change 1]
- [change 2]

Closes: $ARGUMENTS"
```

Types:
- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code change (no behavior change)
- `test` - Tests only
- `docs` - Documentation
- `chore` - Maintenance

### Step 6: Close Bead

```bash
bd close $ARGUMENTS --reason "Completed: [summary]"
```

### Step 7: Sync (MANDATORY)

```bash
bd sync
git push
```

**Session is NOT complete until `git push` succeeds.**

### Step 8: Summary

```markdown
## Completed: $ARGUMENTS

### Commit
`[sha]` - [message]

### Changes
- `file.ts` - [summary]

### Verification
- Build: ✓
- Tests: ✓
- Lint: ✓
- Pushed: ✓

### Bead Status
Closed ✓
```

## Error Handling

If gates fail at this stage:
1. Do NOT force close the bead
2. Return to /implement to fix
3. Re-run /finish when fixed

## Reference

- `cat .beads/artifacts/$ARGUMENTS/plan.md` - Check phases complete
- `cat .beads/artifacts/$ARGUMENTS/spec.md` - Verify requirements met
- `git log --oneline -5` - Recent commits
- `bd show $ARGUMENTS` - Bead details
