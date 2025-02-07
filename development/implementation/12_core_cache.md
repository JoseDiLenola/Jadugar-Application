# @jadugar/core Cache Layer

This document specifies the caching layer implementation for the Jadugar project. The caching layer provides a flexible, high-performance caching system with support for multiple cache stores and strategies.

## Cache Architecture

### Cache Manager

```typescript
interface CacheOptions {
  store: 'redis' | 'memcached' | 'memory';
  prefix?: string;
  ttl?: number;
  serializer?: Serializer;
  compression?: CompressionOptions;
  cluster?: ClusterOptions;
}

class CacheManager {
  constructor(options: CacheOptions);
  
  // Cache Operations
  async get<T>(key: string): Promise<T | null>;
  async set<T>(
    key: string,
    value: T,
    options?: SetOptions
  ): Promise<void>;
  async delete(key: string): Promise<void>;
  async clear(): Promise<void>;
  
  // Bulk Operations
  async getMany<T>(keys: string[]): Promise<(T | null)[]>;
  async setMany(items: CacheItem[]): Promise<void>;
  async deleteMany(keys: string[]): Promise<void>;
  
  // Cache Management
  async flush(): Promise<void>;
  async healthCheck(): Promise<HealthStatus>;
  
  // Events
  on(event: CacheEvent, handler: EventHandler): this;
  off(event: CacheEvent, handler: EventHandler): this;
}
```

### Cache Stores

```typescript
interface CacheStore {
  // Basic Operations
  get<T>(key: string): Promise<T | null>;
  set<T>(key: string, value: T, ttl?: number): Promise<void>;
  delete(key: string): Promise<void>;
  clear(): Promise<void>;
  
  // Store Management
  connect(): Promise<void>;
  disconnect(): Promise<void>;
  isConnected(): boolean;
}

class RedisStore implements CacheStore {
  constructor(options: RedisOptions);
  // Implementation of CacheStore interface
}

class MemcachedStore implements CacheStore {
  constructor(options: MemcachedOptions);
  // Implementation of CacheStore interface
}

class MemoryStore implements CacheStore {
  constructor(options: MemoryOptions);
  // Implementation of CacheStore interface
}
```

## Cache Strategies

### Strategy Interface

```typescript
interface CacheStrategy {
  get<T>(key: string): Promise<T | null>;
  set<T>(key: string, value: T, options?: SetOptions): Promise<void>;
  invalidate(key: string): Promise<void>;
}

interface SetOptions {
  ttl?: number;
  tags?: string[];
  dependency?: CacheDependency;
}
```

### Caching Strategies

```typescript
class ReadThroughStrategy implements CacheStrategy {
  constructor(
    store: CacheStore,
    loader: DataLoader
  );
  
  async get<T>(key: string): Promise<T | null>;
  async set<T>(
    key: string,
    value: T,
    options?: SetOptions
  ): Promise<void>;
}

class WriteThroughStrategy implements CacheStrategy {
  constructor(
    store: CacheStore,
    writer: DataWriter
  );
  
  async set<T>(
    key: string,
    value: T,
    options?: SetOptions
  ): Promise<void>;
}

class WriteBackStrategy implements CacheStrategy {
  constructor(
    store: CacheStore,
    writer: DataWriter,
    options?: WriteBackOptions
  );
  
  async set<T>(
    key: string,
    value: T,
    options?: SetOptions
  ): Promise<void>;
  
  async flush(): Promise<void>;
}
```

## Cache Tags and Dependencies

### Tag Management

```typescript
interface TaggedCache {
  tags(tags: string[]): CacheStore;
  tagSet(key: string, tags: string[]): Promise<void>;
  invalidateTag(tag: string): Promise<void>;
  invalidateTags(tags: string[]): Promise<void>;
}

class TagManager {
  constructor(store: CacheStore);
  
  // Tag Operations
  async tag(key: string, tags: string[]): Promise<void>;
  async untag(key: string, tags: string[]): Promise<void>;
  async getKeysByTag(tag: string): Promise<string[]>;
  async getTagsByKey(key: string): Promise<string[]>;
  
  // Tag Invalidation
  async invalidateTag(tag: string): Promise<void>;
  async invalidateTags(tags: string[]): Promise<void>;
}
```

### Cache Dependencies

