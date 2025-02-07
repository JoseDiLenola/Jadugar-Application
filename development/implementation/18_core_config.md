# @jadugar/core Configuration Layer

This document specifies the configuration management layer implementation for the Jadugar project. The configuration layer provides comprehensive configuration management, validation, and dynamic updates.

## Configuration Architecture

### Config Manager

```typescript
interface ConfigOptions {
  sources?: ConfigSource[];
  validators?: ConfigValidator[];
  cache?: CacheOptions;
  watch?: WatchOptions;
}

class ConfigManager {
  constructor(options: ConfigOptions);
  
  // Config Operations
  async load(): Promise<void>;
  async get<T>(key: string): Promise<T>;
  async set<T>(key: string, value: T): Promise<void>;
  async delete(key: string): Promise<void>;
  
  // Source Management
  addSource(source: ConfigSource): void;
  removeSource(name: string): void;
  
  // Validation
  validate(): Promise<ValidationResult>;
  addValidator(validator: ConfigValidator): void;
}
```

## Configuration Sources

### Source Interface

```typescript
interface ConfigSource {
  name: string;
  priority: number;
  
  // Source Operations
  load(): Promise<ConfigData>;
  watch(): Promise<void>;
  unwatch(): Promise<void>;
  
  // Source Management
  isAvailable(): boolean;
  getMetadata(): SourceMetadata;
}
```

### Source Implementations

```typescript
class EnvironmentSource implements ConfigSource {
  constructor(options?: EnvSourceOptions);
  
  // Implementation
  async load(): Promise<ConfigData> {
    // Load from environment variables
  }
  
  async watch(): Promise<void> {
    // Watch for env changes
  }
}

class FileSource implements ConfigSource {
  constructor(options: FileSourceOptions);
  
  // Implementation
  async load(): Promise<ConfigData> {
    // Load from config file
  }
  
  async watch(): Promise<void> {
    // Watch for file changes
  }
}

class RemoteSource implements ConfigSource {
  constructor(options: RemoteSourceOptions);
  
  // Implementation
  async load(): Promise<ConfigData> {
    // Load from remote service
  }
  
  async watch(): Promise<void> {
    // Watch for remote changes
  }
}
```

## Configuration Validation

### Validator Interface

```typescript
interface ConfigValidator {
  name: string;
  schema?: ValidationSchema;
  
  // Validation Operations
  validate(config: ConfigData): ValidationResult;
  validateKey(key: string, value: any): ValidationResult;
  
  // Schema Management
  addSchema(schema: ValidationSchema): void;
  removeSchema(name: string): void;
}
```

### Validator Implementations

```typescript
class SchemaValidator implements ConfigValidator {
  constructor(options?: SchemaValidatorOptions);
  
  // Implementation
  validate(config: ConfigData): ValidationResult {
    // Validate against schema
  }
}

class TypeValidator implements ConfigValidator {
  constructor(options?: TypeValidatorOptions);
  
  // Implementation
  validate(config: ConfigData): ValidationResult {
    // Validate types
  }
}

class CustomValidator implements ConfigValidator {
  constructor(options: CustomValidatorOptions);
  
  // Implementation
  validate(config: ConfigData): ValidationResult {
    // Custom validation logic
  }
}
```

## Configuration Storage

### Storage Interface

```typescript
interface ConfigStorage {
  // Storage Operations
  read(): Promise<ConfigData>;
  write(data: ConfigData): Promise<void>;
  clear(): Promise<void>;
  
  // Key Operations
  getKey(key: string): Promise<any>;
  setKey(key: string, value: any): Promise<void>;
  deleteKey(key: string): Promise<void>;
}
```

### Storage Implementations

```typescript
class MemoryStorage implements ConfigStorage {
  constructor(options?: MemoryStorageOptions);
  // Implementation of ConfigStorage interface
}

class FileStorage implements ConfigStorage {
  constructor(options: FileStorageOptions);
  // Implementation of ConfigStorage interface
}

class RedisStorage implements ConfigStorage {
  constructor(options: RedisStorageOptions);
  // Implementation of ConfigStorage interface
}
```

## Configuration Watching

### Watch System

```typescript
interface WatchOptions {
  interval?: number;
  sources?: string[];
  immediate?: boolean;
}

class ConfigWatcher {
  constructor(options: WatchOptions);
  
  // Watch Operations
  start(): Promise<void>;
  stop(): Promise<void>;
  refresh(): Promise<void>;
  
  // Event Handling
  onUpdate(handler: UpdateHandler): void;
  onError(handler: ErrorHandler): void;
}
```

