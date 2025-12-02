# Git Conventions

Standard git practices for consistent version control.

---

## Commit Messages

### Format: Conventional Commits

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Types

| Type | When to Use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code change, no behavior change |
| `perf` | Performance improvement |
| `test` | Adding/fixing tests |
| `chore` | Build, deps, tooling |
| `revert` | Reverting previous commit |

### Examples

```bash
# Feature
feat(auth): add OAuth2 login flow

# Bug fix
fix(api): handle null response from server

# Breaking change
feat(api)!: change response format

BREAKING CHANGE: Response now returns array instead of object

# With scope and body
fix(parser): handle edge case in date parsing

The parser was failing when dates contained timezone
offsets in non-standard formats.

Closes: #123
```

---

## Branch Naming

### Format

```
<type>/<bead-id>-<short-description>
```

### Examples

```bash
feat/bd-a1b2-user-auth
fix/bd-c3d4-null-pointer
refactor/bd-e5f6-cleanup-utils
```

### Types

- `feat/` - Feature branches
- `fix/` - Bug fixes
- `hotfix/` - Urgent production fixes
- `refactor/` - Code improvements
- `docs/` - Documentation
- `test/` - Test additions
- `chore/` - Maintenance

---

## Workflow

### Starting Work

```bash
git checkout main
git pull --rebase
git checkout -b feat/bd-xxxx-description
```

### During Work

```bash
# Frequent small commits
git add -p  # Stage interactively
git commit -m "feat(scope): incremental progress"

# Stay up to date
git fetch origin
git rebase origin/main
```

### Finishing Work

```bash
# Squash if needed
git rebase -i HEAD~n

# Push
git push -u origin HEAD

# Create PR
gh pr create
```

---

## Rebase vs Merge

### Prefer Rebase

```bash
# Keep history linear
git pull --rebase origin main

# Never rebase public branches
# Only rebase your own feature branches
```

### When to Merge

- Merging feature into main (via PR)
- Preserving complex branch history intentionally

---

## Stashing

### Quick Stash

```bash
git stash push -m "WIP: description"
```

### List Stashes

```bash
git stash list
```

### Apply Stash

```bash
git stash pop        # Apply and remove
git stash apply      # Apply and keep
git stash drop       # Remove without applying
```

---

## Undo Operations

### Undo Last Commit (Keep Changes)

```bash
git reset --soft HEAD~1
```

### Undo Last Commit (Discard Changes)

```bash
git reset --hard HEAD~1
```

### Undo Staged File

```bash
git restore --staged file.ts
```

### Undo Working Directory Changes

```bash
git restore file.ts
```

### Undo Published Commit

```bash
git revert <sha>
```

---

## .gitignore Patterns

### Must Ignore

```gitignore
# Dependencies
node_modules/
.pnpm-store/

# Build output
dist/
build/
.next/

# Environment
.env
.env.local
.env*.local

# IDE
.idea/
.vscode/
*.swp

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Testing
coverage/
.nyc_output/
```

---

## Hooks (Recommended)

### Pre-commit

```bash
#!/bin/sh
npm run lint-staged
```

### Commit-msg

```bash
#!/bin/sh
npx commitlint --edit $1
```

### Pre-push

```bash
#!/bin/sh
npm test
```

---

## Common Mistakes

### Don't Commit

- Secrets/API keys
- Large binary files
- Generated files
- Personal IDE settings

### Don't Force Push

```bash
# Never on shared branches
git push --force  # ❌

# Use force-with-lease if you must
git push --force-with-lease  # Safer
```

### Don't Commit Broken Code

```bash
# Always verify before commit
npm run build && npm test && git commit
```
