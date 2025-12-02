---
description: Refine implementation plan based on feedback or new information
agent: smart
subtask: false
---

# Iterate Plan

Update plan based on: $ARGUMENTS

## When to Use

- User provides feedback on plan
- Research reveals new requirements
- Implementation uncovers complexity
- Scope needs adjustment

## Step 1: Load Current Plan

```bash
cat .beads/artifacts/$ARGUMENTS/plan.md 2>/dev/null || echo "No plan found"
```

## Step 2: Apply Changes

Based on user feedback:
- Add/remove tasks
- Reorder tasks
- Update approach
- Adjust scope

## Step 3: Show Diff

```markdown
## Plan Update

### Changes
- Added: 2.4 Handle edge case for empty input
- Removed: 3.2 (consolidated into 3.1)
- Modified: 4.0 - Now includes integration tests

### Updated Plan
- [ ] 1.0 Setup
  - [ ] 1.1 ...
- [ ] 2.0 Implementation
  - [ ] 2.1 ...
  - [ ] 2.4 Handle empty input (NEW)
...
```

## Step 4: Save Updated Plan

Update `.beads/artifacts/$ARGUMENTS/plan.md`

## Living Spec Rule

If significant changes:
1. Update spec if requirements changed
2. Update plan
3. Get user confirmation
4. Resume

## Output

```markdown
## Plan Updated

### Summary of Changes
- [change 1]
- [change 2]

### Next Steps
Run /implement to continue
```
