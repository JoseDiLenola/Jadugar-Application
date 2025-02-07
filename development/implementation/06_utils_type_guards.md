# Type Guards Utilities

## File: packages/utils/src/guards/index.ts

Generate a complete TypeScript file with the following specifications:

### Required Imports
```typescript
import {
    Resource,
    ResourceType,
    ResourceStatus,
    User,
    AuthToken,
    Permission,
    ApiRequest,
    ApiResponse,
    ApiError,
    HttpMethod,
    HttpStatus,
    Environment,
    LogLevel,
    DatabaseType,
    CacheType,
    LogCategory,
    TransportType
} from '@jadugar/types';
```

### Required Type Guard Functions

```typescript
// Resource Guards
export function isResource(value: unknown): value is Resource {
    if (!value || typeof value !== 'object') return false;
    const resource = value as Partial<Resource>;
    
    return (
        typeof resource.id === 'string' &&
        typeof resource.name === 'string' &&
        isResourceType(resource.type) &&
        isResourceStatus(resource.status) &&
        resource.createdAt instanceof Date &&
        resource.updatedAt instanceof Date &&
        typeof resource.metadata === 'object'
    );
}

export function isResourceType(value: unknown): value is ResourceType {
    if (typeof value !== 'string') return false;
    return ['compute', 'storage', 'network', 'database', 'custom'].includes(value);
}

export function isResourceStatus(value: unknown): value is ResourceStatus {
    if (typeof value !== 'string') return false;
    return ['pending', 'active', 'failed', 'deleting', 'deleted'].includes(value);
}

// User and Auth Guards
export function isUser(value: unknown): value is User {
    if (!value || typeof value !== 'object') return false;
    const user = value as Partial<User>;
    
    return (
        typeof user.id === 'string' &&
        typeof user.email === 'string' &&
        typeof user.username === 'string' &&
        Array.isArray(user.roles) &&
        Array.isArray(user.permissions) &&
        typeof user.metadata === 'object'
    );
}

export function isAuthToken(value: unknown): value is AuthToken {
    if (!value || typeof value !== 'object') return false;
    const token = value as Partial<AuthToken>;
    
    return (
        typeof token.token === 'string' &&
        ['access', 'refresh'].includes(token.type) &&
        token.expiresAt instanceof Date &&
        typeof token.userId === 'string' &&
        Array.isArray(token.scope)
    );
}

export function isPermission(value: unknown): value is Permission {
    if (!value || typeof value !== 'object') return false;
    const permission = value as Partial<Permission>;
    
    return (
        typeof permission.id === 'string' &&
        typeof permission.name === 'string' &&
        typeof permission.resource === 'string' &&
        ['create', 'read', 'update', 'delete', 'manage'].includes(permission.action)
    );
}

// API Guards
export function isApiRequest(value: unknown): value is ApiRequest {
    if (!value || typeof value !== 'object') return false;
    const request = value as Partial<ApiRequest>;
    
    return (
        typeof request.path === 'string' &&
        isHttpMethod(request.method) &&
        typeof request.headers === 'object'
    );
}

export function isApiResponse(value: unknown): value is ApiResponse {
    if (!value || typeof value !== 'object') return false;
    const response = value as Partial<ApiResponse>;
    
    return (
        isHttpStatus(response.status) &&
        typeof response.headers === 'object' &&
        'body' in response
    );
}

export function isApiError(value: unknown): value is ApiError {
    if (!value || typeof value !== 'object') return false;
    const error = value as Partial<ApiError>;
    
    return (
        typeof error.code === 'string' &&
        typeof error.message === 'string'
    );
}

export function isHttpMethod(value: unknown): value is HttpMethod {
    if (typeof value !== 'string') return false;
    return ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD', 'OPTIONS'].includes(value);
}

export function isHttpStatus(value: unknown): value is HttpStatus {
    if (typeof value !== 'number') return false;
    return [200, 201, 204, 400, 401, 403, 404, 409, 422, 500, 503].includes(value);
}

// Configuration Guards
export function isEnvironment(value: unknown): value is Environment {
    if (typeof value !== 'string') return false;
    return ['development', 'staging', 'production', 'test'].includes(value);
}

export function isLogLevel(value: unknown): value is LogLevel {
    if (typeof value !== 'string') return false;
    return ['debug', 'info', 'warn', 'error', 'fatal'].includes(value);
}

export function isDatabaseType(value: unknown): value is DatabaseType {
    if (typeof value !== 'string') return false;
    return ['postgres', 'mysql', 'mongodb'].includes(value);
}

export function isCacheType(value: unknown): value is CacheType {
    if (typeof value !== 'string') return false;
    return ['redis', 'memcached', 'memory'].includes(value);
}

// Logging Guards
export function isLogCategory(value: unknown): value is LogCategory {
    if (typeof value !== 'string') return false;
    return ['system', 'security', 'performance', 'business', 'audit'].includes(value);
}

export function isTransportType(value: unknown): value is TransportType {
    if (typeof value !== 'string') return false;
    return ['console', 'file', 'http', 'elasticsearch', 'custom'].includes(value);
}

// Generic Type Guards
export function isString(value: unknown): value is string {
    return typeof value === 'string';
}

export function isNumber(value: unknown): value is number {
    return typeof value === 'number' && !isNaN(value);
}

export function isBoolean(value: unknown): value is boolean {
    return typeof value === 'boolean';
}

export function isDate(value: unknown): value is Date {
    return value instanceof Date && !isNaN(value.getTime());
}

export function isArray<T>(value: unknown, itemGuard: (item: unknown) => item is T): value is T[] {
    return Array.isArray(value) && value.every(itemGuard);
}

export function isRecord<T>(
    value: unknown,
    valueGuard: (value: unknown) => value is T
): value is Record<string, T> {
    if (!value || typeof value !== 'object') return false;
    return Object.values(value).every(valueGuard);
}

export function isNonEmptyString(value: unknown): value is string {
    return typeof value === 'string' && value.trim().length > 0;
}

export function isPositiveNumber(value: unknown): value is number {
    return typeof value === 'number' && !isNaN(value) && value > 0;
}

export function isValidEmail(value: unknown): value is string {
    if (typeof value !== 'string') return false;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(value);
}

export function isValidUrl(value: unknown): value is string {
    if (typeof value !== 'string') return false;
    try {
        new URL(value);
        return true;
    } catch {
        return false;
    }
}
```

