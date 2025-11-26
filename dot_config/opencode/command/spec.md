---
description: Create rigorous OpenSpec specifications. Analyzes context via GKG, defines requirements, designs interfaces, sets verification criteria.
---

# Spec Command

Create a machine-readable OpenSpec specification that drives implementation. Specifications are contracts between intent and code.

## Philosophy

**Spec before code.** A good specification prevents:
- Misunderstood requirements
- Scope creep
- Incomplete implementations
- Missing test coverage

## Workflow

### Step 1: Deep Context Analysis

Use GKG to understand the landscape:

```
gkg_repo_map                    → Project structure
gkg_search_codebase_definitions → Related existing code
gkg_read_definitions            → Interface patterns
codesearch                      → External library APIs
```

### Step 2: Draft the Specification

Create `specs/[feature-name].spec.md`:

```markdown
# Feature Name Specification

## Context

### Relevant Files
- `src/services/user.ts` - UserService class
- `src/types/user.ts` - User type definitions

### Dependencies
- External: zod (validation), prisma (ORM)
- Internal: AuthService, Logger

### Constraints
- Must maintain backward compatibility with v2 API
- Response time < 200ms at p99

## Requirements

### Functional
1. **FR-1**: Users can search by name or email
2. **FR-2**: Results are paginated (default 20, max 100)
3. **FR-3**: Admins can search all users; regular users only active

### Non-Functional
- **NFR-1**: Debounce search input (300ms)
- **NFR-2**: Cache results for 5 minutes
- **NFR-3**: Log all search queries for audit

## Design

### Interface

\`\`\`typescript
interface SearchUsersParams {
  query: string;
  page?: number;
  limit?: number;
  includeInactive?: boolean; // admin only
}

interface SearchUsersResult {
  users: User[];
  total: number;
  page: number;
  totalPages: number;
}

function searchUsers(params: SearchUsersParams): Promise<SearchUsersResult>;
\`\`\`

### Data Flow

1. Input validation (zod schema)
2. Permission check (admin for inactive)
3. Query construction (prisma)
4. Result pagination
5. Cache population

### Error Handling

| Error | Code | Message |
|-------|------|---------|
| Invalid query | 400 | "Search query must be 2+ characters" |
| Unauthorized | 403 | "Cannot search inactive users" |
| Rate limited | 429 | "Too many requests" |

## Verification

### Unit Tests
- [ ] Returns matching users by name
- [ ] Returns matching users by email
- [ ] Paginates results correctly
- [ ] Rejects queries under 2 characters
- [ ] Blocks non-admin from inactive search

### Integration Tests
- [ ] End-to-end search flow
- [ ] Cache invalidation on user update
- [ ] Audit log creation

### Acceptance Criteria
- [ ] Search returns results in < 200ms
- [ ] Pagination works correctly at boundaries
- [ ] Admin features properly gated
```

### Step 3: Review with User

Present the complete spec and ask:

> "Does this specification accurately capture the requirements? Any changes before we proceed?"

Make adjustments based on feedback before implementation.

## Output

Creates `specs/[feature-name].spec.md` ready for:
- `/track` → Convert to Beads issue
- `/implement` → TDD implementation

## Tips

- Use **"ultrathink"** keyword for complex architectural analysis
- Reference existing code patterns from GKG findings
- Be explicit about edge cases and error conditions
- Define verification criteria that are testable

<code_exploration>
Read and understand relevant files before proposing specifications. Do not speculate about code you have not inspected. Thoroughly review the style, conventions, and abstractions of the codebase before designing new features.
</code_exploration>
