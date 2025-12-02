---
date: [ISO timestamp]
bead: [bead-id]
branch: [git branch]
commit: [HEAD sha]
---

# Handoff: [Bead Title]

## Current State

[What's done, what's in progress]

## Phase Progress

- [x] /create - spec written
- [x] /research - codebase explored
- [ ] /plan - approach designed
- [ ] /implement - code written
- [ ] /finish - committed and closed

## Last Action

[What was just completed before this handoff]

## Next Steps

1. **Immediate**: [Very next action to take]
2. **Then**: [Following action]
3. **Finally**: [Completion step]

## Key Context

### Files Being Modified
- `path/to/file.ts` - [what's happening here]

### Important Decisions Made
- [Decision 1 and rationale]
- [Decision 2 and rationale]

### Things to Remember
- [Critical context that might be lost]
- [Gotchas discovered]

## Blockers

- [ ] [Blocker if any, otherwise remove section]

## Commands to Resume

```bash
# Switch to correct branch
git checkout [branch]

# Verify state
git status
npm test

# Resume work
/resume [bead-id]
```

## Uncommitted Changes

```
[git status --short output, or "none"]
```

## Related Artifacts

- `spec.md` - [exists/missing]
- `research.md` - [exists/missing]  
- `plan.md` - [exists/missing]
