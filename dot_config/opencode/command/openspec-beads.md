---
description: Break OpenSpec change into Beads issues. Creates epic + subtasks from tasks.md with dependencies.
---

# OpenSpec to Beads Command

Convert an OpenSpec change proposal into trackable Beads issues. Creates an epic for the change and subtasks from `tasks.md`.

**Sync Rule**: Beads issues mirror `tasks.md`. After completing all issues in a **section**, update that section's tasks to `- [x]`.

## Prerequisites

- OpenSpec change exists: `openspec/changes/[change-id]/`
- Beads initialized in project: `.beads/` directory
- Change validated: `openspec validate [change-id] --strict`

## Rules

- **Use short prefix**: When creating issues, use a short prefix (2-4 chars) derived from the project or change name (e.g., "US" for user-search, "API" for api-refactor)

## Workflow

### Step 1: Read Change

```bash
openspec show [change-id]
cat openspec/changes/[change-id]/proposal.md
cat openspec/changes/[change-id]/tasks.md
```

### Step 2: Create Epic

```javascript
beads_create({
  title: "[change-id] - [Brief description from proposal]",
  description: "OpenSpec change: openspec/changes/[change-id]/proposal.md",
  issue_type: "epic",
  priority: 1,
});
// Returns: PROJ-1
```

### Step 3: Parse tasks.md

Extract tasks from the checklist format:

```markdown
## 1. Database Setup

- [ ] 1.1 Add search index to users table
- [ ] 1.2 Create audit log table

## 2. Backend Implementation

- [ ] 2.1 Create search endpoint
- [ ] 2.2 Add pagination logic
```

### Step 4: Create Subtasks

Create a Beads issue for each task, linked to the epic:

```javascript
// Task 1.1
beads_create({
  title: "Add search index to users table",
  description: "OpenSpec task 1.1 for [change-id]",
  issue_type: "task",
  priority: 2,
});
beads_dep({
  issue_id: "PROJ-2",
  depends_on_id: "PROJ-1",
  dep_type: "parent-child",
});

// Task 1.2 (depends on 1.1)
beads_create({
  title: "Create audit log table",
  description: "OpenSpec task 1.2 for [change-id]",
  issue_type: "task",
  priority: 2,
});
beads_dep({
  issue_id: "PROJ-3",
  depends_on_id: "PROJ-1",
  dep_type: "parent-child",
});

// Task 2.1 (depends on 1.x completion)
beads_create({
  title: "Create search endpoint",
  description: "OpenSpec task 2.1 for [change-id]",
  issue_type: "task",
  priority: 2,
});
beads_dep({
  issue_id: "PROJ-4",
  depends_on_id: "PROJ-1",
  dep_type: "parent-child",
});
beads_dep({
  issue_id: "PROJ-4",
  depends_on_id: "PROJ-3",
  dep_type: "blocks",
});
```

### Step 5: Set Dependencies

Based on task numbering:

- Tasks in section N depend on section N-1 completion
- Sequential tasks within a section can have blocking deps if order matters

### Step 6: Report

Output created issues:

```markdown
## OpenSpec → Beads Complete

**Change**: add-user-search
**Epic**: PROJ-1

### Issues Created

| ID     | Task                            | Status  |
| ------ | ------------------------------- | ------- |
| PROJ-1 | add-user-search (Epic)          | open    |
| PROJ-2 | Add search index to users table | open    |
| PROJ-3 | Create audit log table          | open    |
| PROJ-4 | Create search endpoint          | blocked |
| PROJ-5 | Add pagination logic            | blocked |

### Ready to Work

Run: `beads_ready()` to see unblocked tasks
```

## Dependency Mapping

| tasks.md Pattern         | Beads Dependency     |
| ------------------------ | -------------------- |
| Same section, sequential | `blocks` (optional)  |
| Different sections       | Section N blocks N+1 |
| All tasks to epic        | `parent-child`       |

## Example

```
/openspec-beads add-user-search
```

**Input**: OpenSpec change `add-user-search` with tasks.md

**Output**: Epic PROJ-1 with subtasks, dependencies set, ready for `beads_ready()`

## Integration with /implement

After creating Beads issues:

```
/implement
```

The implement command will:

1. Pick up tasks via `beads_ready()`
2. Mark `in_progress` when starting
3. Mark `closed` when tests pass
4. **Sync tasks.md**: Update `- [ ]` → `- [x]` for closed issues

## Sync Rules

Sync OpenSpec `tasks.md` after completing each **section** (not each issue):

| Event                        | Action                               |
| ---------------------------- | ------------------------------------ |
| All issues in section closed | Mark section tasks `[x]` in tasks.md |
| Epic closed                  | All tasks `[x]`, ready to archive    |
| Issue reopened               | Mark task `[ ]`, reassess section    |

**Why section-based sync:**

- Sections map to Beads blocking deps
- Natural checkpoint for resuming work
- Reduces file writes and git noise
- Matches logical work units
