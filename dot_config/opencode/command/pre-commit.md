---
description: Fast pre-commit validation. Checks staged files only tests, lint, secrets, formatting. Blocks or approves commit.
---

# Pre-Commit Command

Quick quality gate before committing. Validates only staged files for fast feedback.

## Checks Performed

| Check       | Scope               | Fail Condition   |
| ----------- | ------------------- | ---------------- |
| **Tests**   | Affected files only | Any test failure |
| **Lint**    | Staged files        | Unfixable errors |
| **Secrets** | Staged files        | Any detected     |
| **Format**  | Staged files        | Violations found |

## Workflow

### Step 1: Identify Staged Files

```bash
git diff --cached --name-only
```

Output:

```
src/services/auth.ts
src/utils/validation.ts
tests/auth.test.ts
```

### Step 2: Run Affected Tests

Only tests related to changed files:

```bash
# Find and run related tests
bun test --related src/services/auth.ts src/utils/validation.ts
```

### Step 3: Lint Staged Files

```bash
# ESLint with auto-fix attempt
eslint --fix src/services/auth.ts src/utils/validation.ts

# Report unfixable issues
eslint src/services/auth.ts src/utils/validation.ts
```

### Step 4: Secrets Scan

```bash
# Check for hardcoded secrets
rg -l "(password|secret|api[_-]?key)\s*[:=]\s*['\"][^'\"]+['\"]" \
  src/services/auth.ts src/utils/validation.ts

# Check for tokens
rg -l "(ghp_|sk-|Bearer\s+[A-Za-z0-9])" \
  src/services/auth.ts src/utils/validation.ts
```

### Step 5: Format Check

```bash
# Prettier check (don't fix, just report)
prettier --check src/services/auth.ts src/utils/validation.ts
```

## Output Format

### All Passed

```markdown
## Pre-Commit Checks ✅

| Check   | Status   | Details              |
| ------- | -------- | -------------------- |
| Tests   | ✅ Pass  | 8/8 affected tests   |
| Lint    | ✅ Clean | 0 errors, 0 warnings |
| Secrets | ✅ Clear | No secrets detected  |
| Format  | ✅ OK    | All files formatted  |

**Ready to commit!**
```

### Failures Found

````markdown
## Pre-Commit Checks ❌

| Check   | Status   | Details              |
| ------- | -------- | -------------------- |
| Tests   | ❌ Fail  | 2/8 failed           |
| Lint    | ⚠️ Warn  | 0 errors, 3 warnings |
| Secrets | ❌ Block | 1 potential secret   |
| Format  | ✅ OK    | All files formatted  |

### Blocking Issues

#### Failed Tests

- `auth.test.ts:45` - Expected token to be valid
- `auth.test.ts:67` - Timeout exceeded

#### Potential Secret

- `auth.ts:23` - Hardcoded API key detected
  ```typescript
  const API_KEY = "sk-abc123..."; // Move to env
  ```
````

### Recommended Actions

1. Fix failing tests:

   ```bash
   bun test tests/auth.test.ts
   ```

2. Move secret to environment:

   ```typescript
   const API_KEY = process.env.API_KEY;
   ```

3. Re-run pre-commit:

   ```
   /pre-commit
   ```

````

## Speed Optimizations

| Technique | Benefit |
|-----------|---------|
| Staged files only | Skip unchanged code |
| Related tests only | Skip unaffected tests |
| Parallel checks | Run lint + secrets together |
| Fail fast | Stop on first blocker |

## Integration

Can be used with git hooks:

```bash
# .husky/pre-commit
opencode run /pre-commit
````

## Example

```
/pre-commit
```

**Output**: Fast validation of staged changes, blocks commit if issues found.
