---
name: cass
description: Cross-Agent Session Search - search across AI coding agent histories
---

# CASS - Cross-Agent Session Search

Search across ALL your AI coding agent histories before solving problems from scratch.

## When to Use

- **BEFORE implementing anything**: check if any agent solved it before
- **Debugging**: "what did I try last time this error happened?"
- **Learning patterns**: "how did Cursor handle this API?"

## Usage

```bash
# Search all agents
cass_search(query="authentication token refresh", limit=5)

# Filter by agent/time
cass_search(query="useEffect cleanup", agent="claude", days=7)

# View specific result
cass_view(path="/path/from/search", line=42)

# Expand context around match
cass_expand(path="/path", line=42, context=10)
```

## Pro Tips

- Query CASS at the START of complex tasks. Past solutions save time.
- Use agent filter to find how specific tools (Cursor, Claude, etc.) solved problems
- Combine with `days` filter to find recent, relevant solutions
