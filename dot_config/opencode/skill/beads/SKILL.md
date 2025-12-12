---
name: beads
description: >
  Tracks complex, multi-session work using the Beads issue tracker and dependency graphs, and provides
  persistent memory that survives conversation compaction. Use when work spans multiple sessions, has
  complex dependencies, or needs persistent context across compaction cycles. Trigger with phrases like
  "create task for", "what's ready to work on", "show task", "track this work", "what's blocking", or
  "update status".
allowed-tools: "Read,Bash(bd:*)"
version: "0.34.0"
author: "Steve Yegge <https://github.com/steveyegge>"
license: "MIT"
---

# Beads - Persistent Task Memory for AI Agents

Graph-based issue tracker that survives conversation compaction. Provides persistent memory for multi-session work with complex dependencies.

## Overview

**bd (beads)** replaces markdown task lists with a dependency-aware graph stored in git. Unlike TodoWrite (session-scoped), bd persists across compactions and tracks complex dependencies.

**Key Distinction**:
- **bd**: Multi-session work, dependencies, survives compaction, git-backed
- **TodoWrite**: Single-session tasks, linear execution, conversation-scoped

**Core Capabilities**:
- 📊 **Dependency Graphs**: Track what blocks what (blocks, parent-child, discovered-from, related)
- 💾 **Compaction Survival**: Tasks persist when conversation history is compacted
- 🐙 **Git Integration**: Issues versioned in `.beads/issues.jsonl`, sync with `bd sync`
- 🔍 **Smart Discovery**: Auto-finds ready work (`bd ready`), blocked work (`bd blocked`)
- 📝 **Audit Trails**: Complete history of status changes, notes, and decisions
- 🏷️ **Rich Metadata**: Priority (P0-P4), types (bug/feature/task/epic), labels, assignees

**When to Use bd vs TodoWrite**:
- ❓ "Will I need this context in 2 weeks?" → **YES** = bd
- ❓ "Could conversation history get compacted?" → **YES** = bd
- ❓ "Does this have blockers/dependencies?" → **YES** = bd
- ❓ "Is this fuzzy/exploratory work?" → **YES** = bd
- ❓ "Will this be done in this session?" → **YES** = TodoWrite
- ❓ "Is this just a task list for me right now?" → **YES** = TodoWrite

**Decision Rule**: If resuming in 2 weeks would be hard without bd, use bd.

## Prerequisites

**Required**:
- **bd CLI**: Version 0.34.0 or later installed and in PATH
- **Git Repository**: Current directory must be a git repo
- **Initialization**: `bd init` must be run once (humans do this, not agents)

**Verify Installation**:
```bash
bd --version  # Should return 0.34.0 or later
```

**First-Time Setup** (humans run once):
```bash
cd /path/to/your/repo
bd init  # Creates .beads/ directory with database
```

**Optional**:
- **BEADS_DIR** environment variable for alternate database location
- **Daemon** for background sync: `bd daemon --start`

## Instructions

### Session Start Protocol

**Every session, start here:**

#### Step 1: Smart Triage (Preferred)

```bash
bv --robot-triage
```

**THE MEGA-COMMAND**: Returns everything you need in one call:
- `quick_ref`: At-a-glance counts + top 3 picks
- `recommendations`: Ranked actionable items with scores, reasons, unblock info
- `quick_wins`: Low-effort high-impact items
- `blockers_to_clear`: Items that unblock the most downstream work
- `project_health`: Status/type/priority distributions, graph metrics
- `commands`: Copy-paste shell commands for next steps

**Quick alternatives**:
```bash
bv --robot-next    # Minimal: just single top pick + claim command
bd ready           # Simple list of unblocked tasks (no graph analysis)
```

**⚠️ CRITICAL: Always use `--robot-*` flags. Bare `bv` launches interactive TUI that blocks your session.**

#### Step 2: Pick Top Recommendation

Use the top recommendation from triage, or extract with:
```bash
bv --robot-triage | jq '.recommendations[0]'
```

#### Step 3: Get Full Context

```bash
bd show <task-id>
```

Displays:
- Full task description
- Dependency graph (what blocks this, what this blocks)
- Audit trail (all status changes, notes)
- Metadata (created, updated, assignee, labels)

#### Step 4: Start Working

```bash
bd update <task-id> --status in_progress
```

Marks task as actively being worked on.

#### Step 5: Add Notes as You Work

```bash
bd update <task-id> --notes "Completed: X. In progress: Y. Blocked by: Z"
```

**Critical for compaction survival**: Write notes as if explaining to a future agent with zero conversation context.

