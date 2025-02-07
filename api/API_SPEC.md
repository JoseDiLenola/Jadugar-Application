# API Specifications

## Overview

Jadugar's API follows REST principles and uses JSON for request/response bodies. All endpoints are versioned and require authentication unless specified otherwise.

## Base URL
```
http://localhost:4000/api/v1
```

## Authentication

### Headers
```
Authorization: Bearer <token>
```

### Endpoints

#### POST /auth/login
Login with credentials
```typescript
Request:
{
  email: string
  password: string
}

Response:
{
  token: string
  user: {
    id: string
    email: string
    name: string
    role: string
  }
}
```

#### POST /auth/register
Register new user
```typescript
Request:
{
  email: string
  password: string
  name: string
}

Response:
{
  token: string
  user: {
    id: string
    email: string
    name: string
    role: string
  }
}
```

## Progress Tracking

### Milestones

#### GET /milestones
Get all milestones
```typescript
Response:
{
  milestones: Array<{
    id: string
    title: string
    description: string
    startDate: string
    endDate: string
    status: 'NOT_STARTED' | 'IN_PROGRESS' | 'COMPLETED'
    progress: number
  }>
}
```

#### POST /milestones
Create new milestone
```typescript
Request:
{
  title: string
  description: string
  startDate: string
  endDate: string
}

Response:
{
  id: string
  title: string
  description: string
  startDate: string
  endDate: string
  status: 'NOT_STARTED'
  progress: 0
}
```

### Tasks

#### GET /tasks
Get all tasks
```typescript
Response:
{
  tasks: Array<{
    id: string
    title: string
    description: string
    status: 'NOT_STARTED' | 'IN_PROGRESS' | 'BLOCKED' | 'COMPLETED'
    priority: 'LOW' | 'MEDIUM' | 'HIGH'
    assignee: string
    dueDate: string
    milestoneId: string
  }>
}
```

#### POST /tasks
Create new task
```typescript
Request:
{
  title: string
  description: string
  priority: 'LOW' | 'MEDIUM' | 'HIGH'
  assignee: string
  dueDate: string
  milestoneId: string
}

Response:
{
  id: string
  title: string
  description: string
  status: 'NOT_STARTED'
  priority: 'LOW' | 'MEDIUM' | 'HIGH'
  assignee: string
  dueDate: string
  milestoneId: string
}
```

## Service Registry

### Services

#### GET /services
Get all registered services
```typescript
Response:
{
  services: Array<{
    id: string
    name: string
    url: string
    status: 'HEALTHY' | 'UNHEALTHY'
    lastCheck: string
  }>
}
```

#### POST /services/register
Register new service
```typescript
Request:
{
  name: string
  url: string
  healthCheck: string
}

Response:
{
  id: string
  name: string
  url: string
  status: 'HEALTHY'
  lastCheck: string
}
```

## Configuration

### GET /config
Get configuration
```typescript
Response:
{
  config: {
    [key: string]: any
  }
}
```

### POST /config
Update configuration
```typescript
Request:
{
  key: string
  value: any
}

Response:
{
  key: string
  value: any
}
```

## Webhooks

### POST /webhooks
Register webhook
```typescript
Request:
{
  url: string
  events: string[]
}

Response:
{
  id: string
  url: string
  events: string[]
}
```

## Error Responses

### 400 Bad Request
```typescript
{
  error: {
    code: 'BAD_REQUEST'
    message: string
  }
}
```

### 401 Unauthorized
```typescript
{
  error: {
    code: 'UNAUTHORIZED'
    message: string
  }
}
```

### 403 Forbidden
```typescript
{
  error: {
    code: 'FORBIDDEN'
    message: string
  }
}
```

### 404 Not Found
```typescript
{
  error: {
    code: 'NOT_FOUND'
    message: string
  }
}
```

### 500 Internal Server Error
```typescript
{
  error: {
    code: 'INTERNAL_ERROR'
    message: string
  }
}
```

## Rate Limiting

- 100 requests per minute per IP
- 1000 requests per hour per API key
- Headers:
  - X-RateLimit-Limit
  - X-RateLimit-Remaining
  - X-RateLimit-Reset

## Pagination

### Request
```
GET /endpoint?page=1&limit=10
```

### Response Headers
```
X-Total-Count: 100
X-Total-Pages: 10
```

### Response Body
```typescript
{
  data: T[]
  pagination: {
    page: number
    limit: number
    total: number
    pages: number
  }
}
```

## Versioning

- API versions in URL: /api/v1
- Breaking changes increment major version
- New endpoints can be added in current version
- Old versions supported for 6 months
