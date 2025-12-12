---
name: quick-fix
description: >
  Zero-overhead path for trivial fixes. Skips bead creation, artifacts, and coach validation.
  Use for: typos, comment fixes, single-line changes, formatting, obvious one-liner bugs.
  Triggers: "quick fix", "just fix", "typo", "one-liner", "simple change", "trivial".
---

# Quick Fix - Zero-Overhead Trivial Changes

Bypass the full workflow for changes so small they don't warrant tracking.

## When to Use

| Use quick-fix | Use /task or /start instead |
|---------------|----------------------------|
| Typo in docs/comments | Any logic change |
| Single-line obvious fix | Changes to >2 files |
| Formatting/whitespace | Security-related code |
| Rename variable (1 file) | API/interface changes |
| Fix broken link | Database/schema changes |
| Update version number | Auth/payment code |

**Rule**: If you need to think about it, it's not a quick-fix.

## Workflow

```
1. Verify → 2. Fix → 3. Verify → 4. Commit
```

No beads. No artifacts. No coach. Just do it.

## Steps

### Step 1: Verify Scope

Before proceeding, confirm:

```
□ Single file (or 2 files max)
□ < 10 lines changed
□ No behavior change (or obviously correct fix)
□ No tests needed (or existing tests sufficient)
□ Not in: auth, payment, security, API contracts
```

**If ANY check fails** → Use `/task` instead.

### Step 2: Make the Fix

```bash
# Read the file
read <file>

# Make the edit
edit_file <file> <old> <new>
```

### Step 3: Verify

```bash
# Type check (if applicable)
<typecheck-command>  # e.g., npx tsc --noEmit

# Run related tests (if any exist)
<test-command> <specific-test>  # e.g., npm test -- --grep "related"

# Lint
<lint-command>  # e.g., npm run lint
```

**All must pass.** If anything fails, reassess whether this is truly a quick-fix.

### Step 4: Commit

Use conventional commit format:

```bash
git add <file>
git commit -m "fix: <brief description>"
```

**Commit prefixes for quick-fixes**:
- `fix:` - Bug fix
- `docs:` - Documentation
- `style:` - Formatting, whitespace
- `chore:` - Maintenance, version bumps
- `typo:` - Typo correction (non-standard but clear)

## Examples

### Example 1: Typo Fix

```
User: "Fix the typo in README.md"

Agent:
1. read README.md
2. edit_file README.md "recieve" "receive"
3. git add README.md && git commit -m "docs: fix typo in README"

Done. No bead needed.
```

### Example 2: Version Bump

```
User: "Bump version to 1.2.3"

Agent:
1. read package.json
2. edit_file package.json '"version": "1.2.2"' '"version": "1.2.3"'
3. npm run build  # verify
4. git add package.json && git commit -m "chore: bump version to 1.2.3"

Done.
```

### Example 3: Scope Escalation

```
User: "Quick fix this null check"

Agent:
1. read src/auth/validator.ts
2. Sees: This is in auth code, affects validation logic
3. STOP: "This touches auth validation. Using /task for proper tracking."
4. /task Fix null check in auth validator
```

## Anti-Patterns

| Don't | Why |
|-------|-----|
| Skip verification | Even trivial changes can break builds |
| Chain quick-fixes | If doing 3+, use proper workflow |
| Quick-fix in unfamiliar code | You might miss implications |
| Quick-fix without reading context | Understand before changing |

## Escape Hatches

**Promote to tracked work**:
```bash
# If quick-fix grows in scope
/task <description of what you discovered>
```

**Abort**:
```bash
# If something goes wrong
git checkout -- <file>  # Discard changes
```

## Verification Commands

Quick-fix still requires passing quality gates:

```bash
# Minimum verification (REQUIRED)
<build-command>   # Must pass

# If tests exist for the area
<test-command>    # Must pass

# Lint (if configured)
<lint-command>    # Must pass
```

## Decision Flowchart

```
Is it a typo/formatting/comment-only change?
├─ YES → Quick-fix
└─ NO ↓

Is it a single obvious bug fix (< 5 lines)?
├─ YES → Is it in auth/payment/security code?
│        ├─ YES → /task (needs tracking)
│        └─ NO → Quick-fix
└─ NO → /task or /start
```
