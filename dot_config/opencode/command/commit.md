---
description: Create conventional commit with bead reference
agent: build
subtask: false
---

# Commit Changes

Create a conventional commit for current changes.

## Step 1: Check Status

!`git status --short`

## Step 2: Verify Clean

```bash
npm run build
npm test
npm run lint
```

## Step 3: Stage

```bash
git add -A
```

## Step 4: Commit

### Format
```
<type>(<scope>): <subject>

<body>

Closes: <bead-id>
```

### Types
| Type | Use For |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructure |
| `test` | Test changes |
| `docs` | Documentation |
| `chore` | Maintenance |
| `perf` | Performance |

### Example

```bash
git commit -m "feat(auth): add password reset flow

- Add reset password endpoint
- Add email template
- Add rate limiting

Closes: bd-abc123"
```

## Arguments

If `$ARGUMENTS` provided, use as commit message:

```bash
git commit -m "$ARGUMENTS"
```

## Output

```markdown
## Committed

`[sha]` - [message]

Files: [count]
Insertions: +[n]
Deletions: -[n]
```