**Note Format** (best practice):
```
COMPLETED: Specific deliverables (e.g., "implemented JWT refresh endpoint + rate limiting")
IN PROGRESS: Current state + next immediate step
BLOCKERS: What's preventing progress
KEY DECISIONS: Important context or user guidance
```

---

### Task Creation Workflow

#### When to Create Tasks

Create bd tasks when:
- User mentions tracking work across sessions
- User says "we should fix/build/add X"
- Work has dependencies or blockers
- Exploratory/research work with fuzzy boundaries

#### Basic Task Creation

```bash
bd create "Task title" -p 1 --type task
```

**Arguments**:
- **Title**: Brief description (required)
- **Priority**: 0-4 where 0=critical, 1=high, 2=medium, 3=low, 4=backlog (default: 2)
- **Type**: bug, feature, task, epic, chore (default: task)

**Example**:
```bash
bd create "Fix authentication bug" -p 0 --type bug
```

#### Create with Description

```bash
bd create "Implement OAuth" -p 1 --description "Add OAuth2 support for Google, GitHub, Microsoft. Use passport.js library."
```

#### Epic with Children

```bash
# Create parent epic
bd create "Epic: OAuth Implementation" -p 0 --type epic
# Returns: myproject-abc

# Create child tasks
bd create "Research OAuth providers" -p 1 --parent myproject-abc
bd create "Implement auth endpoints" -p 1 --parent myproject-abc
bd create "Add frontend login UI" -p 2 --parent myproject-abc
```

---

### Update & Progress Workflow

#### Change Status

```bash
bd update <task-id> --status <new-status>
```

**Status Values**:
- `open` - Not started
- `in_progress` - Actively working
- `blocked` - Stuck, waiting on something
- `closed` - Completed

**Example**:
```bash
bd update myproject-abc --status blocked
```

#### Add Progress Notes

```bash
bd update <task-id> --notes "Progress update here"
```

