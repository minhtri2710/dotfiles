---
description: Compliance check between spec and implementation. Verifies interfaces, requirements, test coverage. Reports deviations.
---

# Verify-Spec Command

Audit implementation against its specification. Ensures code delivers what the spec promised.

## Purpose

Catch drift between intent (spec) and reality (code):
- Interface changes that weren't spec'd
- Missing requirements
- Untested verification points
- Silent behavior changes

## Workflow

### Step 1: Load Spec and Implementation

```javascript
// Read specification
const spec = read("specs/user-search.spec.md");

// Identify implementation files from spec's Design section
const implFiles = ["src/services/user-search.ts", "src/types/search.ts"];

// Load implementations via GKG
gkg_read_definitions({
  definitions: [
    { file_path: "src/services/user-search.ts", names: ["searchUsers"] },
    { file_path: "src/types/search.ts", names: ["SearchUsersParams", "SearchUsersResult"] }
  ]
});
```

### Step 2: Interface Compliance Check

Compare spec's Design section with actual signatures:

| Spec | Implementation | Status |
|------|----------------|--------|
| `searchUsers(params: SearchUsersParams): Promise<SearchUsersResult>` | `searchUsers(params: SearchUsersParams): Promise<SearchUsersResult>` | ✅ Match |
| `SearchUsersParams.includeInactive?: boolean` | `SearchUsersParams.includeInactive?: boolean` | ✅ Match |
| `SearchUsersResult.totalPages: number` | `SearchUsersResult.pageCount: number` | ❌ **Deviation** |

### Step 3: Requirements Coverage

Check each functional requirement:

```markdown
## Requirements Verification

### Functional Requirements
- [x] **FR-1**: Users can search by name or email
  - Verified: `user-search.ts:23` - OR query on name/email fields
- [x] **FR-2**: Results are paginated (default 20, max 100)
  - Verified: `user-search.ts:15` - limit clamped to 100
- [ ] **FR-3**: Admins can search all users; regular users only active
  - **MISSING**: No permission check found

### Non-Functional Requirements
- [x] **NFR-1**: Debounce search input (300ms)
  - Verified: Frontend implementation
- [ ] **NFR-2**: Cache results for 5 minutes
  - **MISSING**: No caching implementation found
```

### Step 4: Test Coverage

Verify all spec verification points have tests:

```markdown
## Test Coverage

### Unit Tests (spec: 5, implemented: 4)
- [x] Returns matching users by name → `user-search.test.ts:12`
- [x] Returns matching users by email → `user-search.test.ts:20`
- [x] Paginates results correctly → `user-search.test.ts:28`
- [x] Rejects queries under 2 characters → `user-search.test.ts:36`
- [ ] Blocks non-admin from inactive search → **NOT TESTED**

### Integration Tests (spec: 3, implemented: 1)
- [x] End-to-end search flow → `integration/search.test.ts:8`
- [ ] Cache invalidation on user update → **NOT TESTED**
- [ ] Audit log creation → **NOT TESTED**
```

### Step 5: Generate Compliance Report

```markdown
## Verification Report

**Spec**: specs/user-search.spec.md
**Date**: 2024-01-15T10:30:00Z

### Summary

| Category | Compliant | Deviations |
|----------|-----------|------------|
| Interface | 3/4 | 1 |
| Requirements | 4/6 | 2 |
| Test Coverage | 5/8 | 3 |

### Overall Status: ❌ DEVIATIONS FOUND

### Deviations

#### Interface Deviations

1. **Property Rename** `SearchUsersResult`
   - Spec: `totalPages: number`
   - Impl: `pageCount: number`
   - Location: `src/types/search.ts:15`
   - **Recommendation**: Rename to match spec or update spec if intentional

#### Missing Requirements

2. **FR-3**: Admin permission check not implemented
   - **Recommendation**: Add permission check in `user-search.ts`

3. **NFR-2**: Caching not implemented
   - **Recommendation**: Add Redis/memory cache layer

#### Missing Tests

4. Test for admin permission gate
5. Test for cache invalidation
6. Test for audit logging

### Recommendations

1. **Fix immediately**: Interface deviation (breaking change)
2. **Implement**: FR-3 permission check (security)
3. **Add tests**: 3 missing verification points
4. **Consider**: Update spec if `pageCount` name is preferred
```

## Output Actions

Based on results:

| Status | Action |
|--------|--------|
| ✅ Compliant | "Implementation matches spec" |
| ❌ Deviations | List specific issues with `file:line` |
| ⚠️ Missing tests | Recommend test additions |
| 📝 Spec updates needed | Suggest spec amendments if deviations are improvements |

## Example

```
/verify-spec specs/user-search.spec.md
```

**Output**: Detailed compliance report showing alignment between spec and implementation.

<code_exploration>
Read and understand the implementation thoroughly before reporting compliance. Do not speculate about code you have not inspected. Every finding should be backed by specific file:line references.
</code_exploration>
