---
description: Continue work in fresh thread with focused context. Cleaner than compaction. Supports parallel exploration.
---

# Handoff Command

Transfer work between threads. Fresh context beats accumulated noise.

## Philosophy

**Small threads, big clarity.**

Compaction keeps everything in one thread, leading to:
- Noise from failed attempts
- Mixed concerns
- Bloated context

**Handoff creates a clean slate** while preserving what matters.

## Session Modes

| Mode | Purpose | When to Use |
|------|---------|-------------|
| `new` | Fresh thread with context | Phase transitions, clean starts |
| `fork` | Parallel independent threads | Try multiple approaches |
| `compact` | Compress current thread | Last resort, must stay in thread |

## Handoff Patterns

### Phase Transitions

```javascript
// Planning → Implementation (fresh thread)
session({
  mode: "new",
  text: "Implement the auth feature. Context: [summary of plan]"
});

// Implementation → Testing (fresh thread)
session({
  mode: "new",
  text: "Write tests for auth. Files: src/auth/*.ts"
});
```

### Parallel Exploration

```javascript
// Try two approaches simultaneously
session({
  mode: "fork",
  text: "Implement using Redux. Context: [requirements]"
});

session({
  mode: "fork",
  text: "Implement using Context API. Context: [requirements]"
});
// Compare results, pick the best
```

### Delegate to Subagents (Same Thread)

Use `task()` for subagent work within current thread:

```javascript
// Deep reasoning
task({
  subagent_type: "subagents/oracle",
  prompt: "Should we use microservices here? Analyze trade-offs."
});

// Code review
task({
  subagent_type: "subagents/review",
  prompt: "Review the auth implementation in src/auth/"
});

// Research external patterns
task({
  subagent_type: "subagents/librarian",
  prompt: "Find React auth patterns in popular libraries"
});

// Quick fixes
task({
  subagent_type: "subagents/rush",
  prompt: "Fix the typo in src/utils.ts line 42"
});
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

## When to Handoff vs Delegate

| Situation | Action |
|-----------|--------|
| Completed one phase, need fresh context | `session({ mode: "new" })` |
| Need specific expertise, same thread | `task({ subagent_type: "..." })` |
| Want to try multiple approaches | `session({ mode: "fork" })` |
| Too many failed attempts | `session({ mode: "new" })` |
| Quick task, no context pollution | `task({ subagent_type: "subagents/rush" })` |

## Subagent Reference

| Subagent | Use For |
|----------|---------|
| `subagents/oracle` | Architecture, complex debugging, design |
| `subagents/review` | Code review, risk analysis |
| `subagents/tester` | Write comprehensive tests |
| `subagents/smart` | Complex features, full autonomy |
| `subagents/rush` | Quick fixes, simple tasks |
| `subagents/search` | Codebase navigation, find definitions |
| `subagents/librarian` | External research, GitHub patterns |
| `subagents/security-auditor` | Security scanning, vulnerability audit |

## Best Practices

1. **One task per thread**: Keep focus tight
2. **Handoff between phases**: Don't mix planning with implementation
3. **Fresh start when stuck**: Debug in clean threads
4. **Use subagents for expertise**: Delegate specialized work via `task()`
5. **Explicit direction**: Tell new thread exactly what to do

<code_exploration>
When handing off, provide sufficient context about files that were inspected. Do not speculate about code you have not read. New threads should verify context before acting.
</code_exploration>
