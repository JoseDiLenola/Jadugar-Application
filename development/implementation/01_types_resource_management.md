# Resource Management Types

## File: packages/types/src/resource/index.ts

Generate a complete TypeScript file with the following specifications:

### Required Types and Interfaces

```typescript
// Resource Base Types
interface Resource {
    id: string;
    name: string;
    type: ResourceType;
    status: ResourceStatus;
    createdAt: Date;
    updatedAt: Date;
    metadata: ResourceMetadata;
}

interface ResourceMetadata {
    labels: Record<string, string>;
    annotations: Record<string, string>;
    owner: string;
    version: string;
}

// Resource Status Types
type ResourceStatus = 'pending' | 'active' | 'failed' | 'deleting' | 'deleted';
type ResourceType = 'compute' | 'storage' | 'network' | 'database' | 'custom';

// Resource Management Interfaces
interface ResourceManager {
    create(resource: Omit<Resource, 'id' | 'createdAt' | 'updatedAt'>): Promise<Resource>;
    update(id: string, updates: Partial<Resource>): Promise<Resource>;
    delete(id: string): Promise<void>;
    get(id: string): Promise<Resource>;
    list(filters?: ResourceFilters): Promise<Resource[]>;
}

interface ResourceFilters {
    type?: ResourceType;
    status?: ResourceStatus;
    owner?: string;
    labels?: Record<string, string>;
}

// Resource Events
interface ResourceEvent {
    id: string;
    resourceId: string;
    type: ResourceEventType;
    timestamp: Date;
    data: any;
}

type ResourceEventType = 'created' | 'updated' | 'deleted' | 'status_changed' | 'error';

// Resource Validation
interface ResourceValidator {
    validate(resource: Partial<Resource>): ValidationResult;
    validateType(type: string): type is ResourceType;
    validateStatus(status: string): status is ResourceStatus;
}

interface ValidationResult {
    valid: boolean;
    errors: ValidationError[];
}

interface ValidationError {
    field: string;
    message: string;
    code: string;
}
```

### Required Functions

```typescript
// Type Guards
function isResource(value: any): value is Resource;
function isResourceType(value: string): value is ResourceType;
function isResourceStatus(value: string): value is ResourceStatus;

// Validation Functions
function validateResource(resource: Partial<Resource>): ValidationResult;
function validateResourceType(type: string): boolean;
function validateResourceStatus(status: string): boolean;

// Utility Functions
function createResource(data: Omit<Resource, 'id' | 'createdAt' | 'updatedAt'>): Resource;
function updateResource(original: Resource, updates: Partial<Resource>): Resource;
```

### Required Exports
```typescript
export {
    Resource,
    ResourceMetadata,
    ResourceType,
    ResourceStatus,
    ResourceManager,
    ResourceFilters,
    ResourceEvent,
    ResourceEventType,
    ResourceValidator,
    ValidationResult,
    ValidationError,
    isResource,
    isResourceType,
    isResourceStatus,
    validateResource,
    validateResourceType,
    validateResourceStatus,
    createResource,
    updateResource,
};
```

### Additional Requirements
1. All interfaces must be properly documented with JSDoc comments
2. Include proper TypeScript type assertions
3. Implement strict type checking
4. Include proper error handling
5. Add proper null checks
6. Include proper date handling
7. Add proper validation logic
