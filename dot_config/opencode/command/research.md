---
description: Deep codebase research before planning
agent: build
subtask: true
---

# Research Codebase

Deep exploration for bead: $ARGUMENTS

## Guardrails

- **No code changes** - Read-only exploration
- **Ground findings in evidence** - Cite file:line for every claim
- **Focus on the task** - Don't explore unrelated areas
- **Summarize, don't paste** - Condense findings into insights

## Prerequisites

Load the spec first:

```bash
cat .beads/artifacts/$ARGUMENTS/spec.md 2>/dev/null || echo "No spec found - run /create first"
```

**If no spec exists, STOP and run /create first.**

## Steps

Track these as TODOs and complete one by one:

### Step 1: Understand Requirements

From spec.md, identify:
- [ ] What needs to change?
- [ ] What are the success criteria?
- [ ] What's out of scope?

### Step 2: Codebase Intelligence (GKG)

Use Knowledge Graph for precise exploration:

```
# Get structure overview
gkg_repo_map: relative_paths=["src/relevant-dir"], depth=2

# Find definitions
gkg_search_codebase_definitions: search_terms=["ComponentName", "functionName"]

# Find all usages of key symbols
gkg_get_references: definition_name="existingFunction", file_path="src/file.ts"
```

### Step 3: Parallel Deep Exploration

Spawn parallel explorers for areas GKG identified:

```
@explorer: Analyze [component from GKG results]
@explorer: Find similar implementations in the codebase
@analyzer: Deep dive into [complex file from GKG]
```

Wait for all to complete.

### Step 4: Analyze Patterns

For each key file found:

```
@analyzer: Analyze [file] for patterns, dependencies, and integration points
```

Questions to answer:
- [ ] What patterns does existing code follow?
- [ ] What dependencies are involved?
- [ ] What could break with changes?

### Step 5: External Knowledge (Exa)

If task involves libraries, APIs, or unfamiliar patterns:

```
# For API/library usage
codesearch: query="[library] [specific feature] examples", tokensNum=5000

# For best practices or troubleshooting
websearch: query="[technology] [pattern] best practices 2024"
```

Document external findings in research artifact.

### Step 6: Identify Risks

- [ ] Breaking changes to existing code?
- [ ] Missing test coverage?
- [ ] Complex dependencies?

### Step 7: Write Research Artifact

Save to `.beads/artifacts/$ARGUMENTS/research.md`:

```markdown
---
date: [timestamp]
bead: $ARGUMENTS
---

# Research: [topic]

## Summary
- [Key finding 1]
- [Key finding 2]
- [Key finding 3]

## Code References

| File | Lines | Purpose |
|------|-------|---------|
| `path/file.ts` | 45-78 | [what it does] |

## Patterns to Follow
- [Pattern from file:line]
- [Convention to match]

## External References
- [Library docs URL]
- [Best practice article]

## Risks
- [Potential issue and mitigation]
- [Edge case to handle]

## Architecture Notes
- [Design constraint]
- [Integration point]

## Open Questions
- [Anything unclear that needs human input]
```

### Step 8: Validate & Present

Before presenting:
- [ ] Every finding has file:line evidence
- [ ] Risks have proposed mitigations
- [ ] Open questions are explicit (not hidden assumptions)

Present findings and ask:

> Research complete. Review findings above. Any questions before planning?

**WAIT for human review before /plan.**

## Reference

- `cat .beads/artifacts/$ARGUMENTS/spec.md` - Original requirements
- `bd show $ARGUMENTS` - Bead details
- GKG tools for codebase intelligence
- `codesearch`/`websearch` for external knowledge
