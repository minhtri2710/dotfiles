# Testing Patterns

Best practices for writing tests.

---

## Test Structure (AAA Pattern)

```typescript
test("should return user when valid ID provided", () => {
  // Arrange - Set up test data
  const userId = "123";
  const expectedUser = { id: userId, name: "Joel" };
  mockDb.users.set(userId, expectedUser);

  // Act - Execute the code
  const result = getUser(userId);

  // Assert - Verify the outcome
  expect(result).toEqual(expectedUser);
});
```

---

## Test Naming

### Describe Behavior, Not Implementation

```typescript
// BAD: Implementation-focused
test("calls database query method", () => {});

// GOOD: Behavior-focused
test("returns user when valid ID provided", () => {});
test("throws NotFound when user does not exist", () => {});
test("returns empty array when no users match filter", () => {});
```

### Format: `should [behavior] when [condition]`

```typescript
test("should return null when user not found", () => {});
test("should throw ValidationError when email invalid", () => {});
test("should retry 3 times when network fails", () => {});
```

---

## Test Categories

### Unit Tests (Many, Fast)
- Test single functions/classes in isolation
- Mock external dependencies
- Run in milliseconds

```typescript
test("formatDate returns ISO string", () => {
  expect(formatDate(new Date("2024-01-01"))).toBe("2024-01-01");
});
```

### Integration Tests (Some)
- Test component interactions
- Use real dependencies where possible
- Test database, API calls

```typescript
test("createUser stores user in database", async () => {
  const user = await createUser({ name: "Joel" });
  const stored = await db.users.findById(user.id);
  expect(stored).toEqual(user);
});
```

### E2E Tests (Few, Slow)
- Test full user flows
- Use browser automation
- Only critical paths

```typescript
test("user can login and view dashboard", async () => {
  await page.goto("/login");
  await page.fill("[name=email]", "user@test.com");
  await page.fill("[name=password]", "password");
  await page.click("button[type=submit]");
  await expect(page).toHaveURL("/dashboard");
});
```

---

## What to Test

### Must Test
- Core business logic
- Public APIs
- Error handling
- Security-critical code

### Should Test
- Edge cases and boundaries
- Integration points
- Data transformations

### Can Skip
- Trivial getters/setters
- Framework code
- Third-party libraries

---

## Mocking

### Mock External Dependencies

```typescript
// Mock the module
jest.mock("./database");

// Setup mock implementation
const mockDb = database as jest.Mocked<typeof database>;
mockDb.query.mockResolvedValue([{ id: 1, name: "Test" }]);

// Assert mock was called
expect(mockDb.query).toHaveBeenCalledWith("SELECT * FROM users");
```

### Don't Mock What You Own

```typescript
// BAD: Mocking your own code
jest.mock("./userService");

// GOOD: Mock external dependencies only
jest.mock("./database"); // external
jest.mock("./httpClient"); // external
```

### Prefer Dependency Injection

```typescript
// BAD: Hard to test
function getUser(id: string) {
  return db.query(`SELECT * FROM users WHERE id = ?`, [id]);
}

// GOOD: Dependency injection
function getUser(id: string, db: Database) {
  return db.query(`SELECT * FROM users WHERE id = ?`, [id]);
}

// Test with mock
const mockDb = { query: jest.fn() };
getUser("123", mockDb);
```

---

## Assertions

### Be Specific

```typescript
// BAD: Too vague
expect(result).toBeTruthy();

// GOOD: Specific assertion
expect(result).toBe(true);
expect(result).toEqual({ id: "123", name: "Joel" });
```

### One Assertion Per Test (Usually)

```typescript
// BAD: Multiple unrelated assertions
test("user operations", () => {
  expect(createUser()).toBeDefined();
  expect(getUser("123")).toBeDefined();
  expect(deleteUser("123")).toBe(true);
});

// GOOD: Focused tests
test("createUser returns new user", () => {
  expect(createUser()).toBeDefined();
});

test("getUser returns existing user", () => {
  expect(getUser("123")).toBeDefined();
});
```

---

## Async Testing

### Use async/await

```typescript
// BAD: Callback style
test("fetches user", (done) => {
  getUser("123").then((user) => {
    expect(user.name).toBe("Joel");
    done();
  });
});

// GOOD: async/await
test("fetches user", async () => {
  const user = await getUser("123");
  expect(user.name).toBe("Joel");
});
```

### Test Rejections

```typescript
test("throws when user not found", async () => {
  await expect(getUser("invalid")).rejects.toThrow("Not found");
});
```

---

## Test Data

### Use Factories

```typescript
function createTestUser(overrides?: Partial<User>): User {
  return {
    id: "test-id",
    name: "Test User",
    email: "test@example.com",
    createdAt: new Date(),
    ...overrides,
  };
}

test("user with custom name", () => {
  const user = createTestUser({ name: "Joel" });
  expect(user.name).toBe("Joel");
});
```

### Use Meaningful Data

```typescript
// BAD: Generic data
const user = { id: "1", name: "test" };

// GOOD: Realistic data
const user = { id: "usr_123", name: "Joel Hooks", email: "joel@example.com" };
```

---

## Common Mistakes

### Don't Test Implementation Details

```typescript
// BAD: Testing internals
test("sets _isLoading to true", () => {
  expect(component._isLoading).toBe(true);
});

// GOOD: Test observable behavior
test("shows loading spinner while fetching", () => {
  expect(screen.getByRole("progressbar")).toBeVisible();
});
```

### Don't Ignore Flaky Tests

```typescript
// BAD: Skip and forget
test.skip("sometimes fails", () => {});

// GOOD: Fix or remove
// 1. Find the cause (timing, external dependency)
// 2. Fix it or remove if not valuable
```

### Don't Over-Mock

```typescript
// BAD: Mock everything
jest.mock("./a");
jest.mock("./b");
jest.mock("./c");
jest.mock("./d");
// What are we even testing?

// GOOD: Minimal mocks
jest.mock("./externalService"); // Only external deps
```

---

## Test Coverage

### Metrics

- **Line coverage** - % of lines executed
- **Branch coverage** - % of conditions tested
- **Function coverage** - % of functions called

### Targets

- 80% coverage is reasonable goal
- 100% coverage is often not worth it
- Focus on critical paths, not metrics

### Coverage ≠ Quality

```typescript
// 100% coverage, 0% value
test("calls function", () => {
  processData([1, 2, 3]);
  // No assertions!
});
```
