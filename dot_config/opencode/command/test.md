---
description: Run or write tests
agent: tester
subtask: true
---

# Test

Run or write tests.

## Usage

- `/test` - Run all tests
- `/test [file]` - Test specific file  
- `/test --tdd [feature]` - TDD mode
- `/test --verify [file]` - Write tests for existing code

## Run Tests

```bash
npm test
```

If `$ARGUMENTS` specified:

```bash
npm test -- --grep "$ARGUMENTS"
```

## Write Tests (TDD or Verify)

```
@tester: [Mode] for $ARGUMENTS

Context:
- Files: [relevant files]
- Behavior: [what to test]

Focus on:
- Happy path
- Edge cases  
- Error handling
```

## Report

```markdown
## Test Results

### Run
```
✓ [n] passing
✗ [n] failing
```

### Coverage
- Happy path: ✓/✗
- Edge cases: ✓/✗
- Errors: ✓/✗
```
