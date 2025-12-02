# TypeScript Patterns

Essential TypeScript idioms and best practices.

---

## Type Inference

### Prefer `satisfies` over Type Annotations

```typescript
// BAD: Loses literal types
const config: Config = { type: "admin" };
// config.type is string

// GOOD: Keeps literal, validates shape
const config = { type: "admin" } as const satisfies Config;
// config.type is "admin"
```

### Infer from `as const`

```typescript
const ROUTES = {
  home: "/",
  about: "/about",
  user: "/user/:id",
} as const;

type Route = (typeof ROUTES)[keyof typeof ROUTES];
// Route = "/" | "/about" | "/user/:id"
```

---

## Discriminated Unions

### Make Impossible States Impossible

```typescript
// BAD: Optional fields allow invalid states
type Response = {
  loading?: boolean;
  data?: Data;
  error?: Error;
};

// GOOD: Only valid states representable
type Response =
  | { status: "loading" }
  | { status: "success"; data: Data }
  | { status: "error"; error: Error };
```

### Exhaustive Matching

```typescript
function handleResponse(res: Response) {
  switch (res.status) {
    case "loading":
      return <Spinner />;
    case "success":
      return <Data data={res.data} />;
    case "error":
      return <Error error={res.error} />;
    default:
      // Compile error if case missed
      const _exhaustive: never = res;
      throw new Error(`Unhandled: ${_exhaustive}`);
  }
}
```

---

## Utility Types

### Common Patterns

```typescript
// Make all optional
Partial<User>

// Make all required
Required<User>

// Pick specific keys
Pick<User, "id" | "name">

// Omit specific keys
Omit<User, "password">

// Extract from union
Extract<Status, "active" | "pending">

// Exclude from union
Exclude<Status, "deleted">

// Record type
Record<string, User>

// Return type of function
ReturnType<typeof getUser>

// Parameters of function
Parameters<typeof getUser>
```

### Non-Nullable

```typescript
// Remove null/undefined
type Required = NonNullable<string | null | undefined>;
// Result: string
```

---

## Generics

### Constrain with `extends`

```typescript
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}
```

### Default Generic Parameters

```typescript
type Container<T = string> = { value: T };

const stringContainer: Container = { value: "hello" };
const numberContainer: Container<number> = { value: 42 };
```

### Infer in Conditionals

```typescript
type UnwrapPromise<T> = T extends Promise<infer U> ? U : T;

type Result = UnwrapPromise<Promise<string>>; // string
```

---

## Type Guards

### User-Defined Type Guards

```typescript
function isUser(value: unknown): value is User {
  return (
    typeof value === "object" &&
    value !== null &&
    "id" in value &&
    "name" in value
  );
}

if (isUser(data)) {
  console.log(data.name); // TypeScript knows it's User
}
```

### Assertion Functions

```typescript
function assertIsUser(value: unknown): asserts value is User {
  if (!isUser(value)) {
    throw new Error("Not a user");
  }
}

assertIsUser(data);
console.log(data.name); // TypeScript knows it's User after assertion
```

---

## Branded Types

### Prevent Type Confusion

```typescript
type UserId = string & { readonly __brand: "UserId" };
type PostId = string & { readonly __brand: "PostId" };

function getUser(id: UserId): User { ... }
function getPost(id: PostId): Post { ... }

const userId = "123" as UserId;
const postId = "456" as PostId;

getUser(userId); // OK
getUser(postId); // ERROR: PostId not assignable to UserId
```

---

## Function Overloads

### Multiple Signatures

```typescript
function parse(input: string): object;
function parse(input: string, format: "json"): object;
function parse(input: string, format: "yaml"): object;
function parse(input: string, format?: "json" | "yaml"): object {
  // implementation
}
```

---

## Strict Null Checks

### Handle `null`/`undefined` Explicitly

```typescript
// BAD: Assertion (unsafe)
const name = user!.name;

// GOOD: Check first
const name = user?.name ?? "Unknown";

// GOOD: Early return
if (!user) {
  return null;
}
const name = user.name;
```

---

## Template Literal Types

### Type-Safe Strings

```typescript
type EventName = `on${Capitalize<string>}`;
// Matches: "onClick", "onChange", etc.

type Route = `/${string}`;
// Matches: "/home", "/user/123", etc.

type Color = `#${string}`;
// Matches: "#fff", "#ff0000", etc.
```

---

## Common Pitfalls

### Don't Use `any`

```typescript
// BAD
function process(data: any) { ... }

// GOOD: Use unknown, then narrow
function process(data: unknown) {
  if (isValidData(data)) {
    // now typed
  }
}
```

### Don't Use `as` for Type Assertions

```typescript
// BAD: Unsafe assertion
const user = data as User;

// GOOD: Validate first
if (isUser(data)) {
  const user = data; // naturally typed
}
```

### Don't Overuse `Partial`

```typescript
// BAD: Everything optional
function updateUser(id: string, data: Partial<User>) { ... }

// GOOD: Be specific
function updateUser(id: string, data: Pick<User, "name" | "email">) { ... }
```
