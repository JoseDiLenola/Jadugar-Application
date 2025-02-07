# @jadugar/core Server Implementation

This document specifies the core server implementation for the Jadugar project. The core server provides the foundational Express.js server setup with middleware, routing, and error handling.

## Server Architecture

### Core Server Class

```typescript
interface ServerOptions {
  port: number;
  host?: string;
  corsOptions?: CorsOptions;
  rateLimitOptions?: RateLimitOptions;
  compressionOptions?: CompressionOptions;
  securityOptions?: SecurityOptions;
  loggerOptions?: LoggerOptions;
}

class JadugarServer {
  constructor(options: ServerOptions);
  
  // Server Lifecycle
  async start(): Promise<void>;
  async stop(): Promise<void>;
  async reload(): Promise<void>;
  
  // Middleware Registration
  use(middleware: RequestHandler): this;
  useAt(path: string, middleware: RequestHandler): this;
  
  // Route Registration
  register(router: Router): this;
  registerAt(path: string, router: Router): this;
  
  // Error Handling
  setErrorHandler(handler: ErrorRequestHandler): this;
  
  // Health Check
  setHealthCheck(check: HealthCheck): this;
  
  // Metrics
  setMetricsCollector(collector: MetricsCollector): this;
  
  // Events
  on(event: ServerEvent, handler: EventHandler): this;
  off(event: ServerEvent, handler: EventHandler): this;
}
```

### Middleware Stack

```typescript
interface MiddlewareStack {
  pre: RequestHandler[];   // Pre-routing middleware
  route: RequestHandler[]; // Routing middleware
  post: RequestHandler[]; // Post-routing middleware
  error: ErrorRequestHandler[]; // Error handling middleware
}

class MiddlewareManager {
  add(phase: keyof MiddlewareStack, middleware: RequestHandler): void;
  remove(phase: keyof MiddlewareStack, middleware: RequestHandler): void;
  getStack(): MiddlewareStack;
  clear(phase?: keyof MiddlewareStack): void;
}
```

## Core Middleware

### Security Middleware

```typescript
interface SecurityOptions {
  helmet?: HelmetOptions;
  cors?: CorsOptions;
  csrf?: CSRFOptions;
  rateLimit?: RateLimitOptions;
}

interface CSRFOptions {
  enabled: boolean;
  secret?: string;
  cookie?: CookieOptions;
  ignoreMethods?: string[];
}

class SecurityMiddleware {
  constructor(options: SecurityOptions);
  
  // Middleware Functions
  helmet(): RequestHandler;
  cors(): RequestHandler;
  csrf(): RequestHandler;
  rateLimit(): RequestHandler;
  
  // Security Headers
  setSecurityHeaders(): RequestHandler;
  setContentSecurityPolicy(): RequestHandler;
  
  // Request Validation
  validateOrigin(): RequestHandler;
  validateMethod(): RequestHandler;
}
```

### Authentication Middleware

```typescript
interface AuthOptions {
  strategies: AuthStrategy[];
  session?: SessionOptions;
  jwt?: JWTOptions;
  oauth?: OAuthOptions;
}

interface AuthStrategy {
  name: string;
  authenticate(req: Request): Promise<User>;
  authorize(user: User, resource: string): Promise<boolean>;
}

class AuthMiddleware {
  constructor(options: AuthOptions);
  
  // Authentication
  authenticate(strategies?: string[]): RequestHandler;
  requireAuth(): RequestHandler;
  
  // Authorization
  authorize(resource: string): RequestHandler;
  requireRole(roles: string[]): RequestHandler;
  
  // Session Management
  session(): RequestHandler;
  logout(): RequestHandler;
}
```

### Logging Middleware

```typescript
interface LoggerOptions {
  level: LogLevel;
  format?: LogFormat;
  transports?: Transport[];
  metadata?: Record<string, unknown>;
}

interface LogEntry {
  timestamp: number;
  level: LogLevel;
  message: string;
  metadata: Record<string, unknown>;
  trace?: string;
}

class LoggerMiddleware {
  constructor(options: LoggerOptions);
  
  // Request Logging
  logRequest(): RequestHandler;
  logResponse(): RequestHandler;
  logError(): ErrorRequestHandler;
  
  // Performance Logging
  logPerformance(): RequestHandler;
  
  // Custom Logging
  createLogger(namespace: string): Logger;
}
```

### Compression Middleware

```typescript
interface CompressionOptions {
  level?: number;
  threshold?: number;
  filter?: (req: Request, res: Response) => boolean;
}

class CompressionMiddleware {
  constructor(options: CompressionOptions);
  
  compress(): RequestHandler;
  decompress(): RequestHandler;
}
```

## Error Handling

### Error Handler

