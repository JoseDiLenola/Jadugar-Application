# API Design Principles

## Overview
This document outlines the core principles and standards for designing APIs in the Jadugar project.

## Design Philosophy

### 1. RESTful Design
- Use proper HTTP methods
- Follow resource-based URLs
- Maintain statelessness
- Enable caching
- Support versioning

### 2. Consistency
- Uniform naming conventions
- Standard response formats
- Consistent error handling
- Common patterns across endpoints

### 3. Security First
- Authentication required
- Authorization checks
- Input validation
- Rate limiting
- Security headers

## API Standards

### 1. URL Structure
```
https://api.jadugar.com/v1/{resource}/{identifier}/{sub-resource}
```

Examples:
```
GET    /v1/users                 # List users
POST   /v1/users                 # Create user
GET    /v1/users/{id}           # Get user
PUT    /v1/users/{id}           # Update user
DELETE /v1/users/{id}           # Delete user
GET    /v1/users/{id}/projects  # List user's projects
```

### 2. HTTP Methods
- GET: Retrieve resource(s)
- POST: Create resource
- PUT: Update resource (full)
- PATCH: Update resource (partial)
- DELETE: Remove resource

### 3. Query Parameters
```
/v1/users?limit=10&offset=20    # Pagination
/v1/users?sort=name&order=desc  # Sorting
/v1/users?fields=id,name,email  # Field selection
/v1/users?status=active        # Filtering
```

### 4. Request Headers
```http
Authorization: Bearer {token}
Content-Type: application/json
Accept: application/json
Accept-Language: en-US
X-Request-ID: {uuid}
```

### 5. Response Format
```json
{
  "data": {
    "id": "123",
    "type": "user",
    "attributes": {
      "name": "John Doe",
      "email": "john@example.com"
    },
    "relationships": {
      "projects": {
        "data": [
          { "id": "456", "type": "project" }
        ]
      }
    }
  },
  "meta": {
    "timestamp": "2025-02-04T14:00:00Z",
    "version": "1.0"
  }
}
```

### 6. Error Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input provided",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email address"
      }
    ]
  },
  "meta": {
    "timestamp": "2025-02-04T14:00:00Z",
    "requestId": "abc-123"
  }
}
```

## Authentication & Authorization

### 1. Authentication
```http
# Bearer Token
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...

# API Key
X-API-Key: abcd1234...
```

### 2. Authorization
```json
{
  "permissions": [
    "users:read",
    "users:write",
    "projects:read"
  ],
  "roles": [
    "admin",
    "user"
  ]
}
```

## Rate Limiting

### 1. Headers
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1612483200
```

### 2. Response (429 Too Many Requests)
```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded",
    "details": {
      "retryAfter": 60
    }
  }
}
```

## Versioning

### 1. URL Versioning
```
/v1/users
/v2/users
```

### 2. Header Versioning
```http
Accept: application/vnd.jadugar.v1+json
```

## Pagination

### 1. Request
```
/v1/users?limit=10&offset=20
/v1/users?page=2&per_page=10
```

### 2. Response
```json
{
  "data": [...],
  "meta": {
    "total": 100,
    "limit": 10,
    "offset": 20,
    "hasMore": true
  },
  "links": {
    "self": "/v1/users?limit=10&offset=20",
    "next": "/v1/users?limit=10&offset=30",
    "prev": "/v1/users?limit=10&offset=10"
  }
}
```

## Best Practices

### 1. Performance
- Use pagination
- Enable caching
- Compress responses
- Minimize payload size
- Batch operations

### 2. Security
- Validate input
- Sanitize output
- Use HTTPS
- Implement rate limiting
- Set security headers

### 3. Documentation
- OpenAPI/Swagger
- Clear descriptions
- Example requests/responses
- Error scenarios
- Authentication details

## Testing

### 1. Test Categories
- Unit tests
- Integration tests
- Contract tests
- Performance tests
- Security tests

### 2. Test Coverage
- Happy path
- Error scenarios
- Edge cases
- Load conditions
- Security vulnerabilities

## Related Documentation
- [API Implementation Guide](../implementation/README.md)
- [API Security Guide](../security/README.md)
- [API Testing Guide](../testing/README.md)
