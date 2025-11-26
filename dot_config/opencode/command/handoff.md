---
description: Continue work in fresh thread with focused context. Cleaner than compaction. Supports agent relay and parallel exploration.
model: google/gemini-2.5-flash
---

# Handoff Command

Transfer work between threads or agents. Fresh context beats accumulated noise.

## Philosophy

**Small threads, big clarity.**

Compaction keeps everything in one thread, leading to:
- Noise from failed attempts
- Mixed concerns
- Bloated context
- Hard to share

**Handoff creates a clean slate** while preserving what matters.

## Session Modes

| Mode | Purpose | When to Use |
|------|---------|-------------|
| `new` | Fresh thread with relevant context | Phase transitions, clean starts |
| `message` | Same thread, different agent | Need help within conversation |
| `fork` | Parallel independent threads | Try multiple approaches |
| `compact` | Compress current thread | Last resort, must stay in thread |

## Handoff Patterns

### Phase Transitions

```javascript
// Planning → Implementation
session({
  mode: "new",
  agent: "build",
  text: "Implement the plan we created for user authentication"
});

// Implementation → Testing
session({
  mode: "new",
  agent: "tester",
  text: "Write comprehensive tests for the auth feature"
});

// Testing → Review
session({
  mode: "new", 
  agent: "review",
  text: "Review the auth implementation and tests"
});
```

### Agent Collaboration

```javascript
// Get architectural guidance
session({
  mode: "message",
  agent: "oracle",
  text: "Should we use microservices here? Analyze the trade-offs."
});

// Quick code review
session({
  mode: "message",
  agent: "review", 
  text: "Review the code I just generated above."
});
```

### Parallel Exploration

```javascript
// Try two approaches simultaneously
session({
  mode: "fork",
  agent: "build",
  text: "Implement using Redux"
});

session({
  mode: "fork",
  agent: "build",
  text: "Implement using Context API"
});
// Compare results, pick the best
```

### Manual Compression (Last Resort)

```javascript
session({
  mode: "compact",
  text: "Continuing implementation..."
});
```

## Direction Examples

Provide clear guidance for new threads:

| Direction | New Thread Focus |
|-----------|------------------|
| "Execute phase one of the plan" | Scoped implementation |
| "Apply this fix to all similar cases" | Pattern propagation |
| "Write tests for what we just built" | Test coverage |
| "Research option 2 further" | Deeper investigation |
| "Check the rest of the codebase for this pattern" | Codebase-wide search |

## When to Handoff

| Situation | Action |
|-----------|--------|
| Completed one phase | Handoff to next phase |
| Fixed one issue | Handoff to propagate fix |
| Too many failed attempts | Fresh start |
| Need specific expertise | Hand to specialized agent |
| Want to share part of work | Isolate in own thread |

## Agent Relay Patterns

```
Research → Plan → Build → Review → Fix

Librarian ──▶ Oracle ──▶ Smart ──▶ Review ──▶ Rush
(research)   (design)   (impl)    (review)   (fixes)
```

## Best Practices

1. **One task per thread**: Keep focus tight
2. **Handoff between phases**: Don't mix planning with implementation
3. **Fresh start when stuck**: Debug in clean threads
4. **Use the right agent**: Match agent to task type
5. **Explicit direction**: Tell new thread exactly what to do
