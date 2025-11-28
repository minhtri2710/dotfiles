---
description: TDD implementation driven by Beads issues. Picks ready tasks, implements via TDD, closes on completion.
---

# Implement Command

Execute Test-Driven Development driven by Beads issues. Each atomic issue becomes a focused TDD cycle.

## Prerequisites

- Beads issues exist (via `/openspec-beads [change-id]`)
- Ready tasks available: `beads_ready()`
- OpenSpec provides context: `openspec show [change-id]`

## Workflow

### Phase 1: Pick Ready Task

```javascript
// Find unblocked work
beads_ready();
```

Output:

```
PROJ-125  Create profile settings API     open   priority:2
PROJ-126  Add avatar upload endpoint      open   priority:2
```

### Phase 2: Claim Issue

```javascript
beads_update({
  issue_id: "PROJ-125",
  status: "in_progress",
});
```

### Phase 3: Load Context

```javascript
// Show issue details
beads_show({ issue_id: "PROJ-125" });

// Get spec context if needed
// openspec show [change-id]

// Load related code via GKG
gkg_read_definitions({
  definitions: [{ file_path: "src/services/user.ts", names: ["UserService"] }],
});
```

### Phase 4: TDD Cycle

#### Red: Write Failing Tests

From the issue's acceptance criteria and related spec scenarios:

```typescript
// tests/profile-settings-api.test.ts

describe("ProfileSettingsAPI", () => {
  it("updates display name", async () => {
    const result = await updateProfile({ displayName: "New Name" });
    expect(result.displayName).toBe("New Name");
  });

  it("rejects empty display name", async () => {
    await expect(updateProfile({ displayName: "" })).rejects.toThrow(
      "Display name required",
    );
  });
});
```

Run tests → Confirm they fail (Red phase).

#### Green: Implement to Pass

Write minimal code to make tests pass:

```typescript
// src/api/profile-settings.ts

export async function updateProfile(params: UpdateProfileParams) {
  if (!params.displayName?.trim()) {
    throw new ValidationError("Display name required");
  }

  return await db.user.update({
    where: { id: params.userId },
    data: { displayName: params.displayName },
  });
}
```

Run tests → Confirm they pass (Green phase).

#### Refactor: Clean Up

Improve code quality while keeping tests green.

### Phase 5: Close Issue

```javascript
beads_close({
  issue_id: "PROJ-125",
  reason: "Implemented. Tests passing.",
});
```

### Phase 6: Sync OpenSpec (Per Section)

After completing all issues in a section, sync `tasks.md`:

```markdown
// openspec/changes/[change-id]/tasks.md

## 1. Database

- [x] 1.1 Create profile settings API ← section complete
- [x] 1.2 Add migrations

## 2. Backend ← now unblocked

- [ ] 2.1 Create endpoints
- [ ] 2.2 Add validation
```

**Sync Rule**: Complete section in Beads → update section in tasks.md → commit checkpoint.

### Phase 7: Repeat

```javascript
// Next ready task
beads_ready();

// Claim and implement
beads_update({ issue_id: "PROJ-126", status: "in_progress" });
// ... TDD cycle ...
beads_close({ issue_id: "PROJ-126", reason: "Done." });
```

### Phase 8: Living Spec Rule

**If implementation reveals design changes needed:**

1. **STOP** implementation
2. Update the spec delta in `openspec/changes/[change-id]/specs/`
3. Run `openspec validate [change-id] --strict`
4. Get user approval for spec changes
5. Create new Beads issues if scope changed
6. Resume implementation

> The spec is the contract. Implementation serves the spec.

### Phase 9: Epic Completion

When all subtasks closed, close the epic:

```javascript
beads_show({ issue_id: "PROJ-124" }); // Check all children closed

beads_close({
  issue_id: "PROJ-124",
  reason: "All tasks complete. Ready to archive.",
});
```

### Phase 10: Archive OpenSpec Change

```bash
openspec archive [change-id] --yes
```

## Output Summary

```
## Implementation Progress

**Epic**: PROJ-124 (add-user-profile-settings)

### Completed This Session
| Issue | Task | Status |
|-------|------|--------|
| PROJ-125 | Create profile settings API | ✅ closed |
| PROJ-126 | Add avatar upload endpoint | ✅ closed |

### Remaining
| Issue | Task | Status |
|-------|------|--------|
| PROJ-127 | Create settings page component | open |
| PROJ-128 | Add form validation | blocked |

### Test Results
✅ 12 passed | ❌ 0 failed

### Next
Run: beads_ready() for next task
```

## Example

```
/implement
```

**Output**: Picks next ready Beads issue, runs TDD cycle, closes on completion.

```
/implement PROJ-125
```

**Output**: Implements specific issue via TDD.

<code_exploration>
Read and understand relevant files before implementing. Do not speculate about code you have not inspected. Thoroughly review the style, conventions, and abstractions of the codebase before writing new code.
</code_exploration>

<over_engineering_prevention>
Implement only what the issue describes. Avoid over-engineering. Don't add features, refactor code, or make "improvements" beyond what was asked. The right amount of complexity is the minimum needed for the current task.
</over_engineering_prevention>
