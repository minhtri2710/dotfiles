---
name: coach-gate
description: >
  Enforces adversarial validation before task completion. Checks for APPROVED verdict,
  graph health (no cycles), and quality gates. Use when validating work before /finish,
  reviewing implementation quality, or enforcing the Coach-Player pattern.
  Triggers: "validate", "coach check", "ready to finish", "quality gate", "review gate".
---

# Coach Gate - Adversarial Validation Enforcement

Programmatic enforcement of the Coach-Player pattern. No self-reported completion is trusted.

## Purpose

The Coach-Player pattern creates adversarial cooperation:
- **Player** (implementer): Executes work, reports completion
- **Coach** (validator): Independently verifies, challenges assumptions

This skill **enforces** the pattern rather than just documenting it.

## Gate Checks

| Check | Command | Pass Criteria |
|-------|---------|---------------|
| **Verdict** | Check `review.md` | Contains `Verdict: APPROVED` |
| **Graph Health** | `bv --robot-insights \| jq '.Cycles'` | Empty array `[]` |
| **Build** | `<build-command>` | Exit code 0 |
| **Tests** | `<test-command>` | Exit code 0 |
| **Lint** | `<lint-command>` | Exit code 0, no new errors |

## Validation Workflow

### Step 1: Check Review Artifact

```bash
# Verify review.md exists and contains APPROVED
cat .beads/artifacts/$BEAD_ID/review.md | grep -q "Verdict: APPROVED"
```

**If missing or NOT_APPROVED**:
```
GATE FAILED: No approved review found.

Run /coach $BEAD_ID first.
```

### Step 2: Check Graph Health

```bash
# Check for circular dependencies
bv --robot-insights | jq '.Cycles'
```

**Expected**: `[]` (empty array)

**If cycles detected**:
```
GATE FAILED: Circular dependencies detected.

Cycles found:
- A → B → C → A

Fix cycles before proceeding:
  bv --robot-insights | jq '.Cycles'
  bd dep remove <child> <parent>
```

### Step 3: Quality Gates

```bash
# Build
<build-command>
# Exit 0 required

# Tests
<test-command>
# Exit 0 required

# Lint
<lint-command>
# Exit 0 required, no new errors
```

### Step 4: Render Verdict

**All Passed**:
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ✅ COACH GATE PASSED             ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃  Bead: $BEAD_ID                   ┃
┃  Review: APPROVED                 ┃
┃  Graph: No cycles                 ┃
┃  Build: ✓                         ┃
┃  Tests: ✓                         ┃
┃  Lint: ✓                          ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃  Ready for: /finish $BEAD_ID      ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Any Failed**:
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ❌ COACH GATE FAILED             ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃  Bead: $BEAD_ID                   ┃
┃  Review: MISSING                  ┃
┃  Graph: 2 cycles                  ┃
┃  Build: ✓                         ┃
┃  Tests: ✗ (3 failing)             ┃
┃  Lint: ✓                          ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃  Fix issues, then retry.          ┃
┃  Run: /coach $BEAD_ID             ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

## 3-Strike Rule

Track validation attempts in review.md:

```markdown
## Validation History
| Attempt | Date | Result | Issues |
|---------|------|--------|--------|
| 1 | 2025-12-28 | NOT_APPROVED | Missing tests |
| 2 | 2025-12-28 | NOT_APPROVED | Type errors |
| 3 | 2025-12-28 | NOT_APPROVED | Lint failures |
```

**After 3 failures**:
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  🚫 TASK BLOCKED                  ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃  3 validation failures reached.   ┃
┃                                   ┃
┃  This signals an architectural    ┃
┃  problem, not "try harder".       ┃
┃                                   ┃
┃  Escalating to human review.      ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

Failure Pattern:
1. [Issue from attempt 1]
2. [Issue from attempt 2]
3. [Issue from attempt 3]

Recommendation: [Plan revision | Architecture change | Human decision]
```

Update bead status:
```bash
bd update $BEAD_ID --status blocked --notes "3-strike rule: validation failed 3x"
```

## Integration Points

### With /coach

`/coach` generates the review.md artifact. Coach-gate validates it exists and passed.

```
/implement → /coach → coach-gate → /finish
                ↑          |
                └──────────┘ (retry loop)
```

### With /finish

`/finish` should load this skill and run gate checks before proceeding:

```markdown
# In /finish command
1. Load skill("coach-gate")
2. Run gate validation
3. If FAILED → stop, show issues
4. If PASSED → proceed to commit
```

### With Swarm

For swarm workers, use `swarm_review_feedback` which implements similar logic:

```typescript
swarm_review_feedback({
  status: "approved" | "needs_changes",
  issues: "..."
});
```

## Spec Anchoring

All validation must trace back to requirements:

```markdown
## Requirements Compliance (from spec.md)

| Requirement | Spec Ref | Evidence | Status |
|-------------|----------|----------|--------|
| [FR-1] User login | spec.md:L15 | auth/login.ts:45 | ✅ |
| [FR-2] Session timeout | spec.md:L22 | auth/session.ts:30 | ✅ |
| [NFR-1] < 200ms response | spec.md:L45 | perf-test.log | ✅ |
```

**Rules**:
- Every requirement needs file:line evidence
- "I implemented it" is NOT evidence
- If it's not in spec, it's not a requirement (don't fail for extras)
- Missing test = NOT verified

## Beyond Spec (Info Only)

Note observations that are NOT failures:

```markdown
## Beyond Spec (Info Only)
- Could refactor auth/utils.ts for clarity (not required)
- Consider adding rate limiting (not in spec)
- Test coverage could be higher (spec says "tests pass", not coverage %)
```

These are informational. Do NOT fail validation for them.

## Quick Reference

```bash
# Full gate check
skill("coach-gate")

# Manual checks
cat .beads/artifacts/$ID/review.md | grep "Verdict:"
bv --robot-insights | jq '.Cycles'
<build-command> && <test-command> && <lint-command>
```

## Error Recovery

| Error | Resolution |
|-------|------------|
| No review.md | Run `/coach $BEAD_ID` first |
| Verdict NOT_APPROVED | Fix issues listed in review.md |
| Cycles detected | `bd dep remove` to break cycles |
| Build fails | Fix compilation errors |
| Tests fail | Fix or update tests |
| 3 strikes | Escalate to human, mark blocked |