### Required Helper Functions

```typescript
// Composite Type Guards
export function isValidResourcePayload(value: unknown): value is Omit<Resource, 'id' | 'createdAt' | 'updatedAt'> {
    if (!value || typeof value !== 'object') return false;
    const payload = value as Partial<Resource>;
    
    return (
        typeof payload.name === 'string' &&
        isResourceType(payload.type) &&
        typeof payload.metadata === 'object'
    );
}

export function isValidAuthPayload(value: unknown): value is { email: string; password: string } {
    if (!value || typeof value !== 'object') return false;
    const payload = value as Partial<{ email: string; password: string }>;
    
    return (
        isValidEmail(payload.email) &&
        typeof payload.password === 'string' &&
        payload.password.length >= 8
    );
}

// Type Guard Combinators
export function and<T, U extends T>(
    guard1: (value: unknown) => value is T,
    guard2: (value: T) => value is U
): (value: unknown) => value is U {
    return (value: unknown): value is U => guard1(value) && guard2(value);
}

export function or<T, U>(
    guard1: (value: unknown) => value is T,
    guard2: (value: unknown) => value is U
): (value: unknown) => value is T | U {
    return (value: unknown): value is T | U => guard1(value) || guard2(value);
}

// Error Handling
export function assertType<T>(
    value: unknown,
    guard: (value: unknown) => value is T,
    message: string
): asserts value is T {
    if (!guard(value)) {
        throw new TypeError(message);
    }
}
```

### Additional Requirements
1. All functions must have JSDoc documentation
2. Include proper error messages
3. Add comprehensive type checking
4. Include null and undefined checks
5. Add proper validation logic
6. Include test cases in comments
7. Add performance optimizations
8. Include proper error handling
9. Add proper type assertions
10. Include proper date handling
