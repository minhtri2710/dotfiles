---
description: Implement a feature following its specification and tracked issue
---

# Implement Command

Build a feature following strict Test-Driven Development (TDD) guided by the OpenSpec and tracked Beads issue.

## Prerequisites

- An approved spec file exists
- A Beads issue has been created and is ready for work

## Workflow

1. **Load Context**
   - Use `beads_show` to read the issue details
   - Read the referenced spec file
   - Use `gkg_read_definitions` for any dependencies

2. **Update Issue Status**
   - Mark issue as `in_progress` using `beads_update`

3. **Test-First Implementation (TDD)**
   - **Red**: Generate test suite based on spec's "Verification" section
   - Run tests to confirm they fail
   - **Green**: Implement the minimal code to make tests pass
   - Follow the "Design" section of the spec strictly
   - Use `gkg_read_definitions` to call existing APIs correctly

4. **Living Spec Rule**
   - If implementation reveals design changes are needed:
     - **STOP** implementation
     - Update the spec file first
     - Get user approval for spec changes
     - Resume implementation

5. **Verification**
   - Run all tests defined in spec
   - Fix any bugs or failing tests
   - Ensure code quality and style compliance

6. **Complete**
   - Mark Beads issue as `closed` using `beads_close`
   - Summarize what was implemented

## Example

```
/implement PROJ-123
```

**Output**: Implements the feature defined in the linked spec, following TDD, and closes the issue upon completion.
