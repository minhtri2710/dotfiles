---
description: Quick async exploration - fire background agents and continue working
subtask: false
---

# /scout - Fire-and-Forget Exploration

Launch parallel background exploration, return immediately. **Do NOT wait for results.**

**Input:** `$ARGUMENTS` - Search targets (space-separated)

```
/scout authentication
/scout "user model" "api routes"
/scout "how does caching work"
/scout --lib react-query
```

---

## Phase 1: Parse Targets

If no args → show usage and exit.

Parse each target and classify:

| Pattern | Agent | Example |
|---------|-------|---------|
| `--lib {name}` | librarian | `--lib zod` |
| `--pattern {desc}` | explore (pattern mode) | `--pattern error handling` |
| Code/file reference | explore | `authentication`, `user model` |
| Question format | explore + librarian | `how does X work` |

---

## Phase 2: Launch Parallel Agents

```typescript
// Internal codebase exploration
background_task(agent="explore", prompt=`
  Find code related to: {target}
  Return: file paths, function signatures, key patterns
`)

// External library docs (--lib flag or detected library name)
background_task(agent="librarian", prompt=`
  Look up {library} documentation
  Return: key APIs, common patterns, gotchas
`)

// Pattern finding
background_task(agent="explore", prompt=`
  Find examples of {pattern} in codebase
  Return: file:line references, implementation variations
`)
```

---

## Phase 3: Return Immediately

**Do NOT call `background_output()`. Return task IDs only.**

```
## Scouts Deployed

| Target | Agent | Task ID |
|--------|-------|---------|
| {target1} | @explore | {task_id} |
| {target2} | @librarian | {task_id} |

**Retrieve results**: `background_output(task_id="...")`

Continue working. Results arrive asynchronously.
```

---

## /scout vs /research

| /scout | /research |
|--------|-----------|
| Quick, non-blocking | Deep, produces research.md |
| Fire and forget | Interactive refinement |
| Multiple parallel searches | Synthesized understanding |
| Use while working | Use before planning |
