---
description: Convert approved OpenSpec to tracked Beads issue. Links spec to issue for implementation tracking.
---

# Track Command

Transform an approved specification into a trackable Beads issue. The spec becomes the source of truth; the issue tracks progress.

## Prerequisites

- Approved spec file exists in `specs/` directory
- User has confirmed the specification

## Workflow

### Step 1: Load and Parse Spec

```
# Locate spec file (prompt if multiple exist)
specs/user-search.spec.md

# Extract metadata
- Title: from spec header
- Requirements: from Requirements section
- Acceptance criteria: from Verification section
```

### Step 2: Create Beads Issue

```javascript
beads_create({
  title: "Implement UserSearch API with filtering and pagination",
  description: `
Spec: specs/user-search.spec.md

## Key Requirements
- FR-1: Users can search by name or email
- FR-2: Results are paginated (default 20, max 100)
- FR-3: Admins can search all users; regular users only active

## Acceptance Criteria
- [ ] Search returns results in < 200ms
- [ ] Pagination works at boundaries
- [ ] Admin features properly gated
`,
  type: "feature",
  priority: 2  // or from user input
});
```

### Step 3: Confirm Creation

Display:

```
## Issue Created

**ID**: PROJ-123
**Title**: Implement UserSearch API with filtering and pagination
**Spec**: specs/user-search.spec.md
**Status**: open
**Priority**: 2 (Medium)

### Next Steps
1. Review spec: `cat specs/user-search.spec.md`
2. Start implementation: `/implement PROJ-123`
```

## Issue Structure

| Field | Source |
|-------|--------|
| Title | Spec header |
| Description | Spec summary + acceptance criteria |
| Type | `feature`, `task`, `bug` based on content |
| Priority | User input or default (2) |
| Labels | Derived from spec context |

## Integration with Workflow

```
/spec → Creates specification
/track → Links spec to trackable issue (this command)
/implement → Executes TDD from spec + issue
/verify-spec → Confirms implementation matches spec
```

## Example

```
/track specs/user-search.spec.md
```

**Output**: Creates `PROJ-123` linked to the specification, ready for `/implement`.
