---
description: Decompose task and run parallel agents
agent: build
subtask: false
---

# Swarm: Parallel Execution

Decompose and parallelize: $ARGUMENTS

## Step 1: Decompose

Break the task into independent subtasks that can run in parallel.

Criteria for parallelization:
- No dependencies between subtasks
- Each subtask is independently verifiable
- Results can be synthesized

## Step 2: Spawn Parallel Agents

```
@explorer: [Task 1 - find relevant files for aspect A]
@explorer: [Task 2 - find relevant files for aspect B]
@analyzer: [Task 3 - analyze specific component]
```

Wait for all to complete.

## Step 3: Synthesize

Combine results from all agents:

```markdown
## Swarm Results: $ARGUMENTS

### Agent 1: [task]
[Summary of findings]

### Agent 2: [task]
[Summary of findings]

### Agent 3: [task]
[Summary of findings]

## Combined Analysis
[Synthesis of all findings]

## Recommendations
1. [Action item]
2. [Action item]
```

## Use Cases

### Research Swarm
```
@explorer: Find all API routes
@explorer: Find all database models
@explorer: Find all middleware
```

### Analysis Swarm
```
@analyzer: Analyze authentication flow
@analyzer: Analyze data validation
@analyzer: Analyze error handling
```

### Implementation Swarm
```
@implementer: Update component A
@implementer: Update component B
@tester: Write tests for changes
```

## Rules

- **Max 5 parallel agents**
- **Wait for all** before synthesizing
- **Verify independently** - Don't assume success
- **Aggregate errors** - Report all failures
