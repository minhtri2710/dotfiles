---
description: Show current workspace and bead status
agent: build
subtask: false
---

# Status Overview

Quick snapshot of current workspace state.

## Git Status

!`git branch --show-current`
!`git status --short`
!`git log --oneline -3`

## Active Beads

```bash
bd list --status in_progress --json 2>/dev/null | jq -r '.[] | "🔵 \(.id): \(.title)"' || echo "No beads in progress"
```

## Ready Beads

```bash
bd ready --json 2>/dev/null | jq -r '.[0:3][] | "⚪ \(.id): \(.title) (p\(.priority))"' || echo "No ready beads"
```

## Artifacts

```bash
ls -d .beads/artifacts/*/ 2>/dev/null | while read dir; do
  id=$(basename "$dir")
  files=$(ls "$dir" 2>/dev/null | tr '\n' ' ')
  echo "📁 $id: $files"
done || echo "No artifacts"
```

## Summary

```markdown
## Workspace Status

### Git
- Branch: [branch]
- Clean: [yes/no]
- Last commit: [message]

### Beads
- In Progress: [count]
- Ready: [count]

### Recommendation
[What to do next based on state]
```
