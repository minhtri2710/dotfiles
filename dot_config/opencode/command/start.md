---
description: Setup workspace and load context for a bead
agent: build
subtask: false
---

# Start Working on Bead

Load context and setup workspace for bead: $ARGUMENTS

## Step 1: Load Bead

```bash
bd show $ARGUMENTS --json
```

## Step 2: Check Status

```bash
git status --short
git branch --show-current
```

## Step 3: Load Artifacts

Check for existing work:

```bash
ls -la .beads/artifacts/$ARGUMENTS/ 2>/dev/null || echo "No artifacts yet"
```

Read if they exist:
- `spec.md` - Original specification
- `research.md` - Previous research
- `plan.md` - Approved plan
- `handoffs/*.md` - Session handoffs

## Step 4: Mark In Progress

```bash
bd update $ARGUMENTS --status in_progress
```

## Step 5: Summarize Context

```markdown
## Ready: $ARGUMENTS

### Status
- Branch: [current branch]
- Bead status: in_progress

### Loaded Artifacts
- spec.md: [summary or "not found"]
- research.md: [summary or "not found"]
- plan.md: [summary or "not found"]

### Next Step
[Recommend: /research, /plan, or /implement based on what exists]
```
