---
description: Full Spec-Driven Development pipeline. Spec → Track → Implement → Verify in one flow. For comprehensive feature development.
---

# SDD Command (Full Pipeline)

Execute the complete Specification-Driven Development workflow: analyze, specify, track, implement, and verify—all in one flow.

## Philosophy

**Spec-Driven Development** treats specifications as living contracts:
- Specs drive implementation (not the reverse)
- Tests validate spec compliance
- Changes flow through specs first

## Core Tools

| Tool | Purpose |
|------|---------|
| **GKG** | Deep codebase understanding |
| **Beads** | Issue tracking and progress |
| **OpenSpec** | Machine-readable specifications |
| **TDD** | Test-first implementation |

## Complete Workflow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    SPEC     │────▶│    TRACK    │────▶│  IMPLEMENT  │────▶│   VERIFY    │
│             │     │             │     │             │     │             │
│ Analyze &   │     │ Create      │     │ TDD cycle   │     │ Compliance  │
│ Design      │     │ Beads issue │     │ Red→Green   │     │ check       │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

### Phase 1: Specification

**Goal**: Understand deeply, design precisely.

1. **Context Gathering**
   ```
   gkg_repo_map                    → Project structure
   gkg_search_codebase_definitions → Related code
   codesearch                      → External library patterns
   ```

2. **Draft OpenSpec**
   Create `specs/[feature-name].spec.md`:
   - **Context**: Files, dependencies, constraints
   - **Requirements**: Functional + non-functional
   - **Design**: Interfaces, data flow, errors
   - **Verification**: Test cases, acceptance criteria

3. **User Approval**
   > "Does this specification accurately capture the requirements?"

### Phase 2: Tracking

**Goal**: Make work visible and trackable.

```javascript
beads_create({
  title: "Implement [Feature Name]",
  description: "Spec: specs/[feature-name].spec.md\n\n[Key requirements]",
  type: "feature",
  priority: 2
});
```

### Phase 3: Implementation

**Goal**: Build exactly what the spec describes.

1. **Claim Work**
   ```javascript
   beads_update({ issue_id: "PROJ-123", status: "in_progress" });
   ```

2. **TDD Cycle**
   - **Red**: Write failing tests from spec's Verification section
   - **Green**: Implement minimal code to pass
   - **Refactor**: Clean up while tests stay green

3. **Living Spec Rule**
   If design changes needed → update spec first → get approval → continue

### Phase 4: Verification

**Goal**: Confirm implementation matches spec.

1. Run all tests
2. Check interface compliance
3. Verify requirements coverage
4. Close issue on success

```javascript
beads_close({
  issue_id: "PROJ-123",
  reason: "Implemented per spec. All tests passing."
});
```

## Output

```markdown
## SDD Complete

### Specification
- File: specs/user-search.spec.md
- Requirements: 6 functional, 3 non-functional

### Tracking
- Issue: PROJ-123 (closed)
- Duration: 2h 15m

### Implementation
- Files: 3 created, 2 modified
- Tests: 12 passing

### Verification
- Interface: ✅ Compliant
- Requirements: ✅ 6/6 covered
- Test Coverage: ✅ 100%

**Status**: ✅ COMPLETE
```

## Individual Commands

Run phases separately when needed:

| Command | Phase | Use When |
|---------|-------|----------|
| `/spec` | Specification only | Need approval before tracking |
| `/track` | Create issue from spec | Spec exists, need to track |
| `/implement` | TDD from spec + issue | Issue ready, start coding |
| `/verify-spec` | Compliance check | Verify after implementation |

## Example

```
/sdd Implement UserSearch API with filtering and pagination
```

**Output**: Complete flow from specification through tested, verified implementation.

<code_exploration>
Read and understand relevant files before proposing specifications or implementations. Do not speculate about code you have not inspected. Thoroughly review the style, conventions, and abstractions of the codebase before designing new features.
</code_exploration>

<over_engineering_prevention>
Implement only what is specified. Avoid over-engineering. Don't add features, refactor code, or make "improvements" beyond what was asked. The right amount of complexity is the minimum needed for the current task.
</over_engineering_prevention>
