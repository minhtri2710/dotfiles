---
name: semantic-memory
description: >
  Persistent learning storage across sessions. Store architectural decisions, bug fixes,
  gotchas, and patterns. Retrieve before starting complex tasks. Use when: making decisions
  that should persist, solving tricky bugs, documenting non-obvious patterns, starting
  new work in familiar areas.
version: "1.0.0"
tools:
  - semantic-memory_store
  - semantic-memory_find
  - semantic-memory_validate
---

# Semantic Memory - Persistent Learning

Store and retrieve learnings across sessions. Memories persist, are searchable, and decay over time unless validated.

## Overview

Semantic memory captures **WHY** decisions were made, not just **WHAT** was done. It's the institutional knowledge that survives context compaction and session boundaries.

**Key Properties:**
- 🧠 **Persistent**: Survives across sessions and compactions
- 🔍 **Searchable**: Find relevant memories by semantic similarity
- ⏱️ **Decay-aware**: Old memories decay unless validated as still accurate
- 🏷️ **Tagged**: Metadata enables filtering by domain, component, or pattern

## When to Use

### Store Memories When:

| Trigger | Example |
|---------|---------|
| Solved a tricky bug | "Race condition in auth refresh fixed by adding mutex" |
| Made architectural decision | "Chose JWT over sessions because of microservice scaling" |
| Discovered non-obvious pattern | "All API routes must validate tenant context first" |
| Found project-specific gotcha | "Never use `any` in this codebase - strict typing enforced" |
| Learned from code review | "Prefer composition over inheritance in UI components" |

### Search Memories When:

| Trigger | Example Query |
|---------|---------------|
| Starting work in familiar area | "authentication token refresh" |
| About to make architectural choice | "database migration patterns" |
| Debugging similar issue | "race condition async" |
| Before `/create` or `/research` | "[feature domain] patterns decisions" |

## Usage

### Storing a Learning

```typescript
semantic-memory_store({
  information: "OAuth refresh tokens need 5min buffer before expiry to prevent race conditions during concurrent requests",
  metadata: "auth, oauth, tokens, race-condition, timing"
})
```

**Best Practices for `information`:**
- Include the **WHY**, not just the **WHAT**
- Be specific enough to be actionable
- Include file references if relevant
- Write as if explaining to a future agent with zero context

**Good:**
> "In auth/refresh.ts, tokens are refreshed 5 minutes before expiry (not at expiry) because concurrent requests during refresh window caused 401 cascades. See PR #234."

**Bad:**
> "Fixed token refresh bug"

### Searching for Memories

```typescript
semantic-memory_find({
  query: "token refresh authentication",
  limit: 5
})
```

**Returns:** Ranked list of memories with relevance scores.

### Validating a Memory

```typescript
semantic-memory_validate({
  id: "mem_abc123"
})
```

**Purpose:** Confirms memory is still accurate. Resets decay timer.

Use when:
- You verified a past learning still applies
- Codebase confirms the memory's claim
- Pattern is still in use

## Integration Patterns

### At Session Start

```typescript
// Before diving into implementation
semantic-memory_find({ query: "[task domain] [key concepts]", limit: 5 })

// Check what past agents learned about this area
```

### During /create and /research

```typescript
// Phase 0 of /create
skill("semantic-memory")
semantic-memory_find({ query: "[feature description]", limit: 5 })

// Incorporate relevant learnings into spec.md
```

### After Solving Problems

```typescript
// After fixing a non-trivial bug
semantic-memory_store({
  information: "[Root cause] + [Solution] + [Prevention pattern]",
  metadata: "[component], [symptom], [pattern]"
})
```

### Before /finish

```typescript
// Extract key decisions from the epic
skill("semantic-memory")
semantic-memory_store({
  information: "Key decisions from epic-123: [decision 1], [decision 2]",
  metadata: "[epic-id], [components touched], [patterns used]"
})
```

## Memory Decay

Memories have a decay score based on:
- Time since last validation
- How often they're retrieved
- Whether they've been contradicted

**High Decay (may be stale):**
- Old memories never validated
- Memories about rapidly-changing code areas

**Low Decay (likely current):**
- Recently validated memories
- Memories about stable patterns

## Metadata Tags

Use consistent tags for better retrieval:

| Category | Example Tags |
|----------|-------------|
| Components | `auth`, `api`, `database`, `ui`, `config` |
| Patterns | `race-condition`, `caching`, `validation`, `error-handling` |
| Decisions | `architecture`, `library-choice`, `tradeoff` |
| Symptoms | `performance`, `memory-leak`, `timeout`, `flaky-test` |

## Examples

### Example 1: Bug Fix Learning

```typescript
semantic-memory_store({
  information: "useEffect cleanup race condition in React: When fetching data, always use AbortController and check mounted state. Pattern: `const controller = new AbortController(); return () => controller.abort();` See components/DataFetcher.tsx:45-67 for reference implementation.",
  metadata: "react, useEffect, race-condition, fetch, cleanup, abort"
})
```

### Example 2: Architecture Decision

```typescript
semantic-memory_store({
  information: "Chose Prisma over TypeORM for this project because: 1) Better TypeScript inference, 2) Simpler migration workflow, 3) Team familiarity. Tradeoff: Prisma is slower for complex queries. Decision made 2024-01 by @alice.",
  metadata: "database, orm, prisma, typeorm, architecture-decision"
})
```

### Example 3: Project-Specific Pattern

```typescript
semantic-memory_store({
  information: "All API handlers in this project MUST check `req.tenantContext` before any database operation. Multi-tenant isolation is enforced at application layer, not database. Violation causes data leakage. See middleware/tenant.ts.",
  metadata: "api, multi-tenant, security, middleware, validation"
})
```

## Error Handling

| Error | Cause | Fix |
|-------|-------|-----|
| Memory not found | ID doesn't exist or expired | Search again with broader query |
| Store failed | Backend unavailable | Retry or note in bead for later |
| No relevant results | Query too specific | Broaden terms, try synonyms |

## Quick Reference

```typescript
// Store
semantic-memory_store({
  information: "WHAT happened + WHY it matters + WHERE it applies",
  metadata: "tag1, tag2, tag3"
})

// Find
semantic-memory_find({
  query: "semantic search terms",
  limit: 5
})

// Validate (keep memory fresh)
semantic-memory_validate({ id: "mem_xxx" })
```

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Storing WHAT only | No context for future agents | Include WHY and WHERE |
| Overly broad tags | Poor retrieval precision | Use specific, consistent tags |
| Never validating | Memories decay to uselessness | Validate when you confirm accuracy |
| Storing everything | Noise drowns signal | Store only non-obvious learnings |
