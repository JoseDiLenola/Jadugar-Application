# Base Interfaces

## IBaseService

The `IBaseService` interface defines the core contract for all services in the Jadugar system.

### Methods

```typescript
interface IBaseService {
  initialize(config: unknown): Promise<void>;
  start(): Promise<void>;
  stop(): Promise<void>;
  getStatus(): Promise<ServiceStatus>;
  handleError(error: Error): void;
  dispose(): Promise<void>;
}
```

### Usage Example

```typescript
class MyService implements IBaseService {
  private config: ServiceConfig;
  private running: boolean = false;

  async initialize(config: ServiceConfig) {
    this.config = config;
    // Initialize resources
  }

  async start() {
    this.running = true;
    // Start processing
  }

  async stop() {
    this.running = false;
    // Stop processing
  }

  async getStatus(): Promise<ServiceStatus> {
    return {
      status: this.running ? 'running' : 'stopped',
      uptime: this.calculateUptime(),
      metrics: this.getMetrics()
    };
  }

  handleError(error: Error) {
    // Log error
    // Attempt recovery
  }

  async dispose() {
    await this.stop();
    // Clean up resources
  }
}
```

## IEntity

The `IEntity` interface provides a base contract for data entities with CRUD operations.

### Methods

```typescript
interface IEntity<T> {
  id: string;
  create(data: Partial<T>): Promise<T>;
  read(id: string): Promise<T | null>;
  update(id: string, data: Partial<T>): Promise<T>;
  delete(id: string): Promise<void>;
  validate(data: Partial<T>): Promise<ValidationResult>;
}
```

### Usage Example

```typescript
interface User {
  id: string;
  name: string;
  email: string;
}

class UserEntity implements IEntity<User> {
  id: string;

  constructor(id: string) {
    this.id = id;
  }

  async create(data: Partial<User>): Promise<User> {
    await this.validate(data);
    // Create user in database
    return { id: this.id, ...data } as User;
  }

  async read(id: string): Promise<User | null> {
    // Read user from database
    return null;
  }

  async update(id: string, data: Partial<User>): Promise<User> {
    await this.validate(data);
    // Update user in database
    return { id, ...data } as User;
  }

  async delete(id: string): Promise<void> {
    // Delete user from database
  }

  async validate(data: Partial<User>): Promise<ValidationResult> {
    // Validate user data
    return { valid: true };
  }
}
```

## IEventEmitter

The `IEventEmitter` interface provides asynchronous event handling capabilities.

### Methods

```typescript
interface IEventEmitter {
  on<T>(event: string, handler: (data: T) => Promise<void> | void): void;
  once<T>(event: string, handler: (data: T) => Promise<void> | void): void;
  off<T>(event: string, handler: (data: T) => Promise<void> | void): void;
  emit<T>(event: string, data: T): Promise<void>;
  removeAllListeners(event?: string): void;
  listenerCount(event: string): number;
}
```

### Usage Example

```typescript
class EventBus implements IEventEmitter {
  private handlers = new Map<string, Set<Function>>();

  on<T>(event: string, handler: (data: T) => void) {
    if (!this.handlers.has(event)) {
      this.handlers.set(event, new Set());
    }
    this.handlers.get(event)!.add(handler);
  }

  async emit<T>(event: string, data: T) {
    const handlers = this.handlers.get(event);
    if (handlers) {
      await Promise.all(
        Array.from(handlers).map(handler => handler(data))
      );
    }
  }

  // ... other implementations
}
```

## IPlugin

The `IPlugin` interface defines the contract for dynamically loaded plugins.

### Methods

```typescript
interface IPlugin {
  id: string;
  name: string;
  version: string;
  initialize(context: PluginContext): Promise<void>;
  start(): Promise<void>;
  stop(): Promise<void>;
  getConfigSchema(): Record<string, unknown>;
  validateConfig(config: unknown): Promise<ValidationResult>;
}
```

### Usage Example

```typescript
class LoggingPlugin implements IPlugin {
  id = 'logging-plugin';
  name = 'Logging Plugin';
  version = '1.0.0';

  async initialize(context: PluginContext) {
    // Set up logging configuration
  }

  async start() {
    // Start logging
  }

  async stop() {
    // Stop logging
  }

  getConfigSchema() {
    return {
      logLevel: {
        type: 'string',
        enum: ['debug', 'info', 'warn', 'error']
      },
      outputFile: {
        type: 'string'
      }
    };
  }

  async validateConfig(config: unknown): Promise<ValidationResult> {
    // Validate logging configuration
    return { valid: true };
  }
}
```

## Best Practices

1. **Error Handling**
   - Always implement proper error handling in service methods
   - Use typed errors for different failure scenarios
   - Include context in error messages

2. **Resource Management**
   - Clean up resources in dispose() method
   - Use try-finally blocks for critical sections
   - Implement proper shutdown sequences

3. **State Management**
   - Keep track of service state
   - Implement proper state transitions
   - Validate state before operations

4. **Configuration**
   - Validate configuration during initialization
   - Support runtime configuration updates
   - Use typed configuration objects

5. **Testing**
   - Write unit tests for all interface implementations
   - Test error conditions and edge cases
   - Use mocks for external dependencies
