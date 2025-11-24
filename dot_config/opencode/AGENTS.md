# OpenCode Configuration Repository

This is a configuration repository for OpenCode agents. No build/test commands - it contains markdown configuration files only.

## Build/Lint/Test

- **No tests**: This is a config-only repository
- **No build**: Static markdown and JS files loaded directly by OpenCode
- **Validation**: OpenCode validates YAML frontmatter and plugin syntax on load

## Structure

- `agent/subagents/*.md` - Subagent definitions (smart, rush, oracle, review, librarian, search, tester)
- `command/*.md` - Custom commands (sdd, spec, track, implement, verify-spec, handoff)
- `plugin/*.js` - OpenCode plugins (env-protection)
- `skills/` - Skill definitions

## File Format Standards

### Subagent Files (`agent/subagents/*.md`)

- YAML frontmatter with: `description`, `mode: subagent`, `temperature`, `tools`, `permissions`
- Markdown body contains agent system prompt and workflow instructions
- Temperature: 0.1 (review), 0.2 (rush/oracle), 0.3 (smart/librarian)

### Command Files (`command/*.md`)

- YAML frontmatter with: `description`
- Markdown body explains command purpose, workflow, and examples
- Focus on practical usage patterns

## Code Style

- **Markdown**: Use ATX headers (`#`), fenced code blocks with language tags
- **JavaScript**: ES6+ module syntax, async/await for promises, export named functions
- **Naming**: kebab-case for files, descriptive names (e.g., `env-protection.js`)
- **Permissions**: Always deny dangerous operations (`rm -rf`, `sudo`), ask for sensitive files (`.env`, `.key`)
- **Error Handling**: Throw descriptive errors in plugins; use try-catch for async operations
- **Imports**: Use ES6 imports, no CommonJS require; destructure parameters from plugin context

## Tool Usage Priority

1. **External libraries**: Use `codesearch` for API docs and examples
2. **Codebase exploration**: Use GKG MCP tools (`gkg_search_codebase_definitions`, `gkg_read_definitions`, `gkg_get_references`)
3. **Fallback**: Use basic file tools only when MCP cannot provide info

## Conventions

- Generic, model-agnostic language throughout
- Security first: deny access to secrets, environment files, private keys
- Subagents should have clear, focused responsibilities

We track work in Beads instead of Markdwn. Run \`bd quickstart\` to se how.
