# Agentic Development Configuration

## Core Workflow

```
/create → /start → /research → /plan → /implement → /finish
```

Each phase runs as **subtask** (fresh context). Artifacts persist in `.beads/artifacts/<bead-id>/`.

---

## The Complete Workflow

```
/create                   →  Interview → bead + spec.md
      ↓
/start [bead-id]          →  Setup workspace → load context
      ↓
/research <bead-id>       →  Explore codebase → research.md
      ↓
   [Review research.md]   ←  HIGH LEVERAGE REVIEW
      ↓
/plan <bead-id>           →  Design + testing strategy → plan.md
      ↓
   [Review plan.md]       ←  HIGH LEVERAGE REVIEW
      ↓                       ↑
      └── /iterate ───────────┘  (if changes needed)
      ↓
/implement <bead-id>      →  Execute plan with verification
      ↓
   [Build + Tests + Lint] ←  HARD GATE (must all pass)
      ↓
/finish <bead-id>         →  Commit + close bead

Session Continuity:
────────────────────
/handoff <bead-id>        →  Capture state (context limit)
/resume <bead-id>         →  Continue from handoff
/checkpoint               →  Mid-session compression
```

---

## Commands

| Command | Purpose |
|---------|---------|
| `/create` | Interview → bead + spec.md |
| `/start [id]` | Setup workspace, load context |
| `/research <id>` | Explore codebase → research.md |
| `/plan <id>` | Design + testing → plan.md |
| `/iterate <id>` | Refine plan based on feedback |
| `/implement <id>` | Execute plan with verification |
| `/finish [id]` | Verify, commit, close bead |
| `/handoff <id>` | Capture state for continuity |
| `/resume <id>` | Continue from handoff |
| `/commit` | Conventional commit |
| `/debug` | Systematic debugging |
| `/review` | Pre-PR code review |
| `/test` | Run or write tests |
| `/swarm` | Parallel agent coordination |
| `/checkpoint` | Mid-session compression |
| `/init` | Create project-specific AGENTS.md |
| `/quick` | Bypass workflow for small fixes |
| `/status` | Workspace and bead overview |
| `/rollback` | Recover from failed changes |

---

## Agents

| Agent | Purpose | Mode |
|-------|---------|------|
| `plan` | Strategic planning (built-in primary) | read-only |
| `explorer` | Fast file discovery, navigation | read-only |
| `analyzer` | Deep implementation analysis | read-only |
| `researcher` | External documentation | read-only |
| `reviewer` | Code review (bugs-first) | read-only |
| `smart` | Multi-file orchestrator | write |
| `implementer` | Focused single-file edits | write |
| `debugger` | Root cause analysis | write |
| `tester` | TDD or verification tests | write |
| `documenter` | READMEs, JSDoc, guides | write |
| `refactor` | Safe code restructuring | write |

---

## Quality Gates (Non-Negotiable)

Before closing ANY bead:

- [ ] **Build passes**
- [ ] **All tests pass** (existing + new)
- [ ] **Lint passes**
- [ ] **Tests from plan written**

**Max 3 attempts per step, then STOP and escalate.**

---

## Beads Workflow

**NEVER use markdown TODO files. Always use beads (`bd` CLI).**

### Session Start
```bash
bd ready --json | jq '.[0]'           # What's unblocked?
bd list --status in_progress --json   # What's in flight?
```

### During Work
```bash
bd update ID --status in_progress     # Claim task
bd close ID --reason "Done: brief"    # Complete task
bd create "Found issue" -t bug -p 0   # File discovery
bd dep add NEW PARENT --type discovered-from
```

### Session End (MANDATORY)
```bash
git pull --rebase && bd sync && git push
git status   # MUST show "up to date"
```

**Session is NOT complete until `git push` succeeds.**

### Epic Decomposition
```bash
bd create "Feature" -t epic -p 1      # bd-HASH (parent)
bd create "Phase 1" -p 2              # bd-HASH.1 (child)
bd create "Phase 2" -p 2              # bd-HASH.2 (child)
```

---

## Human Review Points

| Checkpoint | Artifact | Decision |
|------------|----------|----------|
| After `/create` | spec.md | Problem well-defined? |
| After `/research` | research.md | Findings correct? |
| After `/plan` | plan.md | Approve approach? |
| After `/finish` | commits | Ready to merge? |

---

## Tool Preferences

Priority order:
1. **Read/Edit** - Direct file operations (never bash cat/sed)
2. **GKG (Knowledge Graph)** - Codebase intelligence:
   - `gkg_repo_map` - Get structure overview of directories
   - `gkg_search_codebase_definitions` - Find functions, classes, constants
   - `gkg_get_references` - Find all usages of a symbol
   - `gkg_read_definitions` - Read full implementation