```typescript
interface ErrorHandlerOptions {
  debug?: boolean;
  stack?: boolean;
  log?: boolean;
  formatter?: ErrorFormatter;
}

interface ErrorResponse {
  status: number;
  code: string;
  message: string;
  details?: unknown;
  stack?: string;
}

class ErrorHandler {
  constructor(options: ErrorHandlerOptions);
  
  // Error Handling
  handle(): ErrorRequestHandler;
  
  // Error Formatting
  format(error: Error): ErrorResponse;
  
  // Error Logging
  log(error: Error): void;
}
```

### Custom Errors

```typescript
class HttpError extends Error {
  constructor(
    status: number,
    message: string,
    code?: string,
    details?: unknown
  );
}

class ValidationError extends HttpError {
  constructor(message: string, details?: ValidationErrorDetails);
}

class AuthenticationError extends HttpError {
  constructor(message: string, details?: AuthErrorDetails);
}

class AuthorizationError extends HttpError {
  constructor(message: string, details?: AuthErrorDetails);
}
```

## Health Checks

### Health Check System

```typescript
interface HealthCheck {
  name: string;
  check(): Promise<HealthStatus>;
  timeout?: number;
  required?: boolean;
}

interface HealthStatus {
  status: 'up' | 'down' | 'degraded';
  details?: unknown;
  lastCheck: number;
  latency?: number;
}

class HealthChecker {
  constructor(checks: HealthCheck[]);
  
  // Health Checking
  check(): Promise<SystemHealth>;
  checkComponent(name: string): Promise<HealthStatus>;
  
  // Management
  addCheck(check: HealthCheck): void;
  removeCheck(name: string): void;
}
```

## Metrics Collection

### Metrics System

```typescript
interface MetricsOptions {
  prefix?: string;
  labels?: Record<string, string>;
  collectors?: MetricsCollector[];
}

interface MetricsCollector {
  collect(): Promise<Metric[]>;
  interval?: number;
}

class MetricsManager {
  constructor(options: MetricsOptions);
  
  // Metrics Collection
  collect(): Promise<Metric[]>;
  
  // Metric Types
  counter(name: string, help: string): Counter;
  gauge(name: string, help: string): Gauge;
  histogram(name: string, help: string): Histogram;
  
  // Export
  export(): string;
}
```

## Implementation Notes

1. Server Configuration
   - Environment-based configuration
   - Graceful shutdown handling
   - Proper signal handling
   - Configuration validation

2. Middleware Pipeline
   - Ordered middleware execution
   - Middleware dependency management
   - Performance optimization
   - Error propagation

3. Security Considerations
   - Input validation
   - Output sanitization
   - Rate limiting
   - CORS configuration
   - Security headers

4. Error Handling
   - Centralized error handling
   - Error categorization
   - Error logging
   - Client-safe error messages

5. Monitoring
   - Health check system
   - Metrics collection
   - Performance monitoring
   - Resource usage tracking

6. Testing Strategy
   - Unit tests for components
   - Integration tests for middleware
   - Load testing
   - Security testing

## Testing Requirements

1. Server Tests
   - Lifecycle management
   - Configuration loading
   - Middleware ordering
   - Route registration

2. Middleware Tests
   - Security middleware
   - Authentication flows
   - Logging functionality
   - Compression behavior

3. Error Handling Tests
   - Error propagation
   - Error formatting
   - Custom errors
   - Error logging

4. Health Check Tests
   - Individual checks
   - System health
   - Timeout handling
   - Status reporting

5. Metrics Tests
   - Collector functionality
   - Metric types
   - Export formatting
   - Label management

## Usage Examples

### Basic Server Setup

```typescript
const server = new JadugarServer({
  port: 3000,
  securityOptions: {
    helmet: { /* helmet options */ },
    cors: { /* cors options */ }
  },
  loggerOptions: {
    level: 'info',
    format: 'json'
  }
});

server.use(express.json());
server.register(apiRouter);
server.setErrorHandler(errorHandler);

await server.start();
```

### Authentication Setup

```typescript
const auth = new AuthMiddleware({
  strategies: [
    new JWTStrategy(/* jwt options */),
    new OAuth2Strategy(/* oauth options */)
  ],
  session: { /* session options */ }
});

server.use(auth.session());
server.useAt('/api', auth.requireAuth());
server.useAt('/admin', auth.requireRole(['admin']));
```

### Health Check Setup

```typescript
const healthChecker = new HealthChecker([
  {
    name: 'database',
    check: async () => {
      const status = await checkDatabase();
      return {
        status: status.connected ? 'up' : 'down',
        details: status,
        lastCheck: Date.now()
      };
    }
  }
]);

server.setHealthCheck(healthChecker);
```

### Metrics Setup

```typescript
const metrics = new MetricsManager({
  prefix: 'jadugar',
  labels: {
    environment: process.env.NODE_ENV
  }
});

const requestCounter = metrics.counter(
  'http_requests_total',
  'Total HTTP requests'
);

server.use((req, res, next) => {
  requestCounter.inc({ method: req.method, path: req.path });
  next();
});

server.setMetricsCollector(metrics);
```
