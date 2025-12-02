---
description: Initialize AGENTS.md for a new project
agent: build
subtask: false
---

# Initialize Project

Create project-specific AGENTS.md.

## Step 1: Analyze Project

!`ls package.json pyproject.toml Cargo.toml go.mod 2>/dev/null | head -1`

!`cat package.json 2>/dev/null | head -30`

## Step 2: Detect Stack

Identify:
- Language (TypeScript, Python, Rust, Go)
- Framework (Next.js, React, FastAPI, etc.)
- Build tool
- Test framework
- Linter

## Step 3: Check Existing Config

```bash
ls .cursor/rules .cursorrules .github/copilot-instructions.md AGENTS.md 2>/dev/null
```

## Step 4: Generate AGENTS.md

```markdown
# AGENTS.md

## Commands

- Install: `[detected]`
- Build: `[detected]`
- Test: `[detected]`
- Test single: `[detected with path placeholder]`
- Lint: `[detected]`

## Structure

- Source: `[path]`
- Tests: `[path]`
- Config: `[path]`

## Conventions

- [Stack-specific conventions]
- [Project patterns found]

## Safety

- Never execute shell with user input
- Never commit secrets
- [Project-specific rules]
```

## Step 5: Report

```markdown
## Created: AGENTS.md

Stack:
- Language: [lang]
- Framework: [framework]
- Tests: [test framework]

Commands:
- `npm run build`
- `npm test`
- `npm run lint`

Review and customize as needed.
```
