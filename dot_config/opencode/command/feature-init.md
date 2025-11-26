---
description: Bootstrap new feature development. Creates spec, issue, branch, and test stubs. Ready for TDD implementation.
---

# Feature-Init Command

One command to set up everything for new feature development: spec, issue, branch, and test scaffolding.

## What It Creates

```
┌─────────────────────────────────────────────────────────────┐
│  /feature-init "User profile settings"                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Spec          specs/user-profile-settings.spec.md       │
│  2. Issue         PROJ-124 (feature, priority 2)            │
│  3. Branch        feature/PROJ-124-user-profile-settings    │
│  4. Test Stubs    tests/user-profile-settings.test.ts       │
│                                                             │
│  Status: Ready for /implement PROJ-124                      │
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

### Step 2: Create Specification

Run `/spec` workflow:
- Analyze context via GKG
- Draft OpenSpec with all sections
- Request user approval

Output: `specs/[feature-name].spec.md`

### Step 3: Create Beads Issue

```javascript
beads_create({
  title: "Implement User Profile Settings",
  description: `
Spec: specs/user-profile-settings.spec.md

## Requirements
- Users can update display name
- Users can change email (with verification)
- Users can upload avatar
- Settings saved with optimistic UI
`,
  type: "feature",
  priority: 2
});
```

Output: Issue `PROJ-124`

### Step 4: Setup Development Branch

```bash
git checkout -b feature/PROJ-124-user-profile-settings
```

### Step 5: Create Test Stubs

Based on spec's Verification section:

```typescript
// tests/user-profile-settings.test.ts

describe('UserProfileSettings', () => {
  // From spec: FR-1 - Update display name
  it.todo('updates display name successfully');
  it.todo('rejects empty display name');

  // From spec: FR-2 - Change email
  it.todo('initiates email change with verification');
  it.todo('rejects invalid email format');

  // From spec: FR-3 - Avatar upload
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
| **Issue** | PROJ-124 |
| **Spec** | specs/user-profile-settings.spec.md |
| **Branch** | feature/PROJ-124-user-profile-settings |
| **Tests** | tests/user-profile-settings.test.ts |
| **Status** | 0 passing, 7 pending |

### Next Steps

1. **Review spec**: Ensure requirements are complete
   ```
   cat specs/user-profile-settings.spec.md
   ```

2. **Start implementation**: Begin TDD cycle
   ```
   /implement PROJ-124
   ```

3. **Or adjust spec first**: If changes needed
   ```
   edit specs/user-profile-settings.spec.md
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
