---
description: Adversarial review against requirements - independent validation (dialectical autocoding)
subtask: true
---

# /coach - Adversarial Validation

Independent verification against spec.md. Does NOT trust self-reports.

**Input:** `$ARGUMENTS` - Bead ID to validate

**Role:** Validate against ORIGINAL requirements. You do NOT implement—you VERIFY.

---

## Adversarial Principles

| Principle | Meaning |
|-----------|---------|
| Don't trust self-reports | Verify independently with tools |
| Anchor to spec.md | If not in spec, not a requirement |
| Specific feedback | "Fix auth.ts:45" not "improve auth" |
| No scope creep | Don't fail for things not in spec |
| Max 10 turns | Then escalate |

---

## Phase 1: Gather Evidence (Parallel)

**Read ALL artifacts first:** spec.md, plan.md, research.md before judging.

```typescript
background_task(agent="explore", prompt=`Read spec.md and plan.md. List requirements and files.`)
background_task(agent="tester", prompt=`Run: build, test, lint. Return pass/fail with errors.`)
background_task(agent="reviewer", prompt=`Check each requirement has file:line evidence.`)
```

**Fallback:** `npm run build && npm test && npm run lint`

---

## Phase 2-4: Compliance & Gaps

```
**REQUIREMENTS COMPLIANCE:**
- [ ] Req 1: [PASS/FAIL] - file:line evidence
- [ ] Criterion 1: [VERIFIED/NOT VERIFIED]

**VERIFICATION RESULTS:**
Build: [PASS/FAIL] | Tests: [X/Y] | Lint: [CLEAN/N errors]

**GAPS (if any):**
Critical: [Gap] - Required by [spec section], Fix: [action]
```

---

## Phase 5: Verdict

**APPROVE only if:** ALL requirements implemented + ALL criteria met + Build ✓ + Tests ✓

```
## Verdict: APPROVED ✅
- [x] Requirement 1 - verified at `file:line`
- [x] Requirement 2 - verified at `file:line`

| Check | Status |
|-------|--------|
| Build | ✓ |
| Tests | ✓ (X/Y) |
| Lint | ✓ |
```

```
## Verdict: NOT APPROVED ⚠️
**Completion**: X/Y requirements

### Gaps
| Priority | Issue | Fix |
|----------|-------|-----|
| Critical | {gap} | `file:line` - {action} |

### Immediate Actions
1. {action} - blocks {requirement}
```

---

## Principles

| Principle | Meaning |
|-----------|---------|
| Don't trust self-reports | Verify independently |
| Anchor to spec.md | If not in spec, not a requirement |
| Specific feedback | "Fix auth.ts:45" not "improve auth" |
| No scope creep | Don't fail for things not in spec |
| Max 10 turns | Then escalate |
