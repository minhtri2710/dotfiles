---
description: Execute implementation, refactoring, or debugging
subtask: false
---

# /build - Implementation

Load context → Implement → Verify → Finish.

## Input & Flags

`$ARGUMENTS` (optional): Bead ID, Epic ID (batch-implement children), or auto-select next ready bead.

| Flag | Effect |
|------|--------|
| `--refactor` | Behavior-preserving (tests before AND after) |
| `--debug` | Root cause analysis mode |
| `--single-file` | Restrict to single file |

## Turn Budget

| Turn | Action |
|------|--------|
| 1-3 | Normal |
| 4-7 | Review, simplify |
| 8-9 | Aggressively simplify |
| 10 | **HARD STOP** — Escalate |

---

## Phase 1: Load Context

```bash
skill("beads")
bd ready --limit 1              # Auto-select if no argument
bd show $ARGUMENTS
bd update $ARGUMENTS --status in_progress
cat .beads/artifacts/{bead_id}/spec.md
cat .beads/artifacts/{bead_id}/plan.md
```

## Phase 2: Implement

**Investigate before coding:** Read files completely before editing. Use LSP tools to understand call sites.

| Mode | Steps |
|------|-------|
| **Default** | Read → understand patterns → implement ONE file at a time → match style → verify each edit |
| **--refactor** | Run tests → small atomic refactor → verify green → repeat |
| **--debug** | Reproduce → hypothesize → fix root cause → add regression test |

**Background verification:** Kick off tests while preparing next step:
```typescript
background_task(agent="tester", prompt="Run tests for {module}")
// Continue working, collect results before next phase
```

## Phase 3: Verify

```bash
lsp_diagnostics {changed_file}  # After each edit
```

Full build/test/lint deferred to `/finish`. Zero tolerance for type errors or broken syntax.

## Phase 4: Quality Gates

| Path | Gates |
|------|-------|
| `trivial` | Lint touched files |
| `normal` | Build + relevant tests + lint |
| `deep` | Full build + all tests + lint clean |

Default: `normal` for single-file, `deep` for multi-file.

## Phase 5: Coach Checkpoint (Deep Only)

```bash
skill("coach-gate")  # After each phase
```

| Verdict | Action |
|---------|--------|
| `APPROVED` | Proceed |
| `NEEDS_CHANGES` | Fix, re-verify, re-submit |
| `BLOCKED` | Escalate |

Skip coach: Trivial always, Normal unless 3+ failures.

## Phase 6: Finish

```bash
/finish $ARGUMENTS
```

---

## Epic Batch Mode

```
WHILE ready_tasks_exist AND consecutive_failures < 3:
  task = bd ready --parent {epic_id} --limit 1
  Implement → gates → /finish OR fix
  IF 3 consecutive failures: STOP, escalate
```

## Turn Tracking

Track turns per phase in plan.md:
- Max 3 attempts per step
- Max 10 turns per phase
- Update: `## Phase 1 [Turn 3/10]`

---

## Rules

| Rule | Why |
|------|-----|
| Read before edit | Understand context first |
| Follow plan exactly | No unrequested features |
| One file at a time | Easier verification |
| Verify after EACH edit | Catch errors early |
| Discoveries → new beads | No scope creep |
