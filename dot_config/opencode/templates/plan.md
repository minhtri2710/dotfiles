---
date: [ISO timestamp]
bead: [bead-id]
approach: [chosen approach]
estimated_effort: [time estimate]
---

# Implementation Plan: [Title]

## Overview

[What we're building and why - 1-2 sentences]

## Approach

[High-level strategy and reasoning for chosen approach]

## What We're NOT Doing

- [Explicit out-of-scope item 1]
- [Explicit out-of-scope item 2]

---

## Phase 1: [Name]

### Changes Required

- [ ] `path/to/file.ts` - [change description]
- [ ] `path/to/other.ts` - [change description]

### Success Criteria

- [ ] Build passes
- [ ] Tests pass
- [ ] [Specific verification]

---

## Phase 2: [Name]

### Changes Required

- [ ] `path/to/file.ts` - [change description]

### Success Criteria

- [ ] Build passes
- [ ] Tests pass
- [ ] [Specific verification]

---

## Testing Strategy

### New Tests to Write

- [ ] `path/to/file.test.ts` - [what it tests]
- [ ] `path/to/other.test.ts` - [what it tests]

### Existing Tests to Update

- [ ] `path/to/existing.test.ts` - [what changes]

### Coverage Requirements

- [ ] All new public functions have unit tests
- [ ] Happy path covered
- [ ] Edge cases covered
- [ ] Error paths covered

---

## Build & Test Commands

```bash
npm run build
npm test
npm run lint
```

---

## References

- Research: `.beads/artifacts/[bead-id]/research.md`
- Similar: `path/to/similar.ts:45`
