---
description: Systematic debugging with root cause analysis
agent: debugger
subtask: true
---

# Debug Issue

Systematic debugging for: $ARGUMENTS

## Step 1: Gather Information

What's the error?

!`npm test 2>&1 | tail -50`

## Step 2: Reproduce

Run the failing code:

```bash
npm test -- --grep "$ARGUMENTS"
```

## Step 3: Spawn Debugger

```
@debugger: Debug the following issue:

Error: $ARGUMENTS

Context:
- [relevant files]
- [recent changes if known]

Find root cause and fix.
```

## Step 4: Report

```markdown
## Debug: $ARGUMENTS

### Error
```
[exact error message]
```

### Root Cause
[What's actually wrong]

### Fix Applied
- `file.ts:45` - [change]

### Verification
- [ ] Error gone
- [ ] Tests pass
- [ ] No regression
```
