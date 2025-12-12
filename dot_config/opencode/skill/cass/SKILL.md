---
name: cass
description: >
  Cross-Agent Session Search - search across ALL AI coding agent histories (Claude, Cursor,
  Copilot, OpenCode, etc.). Find how similar problems were solved before. Use when: starting
  complex tasks, debugging familiar issues, learning patterns from past sessions, before
  implementing unfamiliar features.
version: "1.0.0"
tools:
  - cass_search
  - cass_view
  - cass_expand
---

# CASS - Cross-Agent Session Search

Search across ALL your AI coding agent histories before solving problems from scratch.

## Overview

CASS indexes conversations from multiple AI coding assistants:
- Claude (Anthropic)
- Cursor
- GitHub Copilot
- OpenCode
- Aider
- And others...

**Key Insight:** You've likely solved similar problems before. CASS helps you find those solutions instead of reinventing them.

## When to Use

### Query CASS When:

| Trigger | Why |
|---------|-----|
| Starting complex task | Find prior approaches to similar problems |
| Debugging familiar error | "What did I try last time this happened?" |
| Implementing unfamiliar pattern | See how other agents approached it |
| Before `/create` or `/research` | Leverage existing solutions |
| Architecture decisions | "How did we handle X in project Y?" |

### Don't Query CASS When:

| Trigger | Why |
|---------|-----|
| Simple, well-known task | Overhead not worth it |
| Completely novel problem | No prior art exists |
| Time-critical hotfix | Just fix it |

**Heuristic:** If you're about to spend >30 minutes on something, spend 30 seconds checking CASS first.

## Usage

### Basic Search

```typescript
cass_search({
  query: "authentication token refresh race condition",
  limit: 5
})
```

**Returns:** List of matching session excerpts with:
- File path to session
- Matching line numbers
- Snippet preview
- Agent source (claude, cursor, etc.)

### Filtered Search

```typescript
// Only recent sessions
cass_search({
  query: "useEffect cleanup",
  days: 7,
  limit: 5
})

// Specific agent
cass_search({
  query: "prisma migration",
  agent: "cursor",
  limit: 5
})

// Specific project
cass_search({
  query: "auth middleware",
  project: "my-saas-app",
  limit: 5
})
```

### View Full Context

```typescript
// After finding relevant result
cass_view({
  path: "/path/from/search/result",
  line: 42
})
```

### Expand Around Match

```typescript
// Get more context around a match
cass_expand({
  path: "/path/from/search",
  line: 42,
  context: 20  // Lines above and below
})
```

## Integration Patterns

### At Task Start

```typescript
// Before implementing, check what's been done
cass_search({ query: "[task keywords] [domain]", limit: 5 })

// If relevant results found:
cass_view({ path: result.path, line: result.line })

// Extract patterns, avoid past mistakes
```

### During /research Phase

```typescript
// Phase 1 of /research
skill("cass")
cass_search({ query: "[bead description] [tech stack]", limit: 5 })

// Include relevant findings in research.md
```

### Debugging

```typescript
// When hitting familiar error
cass_search({ query: "[error message] [component]", limit: 5 })

// Find what worked (or didn't) before
```

### Cross-Project Learning

```typescript
// Learning from other projects
cass_search({
  query: "rate limiting implementation",
  limit: 10
})

// See how different projects approached the same problem
```

## Search Strategies

### Effective Queries

| Type | Example | Why It Works |
|------|---------|--------------|
| Error + context | "TypeError undefined map react" | Specific symptom + technology |
| Pattern + domain | "authentication middleware express" | Clear pattern in context |
| Decision + tradeoff | "prisma vs typeorm decision" | Captures reasoning |
| Bug + component | "race condition useEffect fetch" | Symptom + location |

### Query Refinement

If initial search yields poor results:

1. **Broaden terms:** "auth token" → "authentication"
2. **Add technology:** "caching" → "redis caching node"
3. **Try synonyms:** "mutex" → "lock" → "semaphore"
4. **Use error codes:** "TS2345" → finds exact TypeScript error

## Output Interpretation

### High-Value Results

Look for:
- Complete solutions with explanations
- Failed attempts (learn what NOT to do)
- Architectural discussions
- Code with context about WHY

### Low-Value Results

Skip:
- Incomplete snippets without context
- Very old sessions (may be outdated)
- Different tech stack (may not apply)

## Examples

### Example 1: Finding Past Bug Fix

```typescript
// Current problem: Token refresh causing 401s
cass_search({
  query: "token refresh 401 race condition",
  limit: 5
})

// Result shows solution from 2 weeks ago:
// "Added mutex around refresh, ensured single in-flight request"
// → Apply same pattern
```

### Example 2: Architecture Decision

```typescript
// Deciding on state management
cass_search({
  query: "zustand vs redux decision react",
  limit: 5
})

// Result shows past reasoning:
// "Chose Zustand for simpler API, no boilerplate"
// → Inform current decision
```

### Example 3: Cross-Agent Learning

```typescript
// Cursor had a good approach last month
cass_search({
  query: "graphql resolver n+1 dataloader",
  agent: "cursor",
  limit: 5
})

// Apply Cursor's solution in OpenCode session
```

## Combining with Semantic Memory

CASS and semantic-memory are complementary:

| Tool | Stores | Best For |
|------|--------|----------|
| **CASS** | Full session transcripts | Finding approaches, code patterns |
| **semantic-memory** | Distilled learnings | Quick facts, decisions, gotchas |

**Pattern:**
1. Search CASS for detailed context
2. Extract key learning
3. Store in semantic-memory for quick future access

```typescript
// Found solution in CASS
const cassResult = cass_search({ query: "...", limit: 5 })
cass_view({ path: cassResult[0].path, line: cassResult[0].line })

// Distill and store for quick access
semantic-memory_store({
  information: "Pattern from CASS: [distilled solution]",
  metadata: "[tags]"
})
```

## Quick Reference

```typescript
// Search across all agents
cass_search({ query: "terms", limit: 5 })

// Filter by time
cass_search({ query: "terms", days: 7, limit: 5 })

// Filter by agent
cass_search({ query: "terms", agent: "claude", limit: 5 })

// View specific result
cass_view({ path: "/path", line: 42 })

// Expand context
cass_expand({ path: "/path", line: 42, context: 20 })
```

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Searching after implementing | Wasted effort if solution existed | Search FIRST |
| Ignoring failed attempts | Repeat same mistakes | Learn from failures too |
| Copying without understanding | Cargo cult coding | Understand WHY it worked |
| Too specific queries | No results | Start broad, narrow down |
| Never searching | Reinvent wheels | Make it a habit at task start |

## Best Practices

1. **Search at session start** — 30 seconds can save 30 minutes
2. **Query before `/create`** — Prior art informs specs
3. **Check failed attempts** — What didn't work is valuable
4. **Distill to semantic-memory** — Quick access to key learnings
5. **Note which agents excel** — Different tools, different strengths
