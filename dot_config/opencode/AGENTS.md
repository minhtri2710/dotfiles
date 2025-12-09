# Agentic Development Configuration

## Workflow

```
/create → /start → /research → /plan → /implement → /finish
```

Artifacts: `.beads/artifacts/<bead-id>/` (spec.md, research.md, plan.md, review.md)

**Review Points**: After /create, /research, /plan (HIGH LEVERAGE), /finish

---

## Commands

| Command | Purpose |
|---------|---------|
| `/create` | Interview → bead + spec.md |
| `/start [id]` | Setup workspace |
| `/research <id>` | Explore → research.md |
| `/plan <id>` | Design → plan.md |
| `/iterate <id>` | Refine plan |
| `/implement <id>` | Execute with verification |
| `/finish [id]` | Verify, commit, close |
| `/handoff <id>` | Capture state |
| `/resume <id>` | Continue from handoff |
| `/commit` | Conventional commit |
| `/debug` | Systematic debugging |
| `/review` | Pre-PR review |
| `/test` | Run/write tests |
| `/swarm` | Parallel agents |
| `/checkpoint` | Mid-session compress |
| `/quick` | Bypass for small fixes |
| `/status` | Overview |
| `/rollback` | Recover failed changes |

---

## Agents

| Agent | Purpose | Mode |
|-------|---------|------|
| `explorer` | File discovery | read |
| `analyzer` | Implementation analysis | read |
| `researcher` | External docs | read |
| `reviewer` | Code review (bugs-first) | read |
| `smart` | Multi-file orchestrator | write |
| `implementer` | Single-file edits | write |
| `debugger` | Root cause analysis | write |
| `tester` | TDD/verification | write |
| `documenter` | Docs, JSDoc | write |
| `refactor` | Safe restructuring | write |

---

## Quality Gates

Before closing ANY bead:
- [ ] Build passes
- [ ] All tests pass
- [ ] Lint passes
- [ ] Plan tests written

**Max 3 attempts per step, then STOP.**

---

## Beads

**Never markdown TODOs. Use `bd` CLI.**

```bash
# Session start
bd ready --json | jq '.[0]'
bd list --status in_progress --json

# During work
bd update ID --status in_progress
bd close ID --reason "Done: brief"
bd create "Found issue" -t bug -p 0

# Session end (MANDATORY)
git pull --rebase && bd sync && git push
```

---

## Tools (Priority)

1. **Read/Edit** - File ops (never bash cat/sed)
2. **GKG** - `gkg_repo_map`, `gkg_search_codebase_definitions`, `gkg_get_references`, `gkg_read_definitions`
3. **Glob/Grep** - File discovery
4. **websearch/codesearch** - External knowledge
5. **Task** - Complex exploration
6. **Bash** - git, bd, tests, builds only

---

## Subagents

**Spawn when**: Unfamiliar code, parallel investigations, independent tasks, deep research
**Do yourself**: Simple sequential, context loaded, tight feedback, immediate verification

---

# Rules

## Communication
- Concise (grammar < brevity)
- No validation/praise
- Direct

## Code Documentation
- Avoid comments unless asked
- Self-documenting via naming
- Only comment non-obvious logic

## Git
**Never git write ops without explicit instruction.**

Allowed: `status`, `diff`, `log`, `show`, `branch -l`
Forbidden: `add`, `commit`, `push`, `pull`, `merge`, `rebase`, `checkout`

## Verification
1. Read before edit
2. Verify assumptions with tools
3. Max 3 attempts then escalate
4. Use file:line references

## Context
- Glob before reading
- Prune after work
- Use subagents for exploration
- Summarize, don't paste

---

# Code Philosophy

**Mantras**: Impossible states impossible • Parse don't validate • Infer over annotate • Discriminated unions over optionals • Composition over inheritance • Server first

**Anti-patterns**: No premature abstraction • No barrel files • Don't mock what you don't own • YAGNI

---

# SOLID (Quick Reference)

| Principle | Rule |
|-----------|------|
| **SRP** | One reason to change |
| **OCP** | Extend, don't modify |
| **LSP** | Subtypes substitutable |
| **ISP** | Small focused interfaces |
| **DIP** | Depend on abstractions |

**KISS**: Simplest solution wins
**DRY**: Single source of truth (abstract on 3rd use)
**YAGNI**: Build for today, not tomorrow

---

## Decision Framework

```
Before code:
├─ Needed NOW? (YAGNI)
├─ Simplest? (KISS)
├─ Duplicates? (DRY)
└─ SOLID?
```
