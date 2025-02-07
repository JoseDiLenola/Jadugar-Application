# API Types

## File: packages/types/src/api/index.ts

Generate a complete TypeScript file with the following specifications:

### Required Types and Interfaces

```typescript
// Base API Types
interface ApiRequest<T = any> {
    path: string;
    method: HttpMethod;
    headers: HttpHeaders;
    query?: QueryParams;
    body?: T;
    metadata?: RequestMetadata;
}

interface ApiResponse<T = any> {
    status: HttpStatus;
    headers: HttpHeaders;
    body: T;
    metadata?: ResponseMetadata;
}

interface ApiError {
    code: string;
    message: string;
    details?: Record<string, any>;
    stack?: string;
    cause?: Error;
}

// HTTP Types
type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH' | 'HEAD' | 'OPTIONS';
type HttpStatus = 200 | 201 | 204 | 400 | 401 | 403 | 404 | 409 | 422 | 500 | 503;
type HttpHeaders = Record<string, string | string[]>;
type QueryParams = Record<string, string | number | boolean | Array<string | number | boolean>>;

// Metadata Types
interface RequestMetadata {
    requestId: string;
    timestamp: Date;
    clientInfo: ClientInfo;
    traceId?: string;
}

interface ResponseMetadata {
    requestId: string;
    timestamp: Date;
    processingTime: number;
    serverInfo: ServerInfo;
}

interface ClientInfo {
    userAgent: string;
    ipAddress: string;
    locale?: string;
    timezone?: string;
}

interface ServerInfo {
    version: string;
    region: string;
    instance: string;
}

// Endpoint Types
interface ApiEndpoint<Req = any, Res = any> {
    path: string;
    method: HttpMethod;
    handler: (request: ApiRequest<Req>) => Promise<ApiResponse<Res>>;
    middleware?: ApiMiddleware[];
    validation?: RequestValidation<Req>;
    metadata?: EndpointMetadata;
}

interface ApiMiddleware {
    name: string;
    handler: (request: ApiRequest) => Promise<void>;
    priority?: number;
}

interface RequestValidation<T> {
    schema: ValidationSchema;
    validate: (data: T) => Promise<ValidationResult>;
}

interface ValidationSchema {
    type: string;
    properties: Record<string, ValidationRule>;
    required?: string[];
}

interface ValidationRule {
    type: string;
    format?: string;
    pattern?: string;
    minimum?: number;
    maximum?: number;
    minLength?: number;
    maxLength?: number;
    enum?: any[];
}

interface EndpointMetadata {
    description: string;
    tags: string[];
    deprecated?: boolean;
    rateLimit?: RateLimit;
}

interface RateLimit {
    requests: number;
    period: number;
    scope: 'user' | 'ip' | 'global';
}

// Pagination Types
interface PaginatedRequest {
    page: number;
    limit: number;
    sort?: SortParams;
    filter?: FilterParams;
}

interface PaginatedResponse<T> {
    data: T[];
    pagination: PaginationInfo;
}

interface PaginationInfo {
    total: number;
    page: number;
    limit: number;
    hasNext: boolean;
    hasPrevious: boolean;
}

type SortParams = Record<string, 'asc' | 'desc'>;
type FilterParams = Record<string, any>;
```

### Required Functions

```typescript
// Type Guards
function isApiRequest(value: any): value is ApiRequest;
function isApiResponse(value: any): value is ApiResponse;
function isApiError(value: any): value is ApiError;
function isHttpMethod(value: string): value is HttpMethod;
function isHttpStatus(value: number): value is HttpStatus;

// Validation Functions
function validateRequest<T>(request: ApiRequest<T>, validation: RequestValidation<T>): Promise<ValidationResult>;
function validateResponse<T>(response: ApiResponse<T>): Promise<ValidationResult>;
function validateEndpoint(endpoint: ApiEndpoint): ValidationResult;

// Utility Functions
function createApiRequest<T>(method: HttpMethod, path: string, options?: Partial<ApiRequest<T>>): ApiRequest<T>;
function createApiResponse<T>(status: HttpStatus, body: T, options?: Partial<ApiResponse<T>>): ApiResponse<T>;
function createApiError(code: string, message: string, details?: Record<string, any>): ApiError;
```

### Required Exports
```typescript
export {
    ApiRequest,
    ApiResponse,
    ApiError,
    HttpMethod,
    HttpStatus,
    HttpHeaders,
    QueryParams,
    RequestMetadata,
    ResponseMetadata,
    ClientInfo,
    ServerInfo,
    ApiEndpoint,
    ApiMiddleware,
    RequestValidation,
    ValidationSchema,
    ValidationRule,
    EndpointMetadata,
    RateLimit,
    PaginatedRequest,
    PaginatedResponse,
    PaginationInfo,
    SortParams,
    FilterParams,
    isApiRequest,
    isApiResponse,
    isApiError,
    isHttpMethod,
    isHttpStatus,
    validateRequest,
    validateResponse,
    validateEndpoint,
    createApiRequest,
    createApiResponse,
    createApiError,
};
```

### Additional Requirements
1. All interfaces must have JSDoc documentation
2. Include proper type assertions
3. Add proper validation logic
4. Include proper error handling
5. Add proper null checks
6. Include proper date handling
7. Add proper HTTP status code handling
8. Include rate limiting logic
9. Add pagination utilities
10. Include sorting and filtering utilities
