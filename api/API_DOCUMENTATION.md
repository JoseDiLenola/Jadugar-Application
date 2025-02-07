# Jadugar API Documentation

## API Overview

### Base URLs
```yaml
development: http://localhost:3000/api/v1
staging: https://api.staging.jadugar.com/v1
production: https://api.jadugar.com/v1
```

### Authentication
```bash
# Bearer Token
Authorization: Bearer <jwt_token>

# API Key (for service-to-service)
X-API-Key: <api_key>
```

## Build Observatory API

### Build Tracking
```typescript
// Create Build
POST /builds
{
  "projectId": string,
  "branch": string,
  "commit": string,
  "buildConfig": {
    "platform": string,
    "toolchain": string,
    "options": object
  }
}

// Get Build Status
GET /builds/{buildId}
Response: {
  "id": string,
  "status": "pending" | "running" | "success" | "failed",
  "startTime": string,
  "endTime": string,
  "metrics": {
    "duration": number,
    "cpuUsage": number,
    "memoryUsage": number
  }
}

// Update Build
PATCH /builds/{buildId}
{
  "status": string,
  "metrics": object
}

// List Builds
GET /builds?projectId={projectId}&status={status}
Response: {
  "builds": [
    {
      "id": string,
      "status": string,
      "startTime": string
    }
  ],
  "pagination": {
    "next": string,
    "prev": string
  }
}
```

### Build Analytics
```typescript
// Get Build Metrics
GET /builds/{buildId}/metrics
Response: {
  "buildTime": number,
  "resourceUsage": {
    "cpu": number,
    "memory": number,
    "disk": number
  },
  "dependencies": {
    "count": number,
    "updates": number
  }
}

// Get Build Trends
GET /projects/{projectId}/trends
Response: {
  "dailyBuilds": number,
  "successRate": number,
  "averageDuration": number,
  "resourceTrends": {
    "cpu": [number],
    "memory": [number]
  }
}
```

## Application Lighthouse API

### Application Monitoring
```typescript
// Register Application
POST /applications
{
  "name": string,
  "environment": string,
  "endpoints": [
    {
      "path": string,
      "method": string,
      "healthCheck": boolean
    }
  ]
}

// Get Application Status
GET /applications/{appId}
Response: {
  "id": string,
  "status": "healthy" | "degraded" | "down",
  "lastCheck": string,
  "metrics": {
    "uptime": number,
    "responseTime": number,
    "errorRate": number
  }
}

// Update Application
PATCH /applications/{appId}
{
  "endpoints": [
    {
      "path": string,
      "method": string
    }
  ]
}
```

### Performance Monitoring
```typescript
// Get Performance Metrics
GET /applications/{appId}/performance
Response: {
  "responseTime": {
    "p50": number,
    "p90": number,
    "p99": number
  },
  "throughput": number,
  "errorRate": number,
  "saturation": {
    "cpu": number,
    "memory": number
  }
}

// Get Historical Performance
GET /applications/{appId}/history
{
  "timeRange": string,
  "metrics": [string]
}
Response: {
  "timestamps": [string],
  "metrics": {
    "responseTime": [number],
    "throughput": [number],
    "errors": [number]
  }
}
```

### Alert Management
```typescript
// Create Alert Rule
POST /alerts
{
  "name": string,
  "condition": {
    "metric": string,
    "operator": string,
    "threshold": number,
    "duration": string
  },
  "actions": [
    {
      "type": string,
      "target": string
    }
  ]
}

// Get Alert Status
GET /alerts/{alertId}
Response: {
  "id": string,
  "status": "active" | "resolved",
  "lastTriggered": string,
  "incidents": [
    {
      "time": string,
      "value": number,
      "threshold": number
    }
  ]
}

// Update Alert Rule
PATCH /alerts/{alertId}
{
  "condition": {
    "threshold": number
  },
  "actions": [
    {
      "type": string,
      "target": string
    }
  ]
}
```

## Integration APIs

### Cross-Service Communication
```typescript
// Link Build to Application
POST /integrations/build-app
{
  "buildId": string,
  "applicationId": string,
  "deploymentInfo": {
    "version": string,
    "environment": string,
    "timestamp": string
  }
}

// Get Integrated Metrics
GET /integrations/metrics
{
  "buildId": string,
  "applicationId": string
}
Response: {
  "build": {
    "duration": number,
    "success": boolean
  },
  "application": {
    "performance": object,
    "health": string
  }
}
```

### Webhook Integration
```typescript
// Register Webhook
POST /webhooks
{
  "url": string,
  "events": [string],
  "secret": string
}

// Webhook Payload Example
{
  "event": string,
  "timestamp": string,
  "data": {
    "id": string,
    "type": string,
    "attributes": object
  }
}
```

## Error Responses

### Common Error Codes
```json
{
  "400": {
    "message": "Bad Request",
    "details": "Invalid input parameters"
  },
  "401": {
    "message": "Unauthorized",
    "details": "Invalid or missing authentication"
  },
  "403": {
    "message": "Forbidden",
    "details": "Insufficient permissions"
  },
  "404": {
    "message": "Not Found",
    "details": "Resource not found"
  },
  "429": {
    "message": "Too Many Requests",
    "details": "Rate limit exceeded"
  },
  "500": {
    "message": "Internal Server Error",
    "details": "Unexpected server error"
  }
}
```

## Rate Limiting

### Limits
```yaml
authenticated:
  - 1000 requests per minute per IP
  - 10000 requests per hour per token

unauthenticated:
  - 60 requests per minute per IP
  - 1000 requests per hour per IP

headers:
  - X-RateLimit-Limit
  - X-RateLimit-Remaining
  - X-RateLimit-Reset
```

## API Versioning
```yaml
versioning:
  strategy: URL path
  current: v1
  supported: [v1]
  deprecated: []
  sunset: []

headers:
  - X-API-Version
  - X-API-Deprecated
  - X-API-Sunset-Date
```