3. **Glob/Grep** - File discovery and pattern search
4. **websearch/codesearch** - External knowledge (Exa-powered):
   - `codesearch` - API docs, library examples, patterns
   - `websearch` - Articles, best practices, troubleshooting
5. **Task (subagent)** - Complex multi-step exploration
6. **Bash** - git, bd, tests, builds only

---

## Subagent Triggers

**Spawn subagent when:**
- Exploring unfamiliar code areas
- Running parallel investigations
- Task is independently verifiable
- Need deep research, only summary back

**Do yourself when:**
- Simple sequential task
- Context already loaded
- Tight user feedback needed
- File edits needing immediate verification

---

## Parallel Execution

```
Phase 1 - Locate (parallel):
├─ @explorer: Find component A
├─ @explorer: Find component B
└─ @explorer: Find similar patterns
[WAIT]

Phase 2 - Analyze (parallel):
├─ @analyzer: Analyze component A
└─ @analyzer: Analyze component B
[WAIT]

Synthesize findings → artifact
```

---

## Artifacts

```
.beads/artifacts/<bead-id>/
├── spec.md       # /create
├── research.md   # /research
├── plan.md       # /plan
├── review.md     # /finish
└── handoffs/     # /handoff
    └── YYYY-MM-DD_handoff.md
```

---

# Agent Rules

## Communication Style

- **Be concise** - Sacrifice grammar for brevity
- **No validation** - Never "you're right" or "excellent question"
- **No praise** - Get to the point without flattery
- **Be direct** - State what needs to happen

---

## Code Documentation

- **Avoid comments** unless explicitly asked
- **Self-documenting code** through clear naming
- **Only comment** non-obvious logic, workarounds, context
- **Never docstrings** that restate the function name

```typescript
// BAD: Redundant
/** Gets user by ID */
function getUserById(id: string) { }

// GOOD: Adds value
/** @throws {NotFoundError} when user doesn't exist */
function getUserById(id: string) { }
```

---

## Git Operations

**NEVER perform git operations without explicit user instruction.**

### Allowed (Read-Only)
```bash
git status
git diff
git log
git show
git branch -l
```

### Forbidden (Without Permission)
```bash
git add
git commit
git push
git pull
git merge
git rebase
git checkout
```

**Only perform when:**
1. User explicitly asks
2. User invokes `/commit` command
3. User says "commit these changes"

---

## Tool Constraints

### Bash
- **FORBIDDEN** for reading files: `cat`, `head`, `tail`, `less`, `bat`
- **PREFER** Read tool for all file reading
- **ALLOWED**: `rg` for search, `tail -f` for logs

---

## Verification Requirements

1. **Read before edit** - Always read files completely before modifying
2. **Verify assumptions** - Use tools to confirm, never guess
3. **Max 3 attempts** - Per step, then STOP and escalate
4. **Ground all claims** - Use file:line references

---

## Context Management

- **Glob before reading** - Find files first, read selectively
- **Prune after work** - Clean context after completing units
- **Use subagents** - For exploration (keeps main context clean)
- **Summarize findings** - Don't paste raw tool output

---

# Code Philosophy

## Mantras

- Make impossible states impossible
- Parse, don't validate
- Infer over annotate
- Discriminated unions over optionals
- Composition over inheritance
- Server first, client when necessary

## Anti-Patterns

- Don't abstract prematurely (wait for third use)
- No barrel files unless necessary
- Don't mock what you don't own
- No "just in case" code (YAGNI)

---

# Coding Principles

## SOLID Principles

### S - Single Responsibility Principle (SRP)
> A class/module should have only one reason to change.

- Each function does ONE thing well
- Split when you see "and" in descriptions
- Cohesion over convenience

```typescript
// BAD: Multiple responsibilities
class UserService {
  createUser() { }
  sendEmail() { }
  generateReport() { }
}

// GOOD: Single responsibility
class UserService { createUser() { } }
class EmailService { send() { } }
class ReportGenerator { generate() { } }
```

### O - Open/Closed Principle (OCP)
> Open for extension, closed for modification.

- Extend behavior without changing existing code
- Use composition, interfaces, and polymorphism
- Plugin architectures over switch statements

```typescript
// BAD: Modify existing code for new types
function getArea(shape: Shape) {
  if (shape.type === 'circle') return Math.PI * shape.r ** 2
  if (shape.type === 'square') return shape.s ** 2
  // Must modify for each new shape
}

// GOOD: Extend without modification
interface Shape { area(): number }
class Circle implements Shape { area() { return Math.PI * this.r ** 2 } }
class Square implements Shape { area() { return this.s ** 2 } }
```

### L - Liskov Substitution Principle (LSP)
> Subtypes must be substitutable for their base types.

