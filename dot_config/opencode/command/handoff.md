---
description: Continue work in a new thread with relevant context (no compaction - fresh start)
---

# Handoff Command

Continue your work from one thread in a new thread with focused context. **Keep threads small and focused on a single task.**

## Philosophy: No More Compaction

**Why handoff instead of compaction?**

Compaction tries to keep everything in one thread, leading to:
- Accumulated noise from failed attempts
- Mixed concerns in a single thread
- Bloated context windows
- Harder to share specific work

**Handoff creates a clean slate** while preserving what matters.

## How Handoff Works

Using the `session` tool with `mode: "new"`:

1. **Extracts Relevant Context**
   - Files that were modified or discussed
   - Key decisions and insights
   - Relevant code references

2. **Creates Fresh Thread**
   - Clean context window
   - Focused on the next step
   - Easy to share independently

3. **Provides Direction**
   - Your guidance shapes the new thread's focus

## Usage

### Basic Handoff (New Thread)

Use `mode: "new"` to start fresh with relevant context:

```javascript
session({
  mode: "new",
  agent: "build", // optional: specify agent (plan, build, oracle, etc.)
  text: "now implement this for teams as well, not just individual users"
});
```

### Direction Examples

Provide clear guidance for the new thread:

- `"execute phase one of the created plan"`
- `"check the rest of the codebase and find other places that need this fix"`
- `"apply the same refactoring pattern to the backend API"`
- `"write tests for the implementation we just created"`
- `"based on the research, implement option 2"`

## When to Use Handoff

**Good times for handoff**:
- ✅ Completed one phase, moving to the next
- ✅ Fixed one issue, need to apply elsewhere
- ✅ Finished planning, ready to implement
- ✅ Thread has too many failed attempts
- ✅ Want to share just one part of work

**Common patterns**:
- Planning → Implementation: `"now implement the plan we created"`
- Fix → Propagate: `"apply this fix to all similar cases"`
- Feature → Tests: `"write comprehensive tests for this feature"`
- Research → Action: `"implement the researched solution"`

## Other Session Modes

### Collaboration (Same Context)

Use `mode: "message"` when you need another agent's help within the same conversation:

```javascript
session({
  mode: "message",
  agent: "review",
  text: "Please review the code I just generated above."
});
```

### Parallel Exploration (Fork)

Use `mode: "fork"` to try multiple approaches simultaneously:

```javascript
session({
  mode: "fork",
  agent: "build",
  text: "Implement using Redux"
});
```

### Manual Compression (Last Resort)

Use `mode: "compact"` only if you must stay in the same thread:

```javascript
session({
  mode: "compact",
  text: "Continuing implementation..."
});
```

**Note**: Prefer handoff (`mode: "new"`) over compaction for cleaner threads.

## Thread Best Practices

1. **One task per thread**: Keep focus tight
2. **Handoff between phases**: Plan → Implement → Test → Review
3. **Fresh start when stuck**: Don't debug in messy threads
4. **Share specific work**: Each thread is independently shareable

## Agent Handoff Patterns

- **Research → Plan**: Librarian research → Oracle architecture
- **Plan → Build**: Oracle spec → Build implementation
- **Build → Review**: Implementation → Review for bugs
- **Review → Fix**: Bug findings → Build fixes them
