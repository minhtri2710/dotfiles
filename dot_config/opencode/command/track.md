---
description: Create a Beads issue from an approved specification
---

# Track Command

Convert an approved OpenSpec into a tracked Beads issue for implementation.

## Prerequisites

- An approved spec file exists in `specs/` directory
- User has confirmed the specification

## Workflow

1. **Read the Spec**
   - Locate the spec file (ask user if multiple exist)
   - Extract title, description, and key requirements

2. **Create Beads Issue**
   - Use `beads_create` with:
     - **Title**: From spec title
     - **Description**: Reference the spec file path and summarize key requirements
     - **Type**: Appropriate issue type (feature, task, bug, etc.)
     - **Priority**: Based on user input or spec metadata
   - Add relevant labels if applicable

3. **Confirm Creation**
   - Display the created issue ID
   - Show next steps: "Ready to implement. Use `/implement [issue-id]` to begin."

## Example

```
/track specs/user-search.spec.md
```

**Output**: Creates Beads issue `PROJ-123` linked to the specification.