### Change Detection

```typescript
interface ChangeDetector {
  // Detection Operations
  detect(oldConfig: ConfigData, newConfig: ConfigData): ConfigChanges;
  compare(oldValue: any, newValue: any): boolean;
  
  // Change Management
  trackChange(change: ConfigChange): void;
  getChanges(): ConfigChanges;
}

class ConfigChangeDetector implements ChangeDetector {
  constructor(options?: DetectorOptions);
  // Implementation of ChangeDetector interface
}
```

## Secret Management

### Secret Manager

```typescript
interface SecretOptions {
  provider?: SecretProvider;
  encryption?: EncryptionOptions;
  cache?: CacheOptions;
}

class SecretManager {
  constructor(options: SecretOptions);
  
  // Secret Operations
  async getSecret(name: string): Promise<Secret>;
  async setSecret(name: string, value: string): Promise<void>;
  async deleteSecret(name: string): Promise<void>;
  
  // Provider Management
  setProvider(provider: SecretProvider): void;
  getProvider(): SecretProvider;
}
```

### Secret Providers

```typescript
interface SecretProvider {
  name: string;
  
  // Provider Operations
  get(name: string): Promise<Secret>;
  set(name: string, value: string): Promise<void>;
  delete(name: string): Promise<void>;
  
  // Provider Management
  isAvailable(): boolean;
  getMetadata(): ProviderMetadata;
}

class VaultProvider implements SecretProvider {
  constructor(options: VaultOptions);
  // Implementation of SecretProvider interface
}

class AWSSecretsProvider implements SecretProvider {
  constructor(options: AWSOptions);
  // Implementation of SecretProvider interface
}
```

## Implementation Notes

1. Configuration
   - Source priority
   - Validation rules
   - Watch settings
   - Secret handling

2. Performance
   - Caching strategy
   - Update batching
   - Change detection
   - Resource usage

3. Reliability
   - Source failover
   - Validation recovery
   - Error handling
   - Data consistency

4. Security
   - Secret encryption
   - Access control
   - Audit logging
   - Secure storage

5. Integration
   - Environment variables
   - Configuration files
   - Remote services
   - Secret stores

## Testing Requirements

1. Source Tests
   - Loading behavior
   - Priority handling
   - Watch functionality
   - Error scenarios

2. Validation Tests
   - Schema validation
   - Type checking
   - Custom rules
   - Error handling

3. Storage Tests
   - Read/write operations
   - Concurrent access
   - Data persistence
   - Error recovery

4. Integration Tests
   - Multiple sources
   - Dynamic updates
   - Secret management
   - Cross-component impact

## Usage Examples

### Basic Configuration

```typescript
const configManager = new ConfigManager({
  sources: [
    new EnvironmentSource(),
    new FileSource({
      path: '/etc/config/app.yaml'
    }),
    new RemoteSource({
      url: 'https://config.example.com'
    })
  ]
});

// Load configuration
await configManager.load();

// Get configuration value
const serverPort = await configManager.get<number>('server.port');

// Set configuration value
await configManager.set('server.host', 'localhost');
```

### Configuration Validation

```typescript
const validator = new SchemaValidator({
  schema: {
    'server.port': {
      type: 'number',
      minimum: 1024,
      maximum: 65535
    },
    'database.url': {
      type: 'string',
      format: 'uri'
    }
  }
});

configManager.addValidator(validator);

// Validate configuration
const result = await configManager.validate();
if (!result.valid) {
  console.error('Configuration errors:', result.errors);
}
```

### Secret Management

```typescript
const secretManager = new SecretManager({
  provider: new VaultProvider({
    url: 'https://vault.example.com',
    token: process.env.VAULT_TOKEN
  })
});

// Get secret
const dbPassword = await secretManager.getSecret('database.password');

// Set secret
await secretManager.setSecret(
  'api.key',
  'secret-api-key-value'
);

// Delete secret
await secretManager.deleteSecret('old.secret');
```

### Configuration Watching

```typescript
const watcher = new ConfigWatcher({
  interval: 30000, // 30 seconds
  sources: ['file', 'remote']
});

// Handle updates
watcher.onUpdate((changes) => {
  console.log('Configuration changed:', changes);
});

// Handle errors
watcher.onError((error) => {
  console.error('Watch error:', error);
});

// Start watching
await watcher.start();
```