- Derived classes honor base class contracts
- No surprising behavior in subclasses
- Prefer composition when inheritance breaks contracts

```typescript
// BAD: Square breaks Rectangle contract
class Rectangle { setWidth(w) { } setHeight(h) { } }
class Square extends Rectangle {
  setWidth(w) { this.width = this.height = w } // Violates LSP
}

// GOOD: Separate types or use composition
interface Shape { area(): number }
class Rectangle implements Shape { }
class Square implements Shape { }
```

### I - Interface Segregation Principle (ISP)
> Clients shouldn't depend on interfaces they don't use.

- Small, focused interfaces over fat ones
- Role interfaces over header interfaces
- Split when clients use only subset

```typescript
// BAD: Fat interface
interface Worker {
  work(): void
  eat(): void
  sleep(): void
}

// GOOD: Segregated interfaces
interface Workable { work(): void }
interface Eatable { eat(): void }
interface Sleepable { sleep(): void }
```

### D - Dependency Inversion Principle (DIP)
> Depend on abstractions, not concretions.

- High-level modules don't depend on low-level modules
- Both depend on abstractions
- Inject dependencies, don't instantiate

```typescript
// BAD: Direct dependency
class OrderService {
  private db = new MySQLDatabase() // Concrete dependency
}

// GOOD: Depend on abstraction
class OrderService {
  constructor(private db: Database) { } // Injected abstraction
}
```

---

## KISS - Keep It Simple, Stupid

> The simplest solution is usually the best.

**Guidelines:**
- Prefer readable over clever
- Avoid premature optimization
- Reduce cognitive load
- If it needs comments to explain, simplify it

```typescript
// BAD: Clever but complex
const r = a.reduce((p,c,i) => (i%2 ? p : [...p, c]), [])

// GOOD: Simple and clear
const result = array.filter((_, index) => index % 2 === 0)
```

**Questions to ask:**
- Can a junior developer understand this?
- Is there a simpler standard library function?
- Am I solving a problem that doesn't exist yet?

---

## DRY - Don't Repeat Yourself

> Every piece of knowledge must have a single, unambiguous representation.

**Guidelines:**
- Extract common logic into functions
- Use constants for magic values
- Single source of truth for business rules
- BUT: Don't over-DRY (some duplication is acceptable)

```typescript
// BAD: Repeated validation
function createUser(email: string) {
  if (!email.includes('@')) throw new Error('Invalid email')
}
function updateEmail(email: string) {
  if (!email.includes('@')) throw new Error('Invalid email')
}

// GOOD: Single source of truth
const validateEmail = (email: string) => {
  if (!email.includes('@')) throw new Error('Invalid email')
}
function createUser(email: string) { validateEmail(email) }
function updateEmail(email: string) { validateEmail(email) }
```

**When duplication is OK:**
- Code looks similar but serves different domains
- Coupling the code would create unwanted dependencies
- Rule of three: abstract on third occurrence, not first

---

## YAGNI - You Aren't Gonna Need It

> Don't implement something until it's necessary.

**Guidelines:**
- Build for today's requirements, not tomorrow's guesses
- Delete speculative code
- Avoid "just in case" abstractions
- Cost of carrying unused code > cost of adding later

```typescript
// BAD: Speculative generalization
interface DataStore<T, K, V, O extends Options> {
  get(key: K, options?: O): Promise<T>
  set(key: K, value: V, options?: O): Promise<void>
  // 20 more methods "we might need"
}

// GOOD: Build what you need now
interface Cache {
  get(key: string): Promise<string | null>
  set(key: string, value: string, ttl?: number): Promise<void>
}
```

**Signs of YAGNI violation:**
- "We might need this later"
- "It would be easy to add now"
- Configurable features no one requested
- Abstract factories for single implementations

---

## Principle Interactions

| Situation | Apply |
|-----------|-------|
| Adding new feature | OCP - extend, don't modify |
| Class doing too much | SRP - split responsibilities |
| Complex inheritance | LSP - verify substitutability |
| Fat interfaces | ISP - segregate by client |
| Hard to test | DIP - inject dependencies |
| Repeated code (3x) | DRY - extract abstraction |
| Speculative code | YAGNI - delete it |
| Clever solution | KISS - simplify it |

---

## Decision Framework

```
Before writing code, ask:
├─ Is this needed NOW? (YAGNI)
├─ Is this the simplest solution? (KISS)
├─ Does this duplicate existing code? (DRY)
└─ Does this follow SOLID?
   ├─ One reason to change? (SRP)
   ├─ Extendable without modification? (OCP)
   ├─ Subtypes substitutable? (LSP)
   ├─ Interface minimal for clients? (ISP)
   └─ Depending on abstractions? (DIP)
```
