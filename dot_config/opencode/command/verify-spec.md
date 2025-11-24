---
description: Verify implementation matches its specification
---

# Verify Spec Command

Verify that an implementation correctly follows its OpenSpec specification.

## Workflow

1. **Load Spec and Implementation**
   - Read the spec file
   - Identify implemented files from spec's "Design" section
   - Use `gkg_read_definitions` to load actual implementations

2. **Check Alignment**
   - **Interface Compliance**: Do signatures match the spec?
   - **Type Safety**: Are types correctly implemented?
   - **Requirements Coverage**: Are all functional requirements addressed?
   - **Test Coverage**: Do tests cover all "Verification" points?

3. **Run Verification Suite**
   - Execute tests defined in spec
   - Check for passing status
   - Identify any gaps or failures

4. **Report Results**
   - **Compliant**: "✓ Implementation matches spec"
   - **Deviations Found**: List specific mismatches with file:line references
   - **Missing Tests**: List untested verification points

5. **Recommendations**
   - Suggest fixes for deviations
   - Recommend spec updates if deviations are valid improvements

## Example

```
/verify-spec specs/user-search.spec.md
```

**Output**: Detailed compliance report showing alignment between spec and implementation.
