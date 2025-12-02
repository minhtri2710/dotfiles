# Error Patterns

Searchable solutions for common errors. Search by error message fragment.

---

## TypeScript Errors

### TS2322: Type 'X' is not assignable to type 'Y'

**Search**: `not assignable to type`

**Causes**:
- Literal vs wider type mismatch
- Missing discriminant in union
- Optional vs required properties

**Fixes**:
```typescript
// Use satisfies for type checking with inference
const config = { type: "foo" } as const satisfies Config;

// Add discriminant to unions
type Result = { success: true; data: T } | { success: false; error: E };
```

---

### TS2339: Property does not exist on type

**Search**: `Property .* does not exist on type`

**Causes**:
- Typo in property name
- Union type not narrowed
- Optional property not checked

**Fixes**:
```typescript
// Narrow the union
if ("propertyName" in obj) {
  obj.propertyName;
}

// Use optional chaining
obj.maybeProp?.nested;
```

---

### TS2532: Object is possibly undefined

**Search**: `Object is possibly 'undefined'`

**Causes**:
- Optional property access
- Array `.find()` result
- Map `.get()` result

**Fixes**:
```typescript
// Null check
if (value !== undefined) { value.prop; }

// Optional chaining
value?.prop;

// Default value
const result = value ?? defaultValue;
```

---

## React/Next.js Errors

### Hydration Mismatch

**Search**: `Hydration failed|Text content does not match`

**Causes**:
- `Date.now()` or `Math.random()` in render
- Browser APIs during SSR
- Extensions injecting HTML

**Fixes**:
```typescript
const [mounted, setMounted] = useState(false);
useEffect(() => setMounted(true), []);
if (!mounted) return null;

// Or dynamic import
const Component = dynamic(() => import('./Component'), { ssr: false });
```

---

### "use client" / "use server" Issues

**Search**: `You're importing a component that needs|Cannot use .* in a Server Component`

**Causes**:
- Using hooks in Server Component
- Passing functions to Client Components

**Fixes**:
```typescript
// Add at TOP of file
"use client";

// Or split: ServerComponent.tsx + ClientWrapper.tsx
```

---

### Dynamic Server Usage

**Search**: `Dynamic server usage|couldn't be rendered statically`

**Causes**:
- Using `cookies()`, `headers()`
- `searchParams` in static page

**Fixes**:
```typescript
export const dynamic = "force-dynamic";
// or
export const revalidate = 3600;
```

---

## Build Errors

### Module Not Found

**Search**: `Module not found|Cannot find module`

**Causes**:
- Typo in import
- Missing dependency
- Case sensitivity (Linux)

**Fixes**:
```bash
pnpm list <package>
pnpm add <package>
# Check exact file path and case
```

---

### Circular Dependency

**Search**: `Circular dependency|Cannot access .* before initialization`

**Causes**:
- A imports B, B imports A
- Barrel files creating cycles

**Fixes**:
- Extract shared types to separate file
- Import directly, avoid barrel files
- Use `madge` to visualize

---

## Runtime Errors

### Cannot Read Property of Undefined

**Search**: `Cannot read propert .* of undefined`

**Causes**:
- Nested access without null check
- Array out of bounds
- Uninitialized object

**Fixes**:
```typescript
obj?.nested?.property;
arr[index] ?? defaultValue;
```

---

### Maximum Call Stack Exceeded

**Search**: `Maximum call stack size exceeded`

**Causes**:
- Infinite recursion
- Circular object serialization
- useEffect with bad deps

**Fixes**:
```typescript
// Add base case
if (depth > MAX_DEPTH) return;

// Check useEffect deps
const memoized = useMemo(() => value, [stableDep]);
```

---

## Adding New Patterns

When you fix a novel error:

```markdown
### <Error Name>

**Search**: `<regex-friendly error fragment>`

**Causes**:
- <cause 1>

**Fixes**:
```typescript
// <solution>
```
```
