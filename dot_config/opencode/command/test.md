---
description: Run or write tests
subtask: true
---

# /test - Test Execution & Creation

## Input & Flags

| Flag | Mode | Action |
|------|------|--------|
| (none) | Run | Execute all tests |
| `[file]` | Run | Execute specific test file |
| `--tdd [feature]` | TDD | Write failing test first, then implement |
| `--verify` | Verify | Full gates (build + test + lint) |

---

## Run Tests

```bash
npm test                    # All tests
npm test -- {file}          # Specific file
npm test -- --coverage      # With coverage
```

---

## TDD Mode (`--tdd`)

Load `skill("testing-patterns")` first.

**Cycle:** Red → Green → Refactor

1. **Red** - Write failing test (AAA pattern)
2. **Run** - Confirm failure: `npm test -- {test_file}`
3. **Green** - Minimal code to pass
4. **Run** - Confirm passing
5. **Refactor** - Clean up, keep green

```typescript
describe('FeatureName', () => {
  it('should [behavior] when [condition]', () => {
    // Arrange
    const input = createTestData();
    // Act
    const result = functionUnderTest(input);
    // Assert
    expect(result).toEqual(expectedOutput);
  });
});
```

---

## Verify Mode (`--verify`)

```bash
npm run build && npm test && npm run lint && typecheck
```

| Command | Gates | Review | Close | Commit |
|---------|-------|--------|-------|--------|
| `/test --verify` | ✅ | ❌ | ❌ | ❌ |
| `/finish` | ✅ | ✅ | ✅ | ✅ |

---

## Test Priority & Quality

| Priority | Category | FIRST Criteria |
|----------|----------|----------------|
| **Must** | Core logic, public APIs, error handling | **F**ast (<100ms) |
| **Should** | Integration, edge cases | **I**solated (no deps) |
| **Skip** | Trivial getters, framework internals | **R**epeatable, **S**elf-validating, **T**imely |
