# @jadugar/security Specification

This document specifies the security implementation for the Jadugar framework. The security package provides comprehensive protection against common web vulnerabilities, including XSS, CSRF, and content security policy management.

## Security Architecture

### Security Manager

```typescript
interface SecurityOptions {
  xss?: XSSOptions;
  csrf?: CSRFOptions;
  csp?: CSPOptions;
  headers?: SecurityHeaders;
}

class SecurityManager {
  constructor(options?: SecurityOptions);
  
  // Security Operations
  sanitize(input: string): string;
  validate(input: string, rules: ValidationRule[]): boolean;
  
  // Protection
  protect(request: Request): void;
  verify(token: string): boolean;
}
```

### XSS Protection

```typescript
interface XSSOptions {
  mode?: 'strict' | 'loose';
  allowedTags?: string[];
  allowedAttributes?: string[];
}

class XSSProtection {
  constructor(options?: XSSOptions);
  
  // Sanitization
  sanitizeHTML(html: string): string;
  sanitizeURL(url: string): string;
  
  // Validation
  validateInput(input: string): boolean;
  validateOutput(output: string): boolean;
}
```

### CSRF Protection

```typescript
interface CSRFOptions {
  secret?: string;
  tokenLength?: number;
  cookieName?: string;
}

class CSRFProtection {
  constructor(options?: CSRFOptions);
  
  // Token Management
  generateToken(): string;
  validateToken(token: string): boolean;
  
  // Request Protection
  protect(request: Request): void;
  verify(request: Request): boolean;
}
```

## Implementation Notes

1. Security Design
   - Input sanitization
   - Output encoding
   - Token management
   - Header security

2. Performance
   - Validation caching
   - Token caching
   - Rule optimization
   - Memory usage

3. Features
   - XSS protection
   - CSRF protection
   - Content security
   - Access control

4. Integration
   - Request pipeline
   - Response pipeline
   - Error handling
   - Logging system

5. Best Practices
   - Input validation
   - Output encoding
   - Token rotation
   - Error handling

## Security Requirements

1. Input Sanitization
   - HTML sanitization
   - URL sanitization
   - Script removal
   - Style cleaning

2. XSS Prevention
   - Content encoding
   - Script validation
   - Style validation
   - URL validation

3. CSRF Protection
   - Token generation
   - Token validation
   - Cookie security
   - Header checks

4. Content Security
   - CSP headers
   - Frame options
   - CORS policy
   - Feature policy

## Usage Examples

### Basic Security

```typescript
// Create security manager
const security = new SecurityManager({
  xss: {
    mode: 'strict',
    allowedTags: ['p', 'br', 'strong']
  },
  csrf: {
    tokenLength: 32,
    cookieName: 'csrf-token'
  }
});

// Sanitize input
const userInput = '<script>alert("xss")</script><p>Hello</p>';
const safe = security.sanitize(userInput);
// Result: <p>Hello</p>

// Validate request
security.protect(request);
if (!security.verify(token)) {
  throw new SecurityError('Invalid security token');
}
```

### XSS Protection

```typescript
// Create XSS protection
const xss = new XSSProtection({
  mode: 'strict',
  allowedTags: ['p', 'br', 'strong'],
  allowedAttributes: ['class', 'id']
});

// Sanitize HTML
const html = xss.sanitizeHTML(userInput);

// Validate URL
const url = xss.sanitizeURL(userInput);

// Validate input/output
if (!xss.validateInput(formData)) {
  throw new ValidationError('Invalid input');
}

if (!xss.validateOutput(response)) {
  throw new SecurityError('Invalid output');
}
```

### CSRF Protection

```typescript
// Create CSRF protection
const csrf = new CSRFProtection({
  secret: process.env.CSRF_SECRET,
  tokenLength: 32
});

// Generate token
const token = csrf.generateToken();

// Protect request
app.use((req, res, next) => {
  csrf.protect(req);
  next();
});

// Verify request
app.post('/api', (req, res) => {
  if (!csrf.verify(req)) {
    res.status(403).send('Invalid CSRF token');
    return;
  }
  // Handle request
});
```

### Content Security

```typescript
// Create CSP manager
const csp = new CSPManager({
  defaultSrc: ["'self'"],
  scriptSrc: ["'self'", "'unsafe-inline'"],
  styleSrc: ["'self'", "'unsafe-inline'"],
  imgSrc: ["'self'", 'data:', 'https:'],
  connectSrc: ["'self'", 'https://api.example.com']
});

// Apply CSP
app.use((req, res, next) => {
  csp.apply(res);
  next();
});

// Update policy
csp.addSource('scriptSrc', 'https://trusted.com');
csp.removeSource('styleSrc', "'unsafe-inline'");

// Validate URL against policy
if (!csp.validateUrl('https://example.com/script.js')) {
  throw new SecurityError('URL not allowed by CSP');
}
```