```typescript
interface CacheDependency {
  isValid(): Promise<boolean>;
  invalidate(): Promise<void>;
}

class FileDependency implements CacheDependency {
  constructor(filePath: string);
  
  async isValid(): Promise<boolean>;
  async invalidate(): Promise<void>;
}

class DatabaseDependency implements CacheDependency {
  constructor(query: string, params?: unknown[]);
  
  async isValid(): Promise<boolean>;
  async invalidate(): Promise<void>;
}

class CompositeDependency implements CacheDependency {
  constructor(dependencies: CacheDependency[]);
  
  async isValid(): Promise<boolean>;
  async invalidate(): Promise<void>;
}
```

## Cache Patterns

### Cache-Aside Pattern

```typescript
class CacheAside<T> {
  constructor(
    cache: CacheStore,
    loader: DataLoader<T>
  );
  
  async get(key: string): Promise<T>;
  async set(key: string, value: T): Promise<void>;
  async invalidate(key: string): Promise<void>;
}
```

### Cache Decorators

```typescript
function Cached(options?: CacheOptions) {
  return function (
    target: any,
    propertyKey: string,
    descriptor: PropertyDescriptor
  ) {
    // Implementation
  };
}

function InvalidateCache(keys: string[]) {
  return function (
    target: any,
    propertyKey: string,
    descriptor: PropertyDescriptor
  ) {
    // Implementation
  };
}
```

## Serialization and Compression

### Serializers

```typescript
interface Serializer {
  serialize(value: unknown): string;
  deserialize<T>(value: string): T;
}

class JSONSerializer implements Serializer {
  serialize(value: unknown): string;
  deserialize<T>(value: string): T;
}

class MessagePackSerializer implements Serializer {
  serialize(value: unknown): string;
  deserialize<T>(value: string): T;
}
```

### Compression

```typescript
interface CompressionOptions {
  algorithm: 'gzip' | 'deflate' | 'brotli';
  threshold?: number;
  level?: number;
}

class Compressor {
  constructor(options: CompressionOptions);
  
  async compress(data: string): Promise<Buffer>;
  async decompress(data: Buffer): Promise<string>;
}
```

## Implementation Notes

1. Cache Configuration
   - Store selection
   - Serialization options
   - Compression settings
   - Cluster configuration

2. Performance Optimization
   - Connection pooling
   - Batch operations
   - Compression thresholds
   - Memory management

3. Cache Consistency
   - Invalidation strategies
   - Dependency tracking
   - Tag management
   - Versioning

4. Error Handling
   - Store failures
   - Network issues
   - Data corruption
   - Recovery strategies

5. Monitoring
   - Hit/miss ratios
   - Memory usage
   - Latency tracking
   - Error rates

## Testing Requirements

1. Store Tests
   - Basic operations
   - Bulk operations
   - Connection handling
   - Error scenarios

2. Strategy Tests
   - Read-through caching
   - Write-through caching
   - Write-back caching
   - Cache-aside pattern

3. Tag Tests
   - Tag management
   - Tag invalidation
   - Dependency tracking
   - Composite dependencies

4. Performance Tests
   - Throughput
   - Latency
   - Memory usage
   - Concurrent access

## Usage Examples

### Basic Cache Usage

```typescript
const cache = new CacheManager({
  store: 'redis',
  prefix: 'app:',
  ttl: 3600
});

// Set cache
await cache.set('user:1', { id: 1, name: 'John' });

// Get cache
const user = await cache.get('user:1');

// Delete cache
await cache.delete('user:1');
```

### Tagged Cache

```typescript
const taggedCache = cache.tags(['users', 'active']);

await taggedCache.set('user:1', userData);
await taggedCache.invalidateTag('users');
```

### Cache-Aside Pattern

```typescript
const userCache = new CacheAside(
  cache,
  async (id: string) => {
    return await database.users.findById(id);
  }
);

const user = await userCache.get('user:1');
```

### Cached Decorator

```typescript
class UserService {
  @Cached({ ttl: 3600 })
  async getUserById(id: string): Promise<User> {
    return await database.users.findById(id);
  }
  
  @InvalidateCache(['users'])
  async updateUser(id: string, data: Partial<User>): Promise<User> {
    return await database.users.update(id, data);
  }
}
```

### Write-Through Cache

```typescript
const writeThrough = new WriteThroughStrategy(
  cache,
  async (key: string, value: unknown) => {
    await database.set(key, value);
  }
);

await writeThrough.set('user:1', userData);
```