**Appends** to existing notes field (doesn't replace).

#### Change Priority

```bash
bd update <task-id> -p 0  # Escalate to critical
```

#### Add Labels

```bash
bd label add <task-id> backend
bd label add <task-id> security
```

Labels provide cross-cutting categorization beyond status/type.

---

### Dependency Management

#### Add Dependencies

```bash
bd dep add <child-id> <parent-id>
```

**Meaning**: `<parent-id>` blocks `<child-id>` (parent must be completed first).

**Dependency Types**:
- **blocks**: Parent must close before child becomes ready
- **parent-child**: Hierarchical relationship (epics and subtasks)
- **discovered-from**: Task A led to discovering task B
- **related**: Tasks are related but not blocking

**Example**:
```bash
# Deployment blocked by tests passing
bd dep add deploy-task test-task  # test-task blocks deploy-task
```

#### View Dependencies

```bash
bd dep list <task-id>
```

Shows:
- What this task blocks (dependents)
- What blocks this task (blockers)

#### Circular Dependency Prevention

bd automatically prevents circular dependencies. If you try to create a cycle, the command fails.

---

### Completion Workflow

#### Close a Task

```bash
bd close <task-id> --reason "Completion summary"
```

**Best Practice**: Always include a reason describing what was accomplished.

**Example**:
```bash
bd close myproject-abc --reason "Completed: OAuth endpoints implemented with Google, GitHub providers. Tests passing."
```

#### Check Newly Unblocked Work

After closing a task, run:

```bash
bd ready
```

Closing a task may unblock dependent tasks, making them newly ready.

#### Close Epics When Children Complete

```bash
bd epic close-eligible
```

Automatically closes epics where all child tasks are closed.

---

### Git Sync Workflow

#### All-in-One Sync

```bash
bd sync
```

**Performs**:
1. Export database to `.beads/issues.jsonl`
2. Commit changes to git
3. Pull from remote (merge if needed)
4. Import updated JSONL back to database
5. Push local commits to remote

**Use when**: End of session, before handing off to teammate, after major progress.

#### Export Only

```bash
bd export -o backup.jsonl
```

Creates JSONL backup without git operations.

#### Import Only

```bash
bd import -i backup.jsonl
```

Imports JSONL file into database.

#### Background Daemon

```bash
bd daemon --start  # Auto-sync in background
bd daemon --status # Check daemon health
bd daemon --stop   # Stop auto-sync
```

Daemon watches for database changes and auto-exports to JSONL.

---

### Find & Search Commands

#### Find Ready Work

```bash
bd ready
```

Shows tasks with no open blockers.

#### List All Tasks

```bash
bd list --status open           # Only open tasks
bd list --priority 0            # Only P0 (critical)
bd list --type bug              # Only bugs
bd list --label backend         # Only labeled "backend"
bd list --assignee alice        # Only assigned to alice
```

#### Show Task Details

```bash
bd show <task-id>
```

Full details: description, dependencies, audit trail, metadata.

#### Search by Text

```bash
bd search "authentication"      # Search titles and descriptions
bd search login --status open   # Combine with filters
```

#### Find Blocked Work

```bash
bd blocked
```

Shows all tasks that have open blockers preventing them from being worked on.

#### Project Statistics

```bash
bd stats
```

Shows:
- Total issues by status (open, in_progress, blocked, closed)
- Issues by priority (P0-P4)
- Issues by type (bug, feature, task, epic, chore)
- Completion rate

---

### Complete Command Reference

See [references/CLI_REFERENCE.md](references/CLI_REFERENCE.md) for detailed command documentation with examples.

---

## Output

This skill produces:

**Task IDs**: Format `<prefix>-<hash>` (e.g., `claude-code-plugins-abc`, `myproject-xyz`)

**Status Summaries**:
```
5 open, 2 in_progress, 1 blocked, 47 closed
```

**Dependency Graphs** (visual tree):
```
myproject-abc: Deploy to production [P0] [blocked]
  Blocked by:
    ↳ myproject-def: Run integration tests [P1] [in_progress]
    ↳ myproject-ghi: Fix failing tests [P1] [open]
```

**Audit Trails** (complete history):
```
2025-12-22 10:00 - Created by alice (P2, task)
2025-12-22 10:15 - Priority changed: P2 → P0
2025-12-22 10:30 - Status changed: open → in_progress
2025-12-22 11:00 - Notes added: "Implemented JWT auth..."
2025-12-22 14:00 - Status changed: in_progress → blocked
2025-12-22 14:01 - Notes added: "Blocked: API endpoint returns 503"
```

---

## Error Handling

### Common Failures

#### 1. `bd: command not found`
**Cause**: bd CLI not installed or not in PATH
**Solution**: Install from https://github.com/steveyegge/beads
```bash
# macOS/Linux
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

# Or via npm
npm install -g @beads/bd

# Or via Homebrew
brew install steveyegge/beads/bd
```

#### 2. `No .beads database found`
**Cause**: beads not initialized in this repository
**Solution**: Run `bd init` (humans do this once, not agents)
```bash
bd init  # Creates .beads/ directory
```

#### 3. `Task not found: <id>`
**Cause**: Invalid task ID or task doesn't exist
**Solution**: Use `bd list` to see all tasks and verify ID format
```bash
bd list                    # See all tasks
bd search <partial-title>  # Find task by title
```

#### 4. `Circular dependency detected`
**Cause**: Attempting to create a dependency cycle (A blocks B, B blocks A)
**Solution**: bd prevents circular dependencies automatically. Restructure dependency graph.
```bash
bd dep list <id>  # View current dependencies
```

#### 5. Git merge conflicts in `.beads/issues.jsonl`
**Cause**: Multiple users modified same issue
**Solution**: bd sync handles JSONL conflicts automatically. If manual intervention needed:
```bash
# View conflict
git status

# bd provides conflict resolution tools
bd sync --merge  # Attempt auto-resolution
```

#### 6. `Database is locked`
**Cause**: Daemon or another process has exclusive lock
**Solution**: Restart daemon or wait for lock to release
```bash
bd daemon --stop
bd daemon --start
```

#### 7. Sync failures
**Cause**: Network issues, authentication failures, or git configuration
**Solution**: Check git remote access and credentials
```bash
git fetch  # Test connectivity
git status # Verify repo state
```

---

## Examples

### Example 1: Multi-Session Feature (Epic with Children)

**User Request**: "We need to implement OAuth, this will take multiple sessions"

**Agent Response**:
```bash
# Create epic
bd create "Epic: OAuth Implementation" -p 0 --type epic
# Returns: claude-code-plugins-abc

# Create child tasks
bd create "Research OAuth providers (Google, GitHub, Microsoft)" -p 1 --parent claude-code-plugins-abc
# Returns: claude-code-plugins-abc.1

bd create "Implement backend auth endpoints" -p 1 --parent claude-code-plugins-abc
# Returns: claude-code-plugins-abc.2

bd create "Add frontend login UI components" -p 2 --parent claude-code-plugins-abc
# Returns: claude-code-plugins-abc.3

# Add dependencies (backend must complete before frontend)
bd dep add claude-code-plugins-abc.3 claude-code-plugins-abc.2

# Start with research
bd update claude-code-plugins-abc.1 --status in_progress
```

**Result**: Work structured, ready to resume after compaction.

---

### Example 2: Tracking Blocked Work

**Scenario**: Agent discovers API is down during implementation

**Agent Actions**:
```bash
# Mark current task as blocked
bd update claude-code-plugins-xyz --status blocked --notes "API endpoint /auth returns 503, reported to backend team"

# Create blocker task
bd create "Fix /auth endpoint 503 error" -p 0 --type bug
# Returns: claude-code-plugins-blocker

# Link dependency (blocker blocks original task)
bd dep add claude-code-plugins-xyz claude-code-plugins-blocker

# Find other ready work
bd ready
# Shows tasks that aren't blocked - agent can switch to those
```

**Result**: Blocked work documented, agent productive on other tasks.

---

### Example 3: Session Resume After Compaction

**Session 1**:
```bash
bd create "Implement user authentication" -p 1
bd update myproject-auth --status in_progress
bd update myproject-auth --notes "COMPLETED: JWT library integrated. IN PROGRESS: Testing token refresh. NEXT: Rate limiting"
# [Conversation compacted - history deleted]
```

**Session 2** (weeks later):
```bash
bd ready
# Shows: myproject-auth [P1] [task] in_progress

bd show myproject-auth
# Full context preserved:
#   - Title: Implement user authentication
#   - Status: in_progress
#   - Notes: "COMPLETED: JWT library integrated. IN PROGRESS: Testing token refresh. NEXT: Rate limiting"
#   - No conversation history needed!

# Agent continues exactly where it left off
bd update myproject-auth --notes "COMPLETED: Token refresh working. IN PROGRESS: Rate limiting implementation"
```

**Result**: Zero context loss despite compaction.

---

### Example 4: Complex Dependencies (3-Level Graph)

**Scenario**: Build feature with prerequisites

```bash
# Create tasks
bd create "Deploy to production" -p 0
# Returns: deploy-prod

bd create "Run integration tests" -p 1
# Returns: integration-tests

bd create "Fix failing unit tests" -p 1
# Returns: fix-tests

# Create dependency chain
bd dep add deploy-prod integration-tests      # Integration blocks deploy
bd dep add integration-tests fix-tests        # Fixes block integration

# Check what's ready
bd ready
# Shows: fix-tests (no blockers)
# Hides: integration-tests (blocked by fix-tests)
# Hides: deploy-prod (blocked by integration-tests)

# Work on ready task
bd update fix-tests --status in_progress
# ... fix tests ...
bd close fix-tests --reason "All unit tests passing"

# Check ready again
bd ready
# Shows: integration-tests (now unblocked!)
# Still hides: deploy-prod (still blocked)
```

**Result**: Dependency chain enforces correct order automatically.

---

### Example 5: Team Collaboration (Git Sync)

**Alice's Session**:
```bash
bd create "Refactor database layer" -p 1
bd update db-refactor --status in_progress
bd update db-refactor --notes "Started: Migrating to Prisma ORM"

# End of day - sync to git
bd sync
# Commits tasks to git, pushes to remote
```

**Bob's Session** (next day):
```bash
# Start of day - sync from git
bd sync
# Pulls latest tasks from remote

bd ready
# Shows: db-refactor [P1] [in_progress] (assigned to alice)

# Bob checks status
bd show db-refactor
# Sees Alice's notes: "Started: Migrating to Prisma ORM"

# Bob works on different task (no conflicts)
bd create "Add API rate limiting" -p 2
bd update rate-limit --status in_progress

# End of day
bd sync
# Both Alice's and Bob's tasks synchronized
```

**Result**: Distributed team coordination through git.

---

## Resources

### When to Use bd vs TodoWrite (Decision Tree)

**Use bd when**:
- ✅ Work spans multiple sessions or days
- ✅ Tasks have dependencies or blockers
- ✅ Need to survive conversation compaction
- ✅ Exploratory/research work with fuzzy boundaries
- ✅ Collaboration with team (git sync)

**Use TodoWrite when**:
- ✅ Single-session linear tasks
- ✅ Simple checklist for immediate work
- ✅ All context is in current conversation
- ✅ Will complete within current session

**Decision Rule**: If resuming in 2 weeks would be hard without bd, use bd.

---

### Graph-Aware Analysis (bv Sidecar)

`bv` is the graph-aware triage engine. Use `--robot-*` flags for deterministic, dependency-aware outputs with precomputed metrics.

#### Planning & Execution

| Command | Returns |
|---------|---------|
| `bv --robot-triage` | **MEGA-COMMAND**: Everything needed to start work |
| `bv --robot-next` | Minimal: just top pick + claim command |
| `bv --robot-plan` | Parallel execution tracks with `unblocks` lists |
| `bv --robot-priority` | Priority misalignment detection |

#### Graph Metrics

| Command | Returns |
|---------|---------|
| `bv --robot-insights` | Full metrics: PageRank, betweenness, cycles, critical path |
| `bv --robot-insights \| jq '.Cycles'` | Circular dependencies (must fix!) |
| `bv --robot-label-health` | Per-label health: healthy/warning/critical |
| `bv --robot-blocker-chain <id>` | Full blocker chain analysis |

#### History & Forecasting

| Command | Returns |
|---------|---------|
| `bv --robot-history` | Bead-to-commit correlations |
| `bv --robot-forecast <id\|all>` | ETA predictions with dependency-aware scheduling |
| `bv --robot-diff --diff-since <ref>` | Changes since point in time |
| `bv --robot-burndown <sprint>` | Sprint burndown, scope changes |

#### Scoping & Filtering

```bash
bv --robot-plan --label backend          # Scope to label's subgraph
bv --recipe actionable --robot-plan      # Pre-filter: ready to work
bv --recipe high-impact --robot-triage   # Pre-filter: top PageRank scores
```

#### jq Quick Reference

```bash
bv --robot-triage | jq '.quick_ref'                    # At-a-glance summary
bv --robot-triage | jq '.recommendations[0]'           # Top recommendation
bv --robot-plan | jq '.plan.summary.highest_impact'    # Best unblock target
bv --robot-insights | jq '.Cycles'                     # Circular deps
```

---

### Essential Commands Quick Reference

Top 10 most-used commands:

| Command | Purpose |
|---------|---------|
| `bv --robot-triage` | Smart triage with graph analysis |
| `bd ready` | Simple list of unblocked tasks |
| `bd create "Title" -p 1` | Create new task |
| `bd show <id>` | View task details |
| `bd update <id> --status in_progress` | Start working |
| `bd update <id> --notes "Progress"` | Add progress notes |
| `bd close <id> --reason "Done"` | Complete task |
| `bd dep add <child> <parent>` | Add dependency |
| `bd list` | See all tasks |
| `bd sync` | Sync with git remote |

---

### Session Start Protocol (Every Session)

1. **Run** `bv --robot-triage` for smart recommendations (or `bd ready` for simple list)
2. **Pick** top recommendation from triage output
3. **Run** `bd show <id>` to get full context
4. **Update** status to `in_progress`
5. **Add notes** as you work (critical for compaction survival)

---

### Database Selection

bd uses `.beads/` directory by default.

**Alternate Database**:
```bash
export BEADS_DIR=/path/to/alternate/beads
bd ready  # Uses alternate database
```

**Multiple Databases**: Use `BEADS_DIR` to switch between projects.

---

### Advanced Features

For complex scenarios, see references:

- **Workflow Patterns**: `references/WORKFLOWS.md`
  - Standard task workflows
  - Epic management patterns
  - Git sync workflows

- **Dependencies**: `references/DEPENDENCIES.md`
  - Dependency system deep dive
  - Blocking relationships
  - Circular dependency prevention

- **Resumability**: `references/RESUMABILITY.md`
  - Compaction survival guide
  - Context preservation strategies

- **Boundaries**: `references/BOUNDARIES.md`
  - bd vs TodoWrite detailed comparison
  - When to use each tool

- **Integration Patterns**: `references/INTEGRATION_PATTERNS.md`
  - Agent integration strategies
  - Workflow automation patterns

- **Molecules**: `references/MOLECULES.md`
  - Reusable workflow components
  - Common task patterns

- **Patterns**: `references/PATTERNS.md`
  - Best practices and anti-patterns
  - Common pitfalls to avoid

- **Troubleshooting**: `references/TROUBLESHOOTING.md`
  - Common issues and solutions
  - Debugging strategies

---

### Full Documentation

Complete reference: https://github.com/steveyegge/beads

Existing detailed guides:
- `references/CLI_REFERENCE.md` - Complete command syntax
- `references/WORKFLOWS.md` - Detailed workflow patterns
- `references/DEPENDENCIES.md` - Dependency system deep dive
- `references/RESUMABILITY.md` - Compaction survival guide
- `references/BOUNDARIES.md` - bd vs TodoWrite detailed comparison
- `references/STATIC_DATA.md` - Database schema reference

---

**Progressive Disclosure**: This skill provides essential instructions for all 30 beads commands. For advanced topics (compaction, templates, team workflows), see the references directory. Slash commands (`/bd-create`, `/bd-ready`, etc.) remain available as explicit fallback for power users.
