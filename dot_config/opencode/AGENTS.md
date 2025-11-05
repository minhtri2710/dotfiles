# Agent Tool Usage Rules

## Required MCP Tools

### 1. Exa MCP

- **ALWAYS use for external library documentation**
- Use `exa_get_code_context_exa` for API documentation, library usage, and framework examples
- Use `exa_web_search_exa` for real-time web searches and current information

### 2. GKG MCP (Gitlab Knowledge Graph)

- **ALWAYS use for codebase understanding**
- Use `gkg_search_codebase_definitions` to find functions/classes/methods
- Use `gkg_get_references` to find all usages of a definition
- Use `gkg_read_definitions` to read implementation code
- Use `gkg_repo_map` for project structure overview
- Use `gkg_get_definition` to resolve symbol definitions

## Tool Priority

1. **External libraries**: ALWAYS use Exa MCP for documentation and usage examples
2. **Codebase exploration**: Always use GKG MCP tools before Read/Grep
3. **Code analysis**: Use GKG MCP for definitions, references, and structure

## Implementation Rules

- **ALWAYS** use `exa_get_code_context_exa` when working with external libraries or frameworks
- **ALWAYS** use `gkg_search_codebase_definitions` before `read` or `grep` for codebase exploration
- **ALWAYS** use `gkg_read_definitions` to read function/class implementations
- Use GKG MCP + Exa MCP in combination for comprehensive understanding
- Only use basic file tools when MCP tools cannot provide the information
