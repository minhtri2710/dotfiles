# Agentic Development

## Core Principles

| Principle | Meaning |
|-----------|---------|
| **Artifacts > Memory** | Write to `.beads/artifacts/{bead_id}/`, don't rely on context |
| **Explicit Gates** | `/create`, `/research`, `/plan` ALWAYS wait for user approval |
| **Chesterton's Fence** | Understand WHY before changing WHAT |
| **Async Agents** | Use `background_task`, never blocking `Task` |

```typescript
background_task(agent="explore", prompt="...")
background_output(task_id="...")
```

---

## Critical Directives

1. **Verify First** – Read before edit, `lsp_diagnostics` after EACH change
2. **Atomic Work** – One deliverable, one concern per task
3. **Graph-Aware** – Use `bd`/`bv` CLI (NOT `hive_*`/`swarm_*`—those are `/swarm` only)
4. **Git Safety** – NEVER `add`/`commit`/`push` except via `/commit` or `/finish`
5. **No Hallucination** – Cite `file:line` for all claims
6. **Turn Budget** – Max 10 turns: 1-3 normal, 4-7 review, 8-9 simplify, 10 STOP

**Statuses:** `open` → `in_progress` → `closed` | `blocked` | `cancelled`/`wontfix`/`duplicate`

---

## Paths & Quality Gates

| Path | Criteria | Flow | Gates |
|------|----------|------|-------|
| `trivial` | Typo, 1-liner | `skill("quick-fix")` | Lint |
| `normal` | 1-2 files, bug/chore | `/start` → `/build` → `/finish` | Build + tests + lint |
| `deep` | 3+ files, feature, high-risk | `/create` → `/research` → `/plan` → `/build` → `/finish` | Full build + all tests + lint + coach APPROVED |

**Forces Deep:** Security, billing, migrations, public API, multi-service

Set path: `bd update {bead_id} --path {trivial|normal|deep}`

---

## Commands

| Command | Purpose | Flags |
|---------|---------|-------|
| `/start` | Triage → route | `--deep`, `--quick` |
| `/create` | Interview → bead + spec.md | — |
| `/research` | Explore → research.md | `--quick`, `--precision` |
| `/plan` | Design → plan.md + child beads | `--quick`, `--confirm-only` |
| `/build` | Implement | `--refactor`, `--debug`, `--single-file` |
| `/test` | Test creation | `--tdd`, `--verify` |
| `/finish` | Review + close | `--no-commit`, `--docs-only` |
| `/commit` | Safe git commit | — |
| `/handoff` | Save session state | — |
| `/rehydrate` | Restore from handoff | — |
| `/coach` | Adversarial validation | — |
| `/scout` | Async exploration | — |
| `/swarm` | Multi-agent parallel | `--fast`, `--auto` |

---

## Agents

| Agent | Role | Tools |
|-------|------|-------|
| @explore | Codebase analysis (READ-ONLY) | `read`, `glob`, `grep`, `gkg_*`, `lsp_*`, `ast_grep_search` |
| @librarian | External research + docs | `websearch`, `webfetch`, `codesearch`, `read`, `edit` |
| @developer | Implementation | `read`, `edit`, `lsp_diagnostics`, `typecheck`, `bash`, `git-context` |
| @tester | Test creation | `read`, `edit`, `bash`, `typecheck`, `glob`, `grep` |
| @reviewer | Code review (READ-ONLY) | `read`, `glob`, `grep`, `lsp_diagnostics`, `git-context`, `typecheck` |

### Command → Agent Map

| Command | Primary | Delegates |
|---------|---------|-----------|
| `/start` | main | @explore, @librarian |
| `/create` | main | @librarian, @explore |
| `/research` | @explore | @librarian |
| `/plan` | @explore | @librarian |
| `/build` | @developer | @tester, @explore |
| `/test` | @tester | @developer |
| `/finish` | @reviewer | @tester, @developer |
| `/commit` | @developer | — |
| `/handoff` | main | @explore |
| `/rehydrate` | main | @explore |
| `/coach` | @reviewer | @tester, @developer |
| `/scout` | @explore | @librarian |
| `/swarm` | main | all |

---

## Artifacts

Location: `.beads/artifacts/{bead_id}/`

| File | Owner | Lifecycle |
|------|-------|-----------|
| `spec.md` | `/create` | Permanent |
| `plan.md` | `/plan` | Delete after close |
| `research.md` | `/research` | Delete after close |

---

## Completion Gates

A bead **CANNOT** close until:
- Build passes
- ALL tests pass
- Lint passes
- Plan's tests written
- **Parent beads**: all children closed first

---

## Skills

| Skill | Entry Points | Notes |
|-------|--------------|-------|
| `beads` | `/start`, `/create`, `/plan`, `/build`, `/finish` | — |
| `quick-fix` | `/start` → Trivial | — |
| `coach-gate` | `/build` (Deep), `/finish` | Via `/coach` |
| `semantic-memory` | `/start`, `/research`, `/finish` | — |
| `testing-patterns` | `/test` | — |
| `swarm-coordination` | `/swarm` | — |
