# OpenCode Agentic Configuration

A streamlined agentic development workflow for [OpenCode](https://opencode.ai/).

## Quick Start

1. Copy this config to your OpenCode directory:
   - Global: `~/.config/opencode/`
   - Per-project: `.opencode/`

2. Run OpenCode:
   ```bash
   opencode
   ```

3. Start the workflow:
   ```
   /create My new feature
   ```

## Structure

```
├── AGENTS.md          # Main instructions (workflow + rules)
├── opencode.json      # Model settings, agents, permissions
├── dcp.jsonc          # Context pruning configuration
├── agent/             # 10 specialized agent prompts
├── command/           # 19 workflow commands
├── knowledge/         # Searchable pattern files
├── templates/         # Artifact templates
├── plugin/            # Security/utility plugins
├── skills/            # Design skills
└── tool/              # Custom tools
```

## Configuration

### Models

```jsonc
{
  "model": "anthropic/claude-sonnet-4-5",
  "small_model": "anthropic/claude-haiku-4-5"
}
```

### Formatters

```jsonc
{
  "formatter": {
    "prettier": {
      "command": ["npx", "prettier", "--write", "$FILE"],
      "extensions": [".ts", ".tsx", ".js"]
    }
  }
}
```

### Permissions

```jsonc
{
  "permission": {
    "edit": "ask",
    "bash": "ask"
  }
}
```

## Documentation

- **Workflow & Rules**: See `AGENTS.md` for complete workflow, commands, agents, and coding guidelines
- [OpenCode Docs](https://opencode.ai/docs)
- [Config Reference](https://opencode.ai/docs/config)
- [Agents](https://opencode.ai/docs/agents)
- [Commands](https://opencode.ai/docs/commands)
