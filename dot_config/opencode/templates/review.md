---
date: [ISO timestamp]
bead: [bead-id]
reviewer: [agent/human]
---

# Code Review: [Title]

## Summary

[One paragraph summary of changes]

## Changes Reviewed

| File | Lines | Type |
|------|-------|------|
| `path/file.ts` | +X/-Y | [new/modified/deleted] |

## Checklist

### Correctness
- [ ] Logic is correct
- [ ] Edge cases handled
- [ ] Error handling present

### Code Quality
- [ ] Follows existing patterns
- [ ] No code duplication
- [ ] Clear naming
- [ ] No unnecessary complexity

### Types
- [ ] Type-safe (no `any`)
- [ ] Proper error types
- [ ] Discriminated unions where appropriate

### Testing
- [ ] Tests exist
- [ ] Tests cover happy path
- [ ] Tests cover edge cases
- [ ] Tests are maintainable

### Security
- [ ] No secrets in code
- [ ] Input validation
- [ ] No SQL/command injection

## Issues Found

### 🔴 Blockers (Must Fix)

1. **[Issue Title]**
   - File: `path/file.ts:45`
   - Problem: [Description]
   - Suggestion: [How to fix]

### 🟡 Suggestions (Should Consider)

1. **[Issue Title]**
   - File: `path/file.ts:78`
   - Suggestion: [Improvement]

### 🟢 Nitpicks (Optional)

1. [Minor style/preference items]

## Verdict

- [ ] ✅ **Approved** - Ready to merge
- [ ] 🔄 **Changes Requested** - Address blockers first
- [ ] ❌ **Rejected** - Major rework needed

## Notes

[Additional context, questions, or praise]
