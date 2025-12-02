# React Patterns

Modern React patterns and best practices.

---

## Component Structure

### Functional Components Only

```tsx
// Always use function components with hooks
function UserProfile({ userId }: { userId: string }) {
  const { data: user, isLoading } = useUser(userId);
  
  if (isLoading) return <Skeleton />;
  if (!user) return <NotFound />;
  
  return <Profile user={user} />;
}
```

### Props Interface

```tsx
// Define props explicitly
interface ButtonProps {
  variant: "primary" | "secondary";
  size?: "sm" | "md" | "lg";
  disabled?: boolean;
  onClick: () => void;
  children: React.ReactNode;
}

function Button({ variant, size = "md", ...props }: ButtonProps) {
  return <button className={`btn-${variant} btn-${size}`} {...props} />;
}
```

---

## State Management

### useState for Local State

```tsx
function Counter() {
  const [count, setCount] = useState(0);
  
  // Functional updates for derived state
  const increment = () => setCount((c) => c + 1);
  
  return <button onClick={increment}>{count}</button>;
}
```

### useReducer for Complex State

```tsx
type State = { count: number; step: number };
type Action = 
  | { type: "increment" }
  | { type: "setStep"; step: number };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case "increment":
      return { ...state, count: state.count + state.step };
    case "setStep":
      return { ...state, step: action.step };
  }
}

function Counter() {
  const [state, dispatch] = useReducer(reducer, { count: 0, step: 1 });
  // ...
}
```

---

## Effects

### useEffect Best Practices

```tsx
// ✓ Specify all dependencies
useEffect(() => {
  fetchUser(userId);
}, [userId]);

// ✓ Cleanup subscriptions
useEffect(() => {
  const subscription = subscribe(userId);
  return () => subscription.unsubscribe();
}, [userId]);

// ✓ Avoid unnecessary effects
// BAD: Derived state in effect
useEffect(() => {
  setFullName(`${firstName} ${lastName}`);
}, [firstName, lastName]);

// GOOD: Calculate during render
const fullName = `${firstName} ${lastName}`;
```

### Data Fetching

```tsx
// Prefer data fetching libraries
function UserProfile({ userId }: { userId: string }) {
  // React Query / SWR / TanStack Query
  const { data, isLoading, error } = useQuery({
    queryKey: ["user", userId],
    queryFn: () => fetchUser(userId),
  });
  
  // Handle all states
  if (isLoading) return <Skeleton />;
  if (error) return <Error error={error} />;
  if (!data) return <NotFound />;
  
  return <Profile user={data} />;
}
```

---

## Custom Hooks

### Extract Reusable Logic

```tsx
// Custom hook for form field
function useField(initialValue: string) {
  const [value, setValue] = useState(initialValue);
  const [touched, setTouched] = useState(false);
  
  return {
    value,
    onChange: (e: ChangeEvent<HTMLInputElement>) => setValue(e.target.value),
    onBlur: () => setTouched(true),
    touched,
    reset: () => {
      setValue(initialValue);
      setTouched(false);
    },
  };
}

// Usage
function Form() {
  const email = useField("");
  const password = useField("");
  
  return (
    <form>
      <input {...email} />
      <input type="password" {...password} />
    </form>
  );
}
```

### Naming Convention

```tsx
// Always start with "use"
function useLocalStorage<T>(key: string, initialValue: T) { }
function useDebounce<T>(value: T, delay: number) { }
function useMediaQuery(query: string) { }
```

---

## Composition

### Children Pattern

```tsx
function Card({ children }: { children: React.ReactNode }) {
  return <div className="card">{children}</div>;
}

function CardHeader({ children }: { children: React.ReactNode }) {
  return <div className="card-header">{children}</div>;
}

// Usage
<Card>
  <CardHeader>Title</CardHeader>
  <p>Content</p>
</Card>
```

### Render Props

```tsx
interface MouseTrackerProps {
  render: (position: { x: number; y: number }) => React.ReactNode;
}

function MouseTracker({ render }: MouseTrackerProps) {
  const [position, setPosition] = useState({ x: 0, y: 0 });
  
  useEffect(() => {
    const handler = (e: MouseEvent) => setPosition({ x: e.clientX, y: e.clientY });
    window.addEventListener("mousemove", handler);
    return () => window.removeEventListener("mousemove", handler);
  }, []);
  
  return <>{render(position)}</>;
}

// Usage
<MouseTracker render={({ x, y }) => <div>Mouse: {x}, {y}</div>} />
```

---

## Performance

### Memoization

```tsx
// Memoize expensive calculations
const sortedItems = useMemo(
  () => items.sort((a, b) => a.name.localeCompare(b.name)),
  [items]
);

// Memoize callbacks passed to children
const handleClick = useCallback(() => {
  console.log("clicked", itemId);
}, [itemId]);

// Memoize components that receive same props
const MemoizedList = memo(function List({ items }: { items: Item[] }) {
  return items.map((item) => <Item key={item.id} item={item} />);
});
```

### Avoid Re-renders

```tsx
// BAD: New object every render
<Component style={{ color: "red" }} />

// GOOD: Stable reference
const style = useMemo(() => ({ color: "red" }), []);
<Component style={style} />

// BAD: Inline function
<Button onClick={() => handleClick(id)} />

// GOOD: Stable callback
const onClick = useCallback(() => handleClick(id), [id]);
<Button onClick={onClick} />
```

---

## Error Boundaries

### Catch Rendering Errors

```tsx
class ErrorBoundary extends Component<
  { children: ReactNode; fallback: ReactNode },
  { hasError: boolean }
> {
  state = { hasError: false };
  
  static getDerivedStateFromError() {
    return { hasError: true };
  }
  
  componentDidCatch(error: Error, info: ErrorInfo) {
    console.error("Error caught:", error, info);
  }
  
  render() {
    if (this.state.hasError) {
      return this.props.fallback;
    }
    return this.props.children;
  }
}

// Usage
<ErrorBoundary fallback={<ErrorPage />}>
  <App />
</ErrorBoundary>
```

---

## Forms

### Controlled Components

```tsx
function LoginForm() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  
  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    login({ email, password });
  };
  
  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />
      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
      />
      <button type="submit">Login</button>
    </form>
  );
}
```

### Form Libraries for Complex Forms

```tsx
// Use react-hook-form for complex forms
import { useForm } from "react-hook-form";

function ComplexForm() {
  const { register, handleSubmit, formState: { errors } } = useForm<FormData>();
  
  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register("email", { required: true })} />
      {errors.email && <span>Required</span>}
    </form>
  );
}
```

---

## Anti-Patterns to Avoid

### Don't Mutate State

```tsx
// BAD
state.items.push(newItem);
setState(state);

// GOOD
setState({ ...state, items: [...state.items, newItem] });
```

### Don't Use Index as Key

```tsx
// BAD
items.map((item, index) => <Item key={index} item={item} />);

// GOOD
items.map((item) => <Item key={item.id} item={item} />);
```

### Don't Overuse Context

```tsx
// BAD: Everything in one context
<AppContext.Provider value={{ user, theme, locale, cart, ... }}>

// GOOD: Split by domain
<UserProvider>
  <ThemeProvider>
    <LocaleProvider>
      <App />
    </LocaleProvider>
  </ThemeProvider>
</UserProvider>
```
