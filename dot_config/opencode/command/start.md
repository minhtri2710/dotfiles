---
description: Triage task → setup workspace → load context → route to next command
subtask: false
---

# /start - Triage & Setup

Get developer from "I want to work" → "ready for next step" with full context.

## Input

- `$1` - Bead ID (optional)
- `$ARGUMENTS` - Flags: `--worktree`, `--branch`

---

## Phase 1: Resolve Bead

**No bead ID provided:**
```bash
bd ready --json --limit 10
# fallback if empty:
bd list --status open --json
```

Present options → user picks number, enters ID, or types "new".

**Bead ID provided:**
```bash
bd show $1 --json
```

---

## Phase 2: Setup Isolation

1. Check git status:
   ```bash
   git status --porcelain
   ```
   If dirty → ask: stash, commit, or continue

2. Ensure artifacts gitignored:
   ```bash
   grep -q ".beads/artifacts" .gitignore 2>/dev/null || echo ".beads/artifacts/" >> .gitignore
   ```

3. Create isolation (default: branch):
   - `--worktree` → `git worktree add ../$BEAD_ID -b $BEAD_ID`
   - `--branch` or default → `git checkout -b $BEAD_ID`

---

## Phase 3: Load Context

1. Read existing artifacts:
   ```bash
   ls .beads/artifacts/$BEAD_ID/ 2>/dev/null
   ```
   Read: spec.md, research.md, plan.md (if exist)

2. Fire parallel exploration (if spec exists):
   ```
   background_task(agent="explore", prompt="Find files related to [component from spec]...")
   background_task(agent="librarian", prompt="Look up [library from spec] docs...")
   ```

3. Collect results → write `.beads/artifacts/$BEAD_ID/exploration-context.md`

---

## Phase 4: Briefing & Route

```
Bead: $BEAD_ID - [title]
Type: [type] | Priority: [P0-3]

Artifacts: spec ✓/✗ | research ✓/✗ | plan ✓/✗

Exploration: [key files found] [external docs found]
```

**Route by artifact state:**

| State | Next Command |
|-------|--------------|
| No spec.md | `/create` |
| No research.md | `/research $BEAD_ID` |
| No plan.md | `/plan $BEAD_ID` |
| Has plan.md | `/build $BEAD_ID` |

---

## Constraints

- Never proceed with dirty git without acknowledgment
- Always validate bead exists before continuing
- Guide to correct next command based on artifact state
