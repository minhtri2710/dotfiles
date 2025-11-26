---
description: Full quality assurance suite. Tests, coverage, lint, security audit, build verification. Blocks on critical issues.
---

# QA-Pipeline Command

Comprehensive quality assurance for release readiness. Runs all checks, reports everything, blocks on critical issues.

## Pipeline Stages

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│  TEST   │──▶│  LINT   │──▶│ SECURITY│──▶│  BUILD  │──▶│  DOCS   │
│         │   │         │   │         │   │         │   │         │
│ Unit    │   │ ESLint  │   │ npm     │   │ Compile │   │ README  │
│ Integ   │   │ Format  │   │ audit   │   │ Bundle  │   │ API     │
│ Cover   │   │ Types   │   │ Secrets │   │ Size    │   │ Comments│
└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
```

## Stage Details

### 1. Test Execution

```bash
# Unit tests with coverage
bun test --coverage

# Integration tests (if available)
bun test:integration

# Generate coverage report
```

**Success Criteria**:
- All tests pass
- Coverage >= 80% (configurable)

### 2. Code Quality

```bash
# Linting
eslint . --ext .ts,.tsx,.js,.jsx

# Type checking
tsc --noEmit

# Formatting
prettier --check "**/*.{ts,tsx,js,jsx,json,md}"
```

**Success Criteria**:
- 0 lint errors
- 0 type errors
- All files formatted

### 3. Security Audit

```bash
# Dependency vulnerabilities
npm audit --json

# Or for other package managers
yarn audit --json
pnpm audit --json
```

**Plus code scanning via @security-auditor**:
- Hardcoded secrets
- SQL injection patterns
- XSS vulnerabilities

**Success Criteria**:
- 0 critical vulnerabilities
- 0 high vulnerabilities (blocking)
- Medium/low reported but not blocking

### 4. Build Verification

```bash
# Production build
bun run build

# Check for warnings
# Verify output exists
# Check bundle size (if configured)
```

**Success Criteria**:
- Build completes without errors
- No unexpected warnings
- Bundle size within limits (if set)

### 5. Documentation Check

- README.md exists and has content
- API documentation present (if applicable)
- Code comments on public interfaces
- CHANGELOG updated (for releases)

## Output Report

```markdown
## QA Pipeline Report

**Project**: my-project
**Date**: 2024-01-15T14:30:00Z
**Duration**: 2m 34s

### Summary

| Stage | Status | Details |
|-------|--------|---------|
| Tests | ✅ Pass | 156/156 passed (87% coverage) |
| Lint | ✅ Clean | 0 errors, 2 warnings |
| Security | ⚠️ Review | 0 critical, 0 high, 3 medium |
| Build | ✅ Success | 234KB bundle |
| Docs | ✅ Complete | README, API docs present |

### Overall: ✅ PASS

---

### Detailed Results

#### Test Results
```
Test Suites: 12 passed, 12 total
Tests:       156 passed, 156 total
Coverage:    87.3% statements, 82.1% branches
```

#### Security Findings

| Package | Severity | CVE | Recommendation |
|---------|----------|-----|----------------|
| lodash | Medium | CVE-2021-23337 | Upgrade to 4.17.21 |
| axios | Medium | CVE-2023-45857 | Upgrade to 1.6.0 |
| debug | Medium | CVE-2017-16137 | Upgrade to 4.3.4 |

#### Lint Warnings
- `src/utils.ts:45` - Unused variable 'temp'
- `src/api.ts:123` - Any type usage

### Recommendations

1. **Address security**: Update dependencies
   ```bash
   npm update lodash axios debug
   ```

2. **Fix lint warnings**: Clean up unused code

3. **Improve coverage**: Add tests for uncovered branches
```

## Failure Blocking

| Finding | Action |
|---------|--------|
| Test failure | ❌ Block release |
| Critical/High CVE | ❌ Block release |
| Build failure | ❌ Block release |
| Type errors | ❌ Block release |
| Lint errors | ❌ Block release |
| Medium CVE | ⚠️ Report, don't block |
| Lint warnings | ⚠️ Report, don't block |
| Coverage < threshold | ⚠️ Warn, configurable |

## Example

```
/qa-pipeline
```

**Output**: Comprehensive quality report with pass/fail status and actionable recommendations.
