---
description: Execute approved plan with continuous verification
agent: build
subtask: false
---

# Implement Plan

Execute the approved plan for bead: $ARGUMENTS

## Guardrails

- **Follow the plan exactly** - Don't add unrequested features
- **Minimal changes only** - Smallest diff that satisfies requirements
- **Verify after EVERY change** - Never skip verification
- **Stop on failure** - Max 3 attempts, then escalate

## Prerequisites

Verify plan exists and is approved:

```bash
cat .beads/artifacts/$ARGUMENTS/plan.md 2>/dev/null || echo "No plan - run /plan first"
```

**If no plan exists, STOP and run /plan first.**

## Steps

Track these as TODOs and complete one by one:

### Step 1: Load Context

- [ ] Read `plan.md` completely
- [ ] Read `spec.md` for requirements
- [ ] Identify current phase to implement

### Step 2: Implementation Loop

For each phase in plan.md:

#### 2.1: Read Phase
- What files to change?
- What's the success criteria?

#### 2.2: Implement
Use @implementer for focused changes:

```
@implementer: Implement [specific change] in [file]
Following pattern from [reference file:line]
```

#### 2.3: Verify (After EVERY Change)

```bash
npm run build
npm test
npm run lint
```

**All must pass before proceeding. If any fails, fix before continuing.**

#### 2.4: Mark Complete
- [ ] Update phase checklist in plan.md
- [ ] Summarize what was done

### Step 3: Quality Gates

Before marking implementation complete:

- [ ] **Build passes** - No compilation errors
- [ ] **All tests pass** - Existing + new tests
- [ ] **Lint passes** - No style violations
- [ ] **Plan tests written** - Tests from Testing Strategy section

## Error Handling

If verification fails:
1. **Attempt 1**: Fix the issue
2. **Attempt 2**: Try alternative approach
3. **Attempt 3**: Simplify the change
4. **After 3 failures**: **STOP** and escalate

When stopping, report:
- What was attempted
- What failed
- What you think the root cause is

## Output

```markdown
## Implementation: $ARGUMENTS

### Completed Phases
- [x] Phase 1: [name]
- [x] Phase 2: [name]

### Files Modified
- `path/file.ts` - [summary]
- `path/other.ts` - [summary]

### Tests Added
- `file.test.ts` - [what it tests]

### Verification
- Build: ✓
- Tests: ✓ (X passing)
- Lint: ✓

### Ready for /finish
```

## Reference

- `cat .beads/artifacts/$ARGUMENTS/plan.md` - The approved plan
- `cat .beads/artifacts/$ARGUMENTS/spec.md` - Original requirements
- `npm test -- --grep "pattern"` - Run specific tests
- `npm run build` - Verify build
- GKG tools - `gkg_read_definitions`, `gkg_get_references` for precise context
- `codesearch` - API patterns when implementing unfamiliar code
