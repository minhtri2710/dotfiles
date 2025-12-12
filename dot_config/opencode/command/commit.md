---
description: Create conventional commit with bead reference
subtask: false
---

# /commit - Conventional Commit

Stage → Verify → Commit. **NEVER pushes** — use `/finish` for push.

**Input:** `$ARGUMENTS` (optional) - Custom commit message override

---

## Phase 1: Pre-Commit Verification

```bash
typecheck && npm run lint && npm test
```

**If any gate fails:** Fix first, then retry.

---

## Phase 2: Stage & Review

```bash
git add -A && git status
```

Verify: no secrets, no build artifacts, no unintended files.

---

## Phase 3: Commit

**Format:** `<type>(<scope>): <subject>` + body + `Closes: <bead-id>`

| Type | Use | Type | Use |
|------|-----|------|-----|
| `feat` | New feature | `test` | Test changes |
| `fix` | Bug fix | `docs` | Documentation |
| `refactor` | Restructure | `chore` | Maintenance |
| `perf` | Performance | `style` | Formatting |

**Rules:** Imperative mood, no period, max 50 chars, lowercase start. Body explains WHY.

**Example:**
```bash
git commit -m "feat(auth): add password reset flow

Users can reset via email. Token expires in 24h.

Closes: oc-abc123"
```

---

## Rules

| Rule | Rationale |
|------|-----------|
| NEVER push | `/finish` handles push |
| NEVER skip verification | Broken commits waste time |
| ALWAYS include bead ID | Traceability |
| NEVER commit secrets | Security |
