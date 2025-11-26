---
description: TDD implementation from spec and issue. Writes tests first, implements to pass, follows Living Spec rule.
---

# Implement Command

Execute Test-Driven Development guided by an OpenSpec and tracked Beads issue. Tests first, implementation second, verification always.

## Prerequisites

- Approved spec file exists
- Beads issue created (via `/track`)
- Issue status: `open` or `in_progress`

## Workflow

### Phase 1: Context Loading

```javascript
// Load issue details
beads_show({ issue_id: "PROJ-123" });

// Read the linked spec
read("specs/user-search.spec.md");

// Load dependencies via GKG
gkg_read_definitions({ names: ["UserService", "AuthService"] });
```

### Phase 2: Claim Work

```javascript
beads_update({
  issue_id: "PROJ-123",
  status: "in_progress"
});
```

### Phase 3: TDD Cycle

#### Red: Write Failing Tests

From spec's Verification section:

```typescript
// tests/user-search.test.ts

describe('searchUsers', () => {
  // FR-1: Users can search by name or email
  it('returns users matching name query', async () => {
    const result = await searchUsers({ query: 'John' });
    expect(result.users).toContainEqual(
      expect.objectContaining({ name: 'John Doe' })
    );
  });

  it('returns users matching email query', async () => {
    const result = await searchUsers({ query: '@example.com' });
    expect(result.users.length).toBeGreaterThan(0);
  });

  // FR-2: Pagination
  it('paginates results with default limit', async () => {
    const result = await searchUsers({ query: 'user' });
    expect(result.users.length).toBeLessThanOrEqual(20);
    expect(result).toHaveProperty('totalPages');
  });

  // Negative: Validation
  it('rejects queries under 2 characters', async () => {
    await expect(searchUsers({ query: 'a' }))
      .rejects.toThrow('Search query must be 2+ characters');
  });
});
```

Run tests → Confirm they fail (Red phase).

#### Green: Implement to Pass

Write minimal code to make tests pass:

```typescript
// src/services/user-search.ts

export async function searchUsers(params: SearchUsersParams): Promise<SearchUsersResult> {
  // Validation (from spec's Error Handling)
  if (params.query.length < 2) {
    throw new ValidationError('Search query must be 2+ characters');
  }

  // Implementation following spec's Data Flow
  const limit = Math.min(params.limit ?? 20, 100);
  const page = params.page ?? 1;

  const [users, total] = await db.user.findManyAndCount({
    where: {
      OR: [
        { name: { contains: params.query } },
        { email: { contains: params.query } }
      ]
    },
    take: limit,
    skip: (page - 1) * limit
  });

  return {
    users,
    total,
    page,
    totalPages: Math.ceil(total / limit)
  };
}
```

Run tests → Confirm they pass (Green phase).

#### Refactor: Clean Up

Improve code quality while keeping tests green.

### Phase 4: Living Spec Rule

**If implementation reveals design changes needed:**

1. **STOP** implementation
2. Update the spec file first
3. Get user approval for spec changes
4. Resume implementation with updated spec

> The spec is the contract. Implementation serves the spec, not the other way around.

### Phase 5: Final Verification

```bash
# Run all tests
bun test

# Run build
bun run build

# Check types
bun run typecheck
```

### Phase 6: Close Issue

```javascript
beads_close({
  issue_id: "PROJ-123",
  reason: "Implemented UserSearch API per spec. All tests passing."
});
```

## Output Summary

```
## Implementation Complete

**Issue**: PROJ-123 (closed)
**Spec**: specs/user-search.spec.md

### Files Changed
- src/services/user-search.ts (new)
- src/types/search.ts (new)
- tests/user-search.test.ts (new)

### Test Results
✅ 8 passed | ❌ 0 failed

### Verification
- [x] All unit tests passing
- [x] Build successful
- [x] Types valid
```

## Example

```
/implement PROJ-123
```

**Output**: TDD implementation following spec, tests passing, issue closed.
