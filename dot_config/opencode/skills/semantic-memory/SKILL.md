---
name: semantic-memory
description: Persistent learning storage - store and retrieve learnings across sessions
---

# Semantic Memory - Persistent Learning

Store and retrieve learnings across sessions. Memories persist and are searchable.

## When to Use

- After solving a tricky problem - store the solution
- After making architectural decisions - store the reasoning
- Before starting work - search for relevant past learnings
- When you discover project-specific patterns

## Usage

```bash
# Store a learning
semantic-memory_store(information="OAuth refresh tokens need 5min buffer before expiry", metadata="auth, tokens")

# Search for relevant memories
semantic-memory_find(query="token refresh", limit=5)

# Validate a memory is still accurate (resets decay timer)
semantic-memory_validate(id="mem_123")
```

## Pro Tips

- Store the WHY, not just the WHAT. Future you needs context.
- Use descriptive metadata tags for better searchability
- Validate memories periodically to prevent decay
