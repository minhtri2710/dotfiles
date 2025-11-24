---
description: Create an OpenSpec specification for a feature or component
---

# Spec Creation Command

Create a rigorous, machine-readable OpenSpec specification following the Spec-Driven Development (SDD) methodology.

## Workflow

1. **Analyze Context**
   - Use `gkg_repo_map` to understand the project structure
   - Use `gkg_search_codebase_definitions` to find relevant existing code
   - Use `gkg_read_definitions` to understand interfaces and patterns
   - If external libraries are involved, use `codesearch` to research APIs and best practices

2. **Draft the Specification**
   - Create file in `specs/[feature-name].spec.md`
   - Include these sections:
     - **Context**: What files/symbols are involved (using GKG data)
     - **Requirements**: Functional and non-functional requirements
     - **Design**: Proposed interface (signatures, types, API contracts)
     - **Verification**: How it will be tested (acceptance criteria)
   - Use the **"ultrathink"** keyword to enable maximum reasoning depth for architectural analysis

3. **Review with User**
   - Display the complete spec
   - Ask: "Does this spec accurately capture the requirements?"
   - Make adjustments based on feedback

## Example

```
/spec UserSearch API with filtering and pagination
```

**Output**: Creates `specs/user-search.spec.md` with full specification ready for implementation.
