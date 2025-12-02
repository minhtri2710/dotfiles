# Security Patterns

Essential security practices for application development.

---

## Input Validation

### Never Trust User Input

```typescript
// BAD: Direct use
const query = `SELECT * FROM users WHERE id = ${req.params.id}`;

// GOOD: Parameterized
const query = db.prepare("SELECT * FROM users WHERE id = ?");
const user = query.get(req.params.id);
```

### Validate and Sanitize

```typescript
import { z } from "zod";

const UserInput = z.object({
  email: z.string().email(),
  age: z.number().min(0).max(150),
  name: z.string().min(1).max(100).regex(/^[a-zA-Z\s]+$/),
});

function createUser(input: unknown) {
  const validated = UserInput.parse(input); // Throws if invalid
  // Now safe to use
}
```

---

## Authentication

### Password Handling

```typescript
// NEVER store plain text passwords
// NEVER log passwords
// NEVER send passwords in URLs

import { hash, verify } from "@node-rs/argon2";

// Hash with Argon2
const passwordHash = await hash(password, {
  memoryCost: 65536,
  timeCost: 3,
  parallelism: 4,
});

// Verify
const isValid = await verify(passwordHash, password);
```

### Session Management

```typescript
// Use secure session cookies
const sessionConfig = {
  httpOnly: true,      // No JS access
  secure: true,        // HTTPS only
  sameSite: "strict",  // CSRF protection
  maxAge: 3600000,     // 1 hour
};
```

---

## Authorization

### Check Permissions

```typescript
// BAD: No authorization check
app.get("/users/:id", (req, res) => {
  return db.getUser(req.params.id);
});

// GOOD: Verify access
app.get("/users/:id", (req, res) => {
  const user = db.getUser(req.params.id);
  if (user.id !== req.session.userId && !req.session.isAdmin) {
    throw new ForbiddenError("Access denied");
  }
  return user;
});
```

### Principle of Least Privilege

```typescript
// Give minimum required permissions
type Role = "viewer" | "editor" | "admin";

const permissions: Record<Role, string[]> = {
  viewer: ["read"],
  editor: ["read", "write"],
  admin: ["read", "write", "delete", "manage"],
};
```

---

## Secrets Management

### Never Commit Secrets

```bash
# .gitignore
.env
.env.local
*.pem
*.key
```

### Environment Variables

```typescript
// Load from environment
const apiKey = process.env.API_KEY;

if (!apiKey) {
  throw new Error("API_KEY not configured");
}

// Never log secrets
console.log("Connecting with key:", apiKey); // ❌
console.log("Connecting to API..."); // ✓
```

### Rotate Regularly

- API keys: Every 90 days
- Passwords: On compromise or employee departure
- Certificates: Before expiration

---

## Injection Prevention

### SQL Injection

```typescript
// BAD: String concatenation
const query = `SELECT * FROM users WHERE name = '${name}'`;

// GOOD: Parameterized queries
const query = db.prepare("SELECT * FROM users WHERE name = ?");
const users = query.all(name);
```

### Command Injection

```typescript
// BAD: Shell execution with user input
exec(`ls ${userPath}`);

// GOOD: Use arrays, avoid shell
execFile("ls", [userPath]);

// BETTER: Don't use shell at all
import { readdir } from "fs/promises";
const files = await readdir(userPath);
```

### XSS Prevention

```typescript
// BAD: Direct HTML insertion
element.innerHTML = userContent;

// GOOD: Text content (escaped)
element.textContent = userContent;

// If HTML needed, sanitize
import DOMPurify from "dompurify";
element.innerHTML = DOMPurify.sanitize(userContent);
```

---

## HTTPS / TLS

### Always Use HTTPS

```typescript
// Redirect HTTP to HTTPS
app.use((req, res, next) => {
  if (!req.secure && process.env.NODE_ENV === "production") {
    return res.redirect(`https://${req.headers.host}${req.url}`);
  }
  next();
});
```

### Security Headers

```typescript
import helmet from "helmet";

app.use(helmet());
// Sets: X-Content-Type-Options, X-Frame-Options,
// Content-Security-Policy, etc.
```

---

## Rate Limiting

### Prevent Abuse

```typescript
import rateLimit from "express-rate-limit";

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  message: "Too many requests",
});

app.use("/api/", limiter);

// Stricter for auth endpoints
const authLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 5, // 5 attempts
});

app.use("/api/login", authLimiter);
```

---

## Logging & Monitoring

### What to Log

```typescript
// DO log
logger.info("User logged in", { userId: user.id });
logger.warn("Failed login attempt", { email, ip: req.ip });
logger.error("Database connection failed", { error: err.message });

// DON'T log
logger.info("User logged in", { password }); // ❌
logger.info("API call", { apiKey }); // ❌
```

### Structured Logging

```typescript
const log = {
  timestamp: new Date().toISOString(),
  level: "warn",
  event: "auth.failed",
  userId: null,
  ip: req.ip,
  userAgent: req.headers["user-agent"],
  reason: "invalid_password",
};
```

---

## Common Vulnerabilities Checklist

- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (output encoding)
- [ ] CSRF prevented (tokens, SameSite cookies)
- [ ] Authentication secure (hashed passwords, secure sessions)
- [ ] Authorization checked (every endpoint)
- [ ] Secrets not in code (environment variables)
- [ ] HTTPS enforced
- [ ] Rate limiting enabled
- [ ] Security headers set
- [ ] Dependencies updated (no known vulnerabilities)
- [ ] Error messages don't leak info
- [ ] Logs don't contain secrets
