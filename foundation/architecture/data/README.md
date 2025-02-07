# Data Layer Interfaces

## IDataStore

Generic data storage interface for CRUD operations.

### Methods

```typescript
interface IDataStore<T = unknown> {
  create(data: T): Promise<T>;
  read(id: string): Promise<T | null>;
  update(id: string, data: Partial<T>): Promise<T>;
  delete(id: string): Promise<void>;
  query(query: QueryCriteria): Promise<T[]>;
  count(): Promise<number>;
}
```

### Usage Example

```typescript
interface User {
  id: string;
  name: string;
  email: string;
}

class UserStore implements IDataStore<User> {
  private users = new Map<string, User>();

  async create(data: User): Promise<User> {
    const id = crypto.randomUUID();
    const user = { ...data, id };
    this.users.set(id, user);
    return user;
  }

  async read(id: string): Promise<User | null> {
    return this.users.get(id) || null;
  }

  async update(id: string, data: Partial<User>): Promise<User> {
    const existing = await this.read(id);
    if (!existing) {
      throw new Error(`User not found: ${id}`);
    }
    const updated = { ...existing, ...data };
    this.users.set(id, updated);
    return updated;
  }

  async delete(id: string): Promise<void> {
    this.users.delete(id);
  }

  async query(query: QueryCriteria): Promise<User[]> {
    return Array.from(this.users.values()).filter(user => {
      // Apply query criteria
      return true;
    });
  }

  async count(): Promise<number> {
    return this.users.size;
  }
}
```

## IOfflineStore

Offline-first storage with sync capabilities.

### Methods

```typescript
interface IOfflineStore<T = unknown> extends IDataStore<T> {
  enableOffline(): void;
  disableOffline(): void;
  isOfflineEnabled(): boolean;
  sync(): Promise<void>;
  getSyncStatus(): SyncStatus;
  getPendingChanges(): Promise<PendingChange<T>[]>;
}
```

### Usage Example

```typescript
class OfflineUserStore implements IOfflineStore<User> {
  private online = new UserStore();
  private offline = new UserStore();
  private pendingChanges: PendingChange<User>[] = [];
  private offlineEnabled = false;

  private get activeStore() {
    return this.offlineEnabled ? this.offline : this.online;
  }

  async create(data: User): Promise<User> {
    const result = await this.activeStore.create(data);
    if (this.offlineEnabled) {
      this.pendingChanges.push({
        id: result.id,
        operation: 'create',
        data: result,
        timestamp: new Date()
      });
    }
    return result;
  }

  async sync(): Promise<void> {
    for (const change of this.pendingChanges) {
      try {
        switch (change.operation) {
          case 'create':
            await this.online.create(change.data!);
            break;
          case 'update':
            await this.online.update(change.id, change.data!);
            break;
          case 'delete':
            await this.online.delete(change.id);
            break;
        }
      } catch (error) {
        console.error(`Sync error for ${change.id}:`, error);
      }
    }
    this.pendingChanges = [];
  }

  // ... other implementations
}
```

## IHipaaStore

HIPAA-compliant storage with encryption and access logging.

### Methods

```typescript
interface IHipaaStore<T = unknown> extends IDataStore<T> {
  createPHI(data: T): Promise<T>;
  readPHI(id: string): Promise<T | null>;
  updatePHI(id: string, data: Partial<T>): Promise<T>;
  logAccess(recordId: string, userId: string, action: AccessAction): Promise<void>;
  getAccessLogs(recordId: string): Promise<AccessLog[]>;
}
```

### Usage Example

```typescript
class HipaaUserStore implements IHipaaStore<User> {
  private store = new UserStore();
  private accessLogs: AccessLog[] = [];
  private encryptionKey: CryptoKey;

  constructor(encryptionKey: CryptoKey) {
    this.encryptionKey = encryptionKey;
  }

  async createPHI(data: User): Promise<User> {
    const encrypted = await this.encrypt(data);
    const result = await this.store.create(encrypted);
    await this.logAccess(result.id, 'system', 'create');
    return result;
  }

  async readPHI(id: string): Promise<User | null> {
    const encrypted = await this.store.read(id);
    if (!encrypted) return null;
    await this.logAccess(id, 'system', 'read');
    return this.decrypt(encrypted);
  }

  private async encrypt(data: User): Promise<User> {
    // Implement encryption
    return data;
  }

  private async decrypt(data: User): Promise<User> {
    // Implement decryption
    return data;
  }

  async logAccess(recordId: string, userId: string, action: AccessAction): Promise<void> {
    this.accessLogs.push({
      recordId,
      userId,
      action,
      timestamp: new Date(),
      ipAddress: '127.0.0.1',
      userAgent: 'system'
    });
  }

  // ... other implementations
}
```

## ITenantStore

Multi-tenant storage with data isolation.

### Methods

```typescript
interface ITenantStore<T = unknown> extends IDataStore<T> {
  createForTenant(tenantId: string, data: T): Promise<T>;
  readForTenant(tenantId: string, id: string): Promise<T | null>;
  updateForTenant(tenantId: string, id: string, data: Partial<T>): Promise<T>;
  deleteForTenant(tenantId: string, id: string): Promise<void>;
  queryForTenant(tenantId: string, query: QueryCriteria): Promise<T[]>;
}
```

### Usage Example

```typescript
class TenantUserStore implements ITenantStore<User> {
  private tenantStores = new Map<string, UserStore>();

  private getTenantStore(tenantId: string): UserStore {
    if (!this.tenantStores.has(tenantId)) {
      this.tenantStores.set(tenantId, new UserStore());
    }
    return this.tenantStores.get(tenantId)!;
  }

  async createForTenant(tenantId: string, data: User): Promise<User> {
    const store = this.getTenantStore(tenantId);
    return store.create(data);
  }

  async readForTenant(tenantId: string, id: string): Promise<User | null> {
    const store = this.getTenantStore(tenantId);
    return store.read(id);
  }

  async queryForTenant(tenantId: string, query: QueryCriteria): Promise<User[]> {
    const store = this.getTenantStore(tenantId);
    return store.query(query);
  }

  // ... other implementations
}
```

## Best Practices

1. **Data Integrity**
   - Use transactions where possible
   - Implement optimistic locking
   - Validate data before storage

2. **Performance**
   - Implement caching strategies
   - Use indexes appropriately
   - Support batch operations

3. **Security**
   - Encrypt sensitive data
   - Implement access controls
   - Log all access attempts

4. **Offline Support**
   - Handle sync conflicts
   - Implement retry mechanisms
   - Maintain data consistency

5. **Multi-tenancy**
   - Ensure data isolation
   - Support tenant-specific configurations
   - Implement resource quotas

6. **Testing**
   - Test CRUD operations
   - Verify data integrity
   - Test sync mechanisms
   - Validate security measures
