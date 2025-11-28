---
description: Full Spec-Driven Development pipeline using OpenSpec CLI. Proposal → Apply → Archive in one flow.
---

# SDD Command (Full Pipeline)

Execute the complete Specification-Driven Development workflow using the OpenSpec CLI: propose, implement, and archive—all in one flow.

## Philosophy

**Spec-Driven Development** treats specifications as living contracts:

- Specs drive implementation (not the reverse)
- Tests validate spec compliance
- Changes flow through specs first

## Core Tools

| Tool         | Purpose                     |
| ------------ | --------------------------- |
| **openspec** | Spec management CLI         |
| **GKG**      | Deep codebase understanding |
| **Beads**    | Issue tracking and progress |
| **TDD**      | Test-first implementation   |

## Complete Workflow

```
┌─────────────┐      ┌ ─────────────┐     ┌─────────────┐
│  PROPOSAL   │────▶│    APPLY    │────▶│   ARCHIVE   │
│             │     │             │     │             │
│ openspec    │     │ TDD cycle   │     │ openspec    │
│ change      │     │ Red→Green   │     │ archive     │
└─────────────┘     └─────────────┘     └─────────────┘
```

### Phase 1: Proposal (Create Change)

**Goal**: Understand deeply, design precisely.

1. **Context Gathering**

   ```bash
   openspec list                  # Active changes
   openspec list --specs          # Existing capabilities
   ```

   ```
   gkg_repo_map                   → Project structure
   gkg_search_codebase_definitions → Related code
   ```

2. **Create Change Proposal**

   ```bash
   # Scaffold change directory
   mkdir -p openspec/changes/[change-id]/specs/[capability]
   ```

   Create files:
   - `proposal.md` - Why and what changes
   - `tasks.md` - Implementation checklist
   - `design.md` - Technical decisions (optional)
   - `specs/[capability]/spec.md` - Delta specs (ADDED/MODIFIED/REMOVED)

3. **Validate**

   ```bash
   openspec validate [change-id] --strict
   ```

4. **User Approval**
   > "Does this proposal accurately capture the requirements?"

### Phase 2: Apply (Implementation)

**Goal**: Build exactly what the spec describes.

1. **Break into Beads Issues**

   ```
   /openspec-beads [change-id]
   ```

   Creates epic + subtasks from `tasks.md` with dependencies.

2. **Implement via Beads**

   ```javascript
   beads_ready(); // Find unblocked work
   beads_update({ issue_id: "PROJ-2", status: "in_progress" });
   // ... TDD cycle ...
   beads_close({ issue_id: "PROJ-2", reason: "Done" });
   ```

3. **Sync per Section**
   After completing all issues in a section, update `tasks.md`:

   ```markdown
   ## 1. Database

   - [x] 1.1 Task name ← section complete, sync now
   - [x] 1.2 Task name
   ```

4. **Living Spec Rule**
   If design changes needed → update spec first → get approval → create new Beads issues if scope changed → continue

### Phase 3: Archive (Verification & Completion)

**Goal**: Confirm implementation matches spec and archive the change.

1. **Close Epic**

   ```javascript
   beads_close({
     issue_id: "PROJ-1",
     reason: "All tasks complete. Ready to archive.",
   });
   ```

2. **Verify**

   ```bash
   openspec validate [change-id] --strict
   ```

3. **Archive**

   ```bash
   openspec archive [change-id] --yes
   ```

   This moves `changes/[change-id]/` → `changes/archive/YYYY-MM-DD-[change-id]/` and updates main specs.

## Output

```markdown
## SDD Complete

### Proposal

- Change: add-user-search
- Capabilities: user-search, auth

### Implementation

- Files: 3 created, 2 modified
- Tests: 12 passing
- Tasks: 8/8 complete

### Archive

- Location: openspec/changes/archive/2024-01-15-add-user-search/
- Specs updated: ✅

**Status**: ✅ COMPLETE
```

## OpenSpec CLI Reference

| Command                              | Purpose                  |
| ------------------------------------ | ------------------------ |
| `openspec list`                      | List active changes      |
| `openspec list --specs`              | List specifications      |
| `openspec show [item]`               | View change or spec      |
| `openspec validate [item] --strict`  | Validate                 |
| `openspec archive [change-id] --yes` | Archive after deployment |

## Example

```
/sdd Implement UserSearch API with filtering and pagination
```

**Output**: Complete flow from proposal through tested, archived implementation.

<code_exploration>
Read and understand relevant files before proposing specifications or implementations. Do not speculate about code you have not inspected. Thoroughly review the style, conventions, and abstractions of the codebase before designing new features.
</code_exploration>

<over_engineering_prevention>
Implement only what is specified. Avoid over-engineering. Don't add features, refactor code, or make "improvements" beyond what was asked. The right amount of complexity is the minimum needed for the current task.
</over_engineering_prevention>
