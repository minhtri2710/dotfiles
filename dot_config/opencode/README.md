# OpenCode Agentic Configuration

Agentic workflow for [OpenCode](https://opencode.ai/) with [Beads](https://github.com/steveyegge/beads) integration.

## Quick Start

1. **Check Dependencies**: Ensure [Beads CLI](https://github.com/steveyegge/beads) and [Beads Viewer](https://github.com/Dicklesworthstone/beads_viewer) (`bv`) are installed.

   ```bash
   bv --version # Verify bv is in your PATH
   ```

1. **Setup Config**: Copy configuration to `~/.config/opencode/` (global) or `.opencode/` (per-project).
1. **Launch**: Run `opencode`.
1. **Begin**: Start with `/start "task description"`.

## Workflow

**Flow:** `/start` → triage → Trivial (quick-fix) | Normal (`/build`) | Deep (`/design` → `/build`) → `/finish`

| Command    | Purpose                                      |
| ---------- | -------------------------------------------- |
| `/start`   | Triage: route to Trivial, Normal, or Deep    |
| `/design`  | Discovery & planning for Deep path           |
| `/build`   | Execute implementation, verify, close bead   |
| `/test`    | Run or write tests                           |
| `/finish`  | Coach review, quality gates, close bead      |
| `/commit`  | Conventional commit with bead reference      |
| `/handoff` | Session state capture                        |
| `/swarm`   | Multi-agent parallel task decomposition      |

## Agents

| Agent       | Role                           |
| ----------- | ------------------------------ |
| `@explore`  | Codebase analysis (READ-ONLY)  |
| `@librarian`| External research + docs       |
| `@developer`| Implementation                 |
| `@tester`   | Test creation                  |
| `@reviewer` | Code review (READ-ONLY)        |

## Plugin Ecosystem

OpenCode features a robust plugin system that extends core capabilities:

| Plugin           | Purpose                                                                                    |
| ---------------- | ------------------------------------------------------------------------------------------ |
| `env-protection` | Protects sensitive files, blocks dangerous commands, and provides audit logs.              |
| `git-safety`     | Safeguards repository integrity by preventing dangerous git operations.                    |
| `smart-commit`   | Enforces conventional commits, warns about missing tests, and auto-generates branch names. |
| `swarm`          | Enables multi-agent coordination and task delegation for complex workflows.                |
| `pickle-thinker` | Injects "Ultrathink: " prefix to optimize models like `glm-*` and `big-pickle`.            |

## Advanced Features

### CASS (Cross-Agent Session Search)

Search across all AI coding agent histories. Use `cass_search` at the start of complex tasks to see how similar problems were solved previously.

### Semantic Memory

Persistent learning across sessions. Use `semantic-memory_store` to record architectural decisions or tricky bug fixes, and `semantic-memory_find` to retrieve them later.

### Skills System

Inject specialized knowledge into agents. Load skills like `beads` for graph-based issue tracking or `frontend-design` for UI/UX patterns using `skills_use`.

## Security

OpenCode is **APPROVED** following a comprehensive security audit. The system implements a defense-in-depth strategy via core protective plugins:

- **Environment Protection (`env-protection`)**:
  - Prevents reading of sensitive files (`.env`, secrets, SSH keys).
  - Blocks dangerous bash commands.
  - Unified JSONL audit logging for all sensitive operations.
- **Git Safety (`git-safety`)**:
  - Prevents accidental commits or pushes to protected branches.
  - Blocks all `git push` operations by default (only allowed during `/finish`).
  - Prevents hard resets on protected branches.
- **Audit Status**: Approved audit for enterprise use.

## Performance

For optimal throughput in large-scale projects:

- **Async Execution**: Leverage the `swarm` plugin to parallelize tasks. For multi-file refactors or large-scale documentation, use swarm to delegate to sub-agents.
- **Incremental Indexing**: Maintain the Knowledge Graph (GKG) via incremental updates to avoid the overhead of full project scans.
- **Selective Context**: Limit the scope of `@explore` to specific directories when working on isolated features.

## Configuration

The `opencode.json` file controls the environment behavior. Key sections include:

- `model`: Primary model for planning and implementation (e.g., `glm-4.6`).
- `small_model`: Efficient model for low-latency tasks.
- `mcp`: Configuration for Model Context Protocol servers (e.g., GKG, chrome-devtools).
- `plugin`: List of enabled plugins.
- `provider`: Custom model providers and their specific limits/modalities.
- `keybinds`: Custom TUI keyboard shortcuts.

## Troubleshooting

- **bv not found**: Ensure `bv` is installed and in your PATH. OpenCode uses `bv` for all graph-aware operations.
- **Permission Denied**: Check `env-protection` settings if an agent is blocked from reading a file.
- **Git Push Failed**: Remember that `git push` is only permitted via the `/finish` command to ensure all quality gates are met.
- **GKG Connection Error**: Ensure the GKG MCP server is running (usually at `127.0.0.1:27495`).

## Beads Integration

```bash
# Analysis (bv = beads_viewer)
bv --robot-insights    # Graph health, cycles
bv --robot-priority    # AI-ranked queue
bv --robot-plan        # Parallel tracks
```

## Structure

```
├── AGENTS.md      # Workflow + rules
├── opencode.json  # Models, permissions
├── agent/         # Agent prompts
├── command/       # Workflow commands
├── plugin/        # Plugins
├── skills/        # Skills
└── tool/          # Custom tools
```

## Docs

- [OpenCode](https://opencode.ai/docs) | [Beads CLI](https://github.com/steveyegge/beads) | [Beads Viewer](https://github.com/Dicklesworthstone/beads_viewer)
