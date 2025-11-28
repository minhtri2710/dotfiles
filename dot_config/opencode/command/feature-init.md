---
description: Bootstrap new feature development. Creates OpenSpec change, Beads issues, branch, and test stubs. Ready for TDD implementation.
---

# Feature-Init Command

One command to set up everything for new feature development: OpenSpec change proposal, Beads issues, branch, and test scaffolding.

## What It Creates

```
┌─────────────────────────────────────────────────────────────┐
│  /feature-init "User profile settings"                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. OpenSpec    openspec/changes/add-user-profile-settings/ │
│  2. Epic        PROJ-124 (feature, priority 2)              │
│  3. Subtasks    PROJ-125, PROJ-126, ... (from tasks.md)     │
│  4. Branch      feature/PROJ-124-user-profile-settings      │
│  5. Test Stubs  tests/user-profile-settings.test.ts         │
│                                                             │
│  Status: Ready for /implement add-user-profile-settings     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Workflow

### Step 1: Gather Requirements

Prompt user for:

| Field | Example | Required |
|-------|---------|----------|
| Feature name | "User profile settings" | Yes |
| Description | "Allow users to update profile" | Yes |
| Priority | 1-5 (default: 2) | No |
| Target | "Q1 2024" or specific date | No |
| Key requirements | Bullet points | Yes |

### Step 2: Create OpenSpec Change Proposal

1. **Analyze context via GKG**
   ```
   gkg_repo_map           → Project structure
   gkg_search_codebase_definitions → Related code
   ```

2. **Create change directory**
   ```bash
   mkdir -p openspec/changes/add-user-profile-settings/specs/user-settings
   ```

3. **Create proposal.md**
   ```markdown
   ## Why
   Users need to manage their profile settings.

   ## What Changes
   - Add profile settings page
   - Create settings API endpoints
   - Add avatar upload functionality

   ## Impact
   - Affected specs: user-settings (new)
   - Affected code: src/pages/, src/api/
   ```

4. **Create tasks.md**
   ```markdown
   ## 1. Backend
   - [ ] 1.1 Create profile settings API
   - [ ] 1.2 Add avatar upload endpoint

   ## 2. Frontend
   - [ ] 2.1 Create settings page component
   - [ ] 2.2 Add form validation

   ## 3. Testing
   - [ ] 3.1 Unit tests for API
   - [ ] 3.2 Integration tests
   ```

5. **Create spec delta** (`specs/user-settings/spec.md`)
   ```markdown
   ## ADDED Requirements

   ### Requirement: Profile Settings Management
   The system SHALL allow users to manage their profile settings.

   #### Scenario: Update display name
   - **WHEN** user submits new display name
   - **THEN** profile is updated

   #### Scenario: Upload avatar
   - **WHEN** user uploads an image
   - **THEN** avatar is saved and displayed
   ```

6. **Validate**
   ```bash
   openspec validate add-user-profile-settings --strict
   ```

7. **Request approval**

Output: `openspec/changes/add-user-profile-settings/`

### Step 3: Create Beads Issues

Run `/openspec-beads [change-id]` to break tasks into trackable issues:

```
/openspec-beads add-user-profile-settings
```

This creates:
- **Epic**: PROJ-124 (the change itself)
- **Subtasks**: PROJ-125, PROJ-126, ... (from tasks.md)
- **Dependencies**: Section ordering, parent-child links

Output: Epic with linked subtasks, ready for `beads_ready()`

### Step 4: Setup Development Branch

```bash
git checkout -b feature/PROJ-124-user-profile-settings
```

### Step 5: Create Test Stubs

Based on spec scenarios:

```typescript
// tests/user-profile-settings.test.ts

describe('UserProfileSettings', () => {
  // From spec: #### Scenario: Update display name
  it.todo('updates display name successfully');
  it.todo('rejects empty display name');

  // From spec: #### Scenario: Upload avatar
  it.todo('uploads avatar image');
  it.todo('rejects non-image files');
  it.todo('enforces max file size');
});
```

Run tests to confirm they fail (TDD red phase).

### Step 6: Ready Signal

```markdown
## Feature Setup Complete

| Item | Value |
|------|-------|
| **Change ID** | add-user-profile-settings |
| **Epic** | PROJ-124 |
| **Subtasks** | PROJ-125, PROJ-126, PROJ-127, ... |
| **Branch** | feature/PROJ-124-user-profile-settings |
| **Tests** | tests/user-profile-settings.test.ts |
| **Status** | 0 passing, 5 pending |

### Next Steps

1. **Review proposal**: Ensure requirements are complete
   ```bash
   openspec show add-user-profile-settings
   ```

2. **See ready tasks**: Check unblocked work
   ```bash
   beads_ready()
   ```

3. **Start implementation**: Begin TDD cycle
   ```
   /implement
   ```

4. **Or adjust spec first**: If changes needed
   ```bash
   edit openspec/changes/add-user-profile-settings/proposal.md
   openspec validate add-user-profile-settings --strict
   ```
```

## Example

```
/feature-init User authentication with OAuth providers
```

User provides:
- Priority: 1 (high)
- Key requirements:
  - Support Google, GitHub, Microsoft
  - Link multiple providers to one account
  - Graceful fallback if provider unavailable

**Output**: Complete setup ready for implementation.

<code_exploration>
Read and understand the existing codebase before proposing feature structure. Do not speculate about code you have not inspected. Thoroughly review existing patterns to ensure the new feature integrates well.
</code_exploration>
