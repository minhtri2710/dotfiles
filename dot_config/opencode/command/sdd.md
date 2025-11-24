---
description: Complete Spec-Driven Development workflow from spec to implementation
---

# Full SDD Workflow

Execute the complete Specification-Driven Development (SDD) process in one flow: Spec → Track → Implement → Verify.

## Core Tools

- **GKG (Gitlab Knowledge Graph)**: For deep context and understanding
- **Beads**: For task tracking and issue management
- **OpenSpec**: For defining rigorous, machine-readable specifications

## Complete Workflow

### Phase 1: Specification

1. **Analyze Context**
   - Use `gkg_repo_map` and `gkg_search_codebase_definitions`
   - Research external libraries with `codesearch` if needed

2. **Draft OpenSpec**
   - Create `specs/[feature-name].spec.md` with:
     - Context (files/symbols from GKG)
     - Requirements (functional and non-functional)
     - Design (interfaces, types, signatures)
     - Verification (test criteria)
   - Use **"ultrathink"** for deep architectural analysis

3. **Review with User**
   - Ask: "Does this spec accurately capture the requirements?"

### Phase 2: Tracking

1. **Create Beads Issue**
   - Title from spec
   - Description references spec file
   - Appropriate priority and type

### Phase 3: Implementation

1. **Mark In Progress**
   - Update Beads issue status

2. **TDD Cycle**
   - Write tests from spec (Red)
   - Implement to pass tests (Green)
   - Refactor if needed

3. **Follow Living Spec Rule**
   - Update spec first if design changes needed

### Phase 4: Verification

1. **Run All Tests**
2. **Fix Bugs**
3. **Close Issue**

## Example

```
/sdd-full Implement UserSearch API with filtering
```

**Output**: Complete flow from specification creation through tested implementation and issue closure.

## Individual Commands

If you need to run phases separately:
- `/spec` - Create specification only
- `/track` - Create Beads issue from spec
- `/implement` - Implement from existing spec + issue
