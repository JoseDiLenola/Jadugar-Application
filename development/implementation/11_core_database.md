# @jadugar/core Database Layer

This document specifies the database layer implementation for the Jadugar project. The database layer provides a flexible, type-safe interface for data persistence with support for multiple database engines.

## Database Architecture

### Database Manager

```typescript
interface DatabaseOptions {
  engine: 'postgres' | 'mysql' | 'mongodb';
  url: string;
  poolSize?: number;
  ssl?: boolean;
  timeout?: number;
  retryOptions?: RetryOptions;
  migrations?: MigrationOptions;
}

class DatabaseManager {
  constructor(options: DatabaseOptions);
  
  // Connection Management
  async connect(): Promise<void>;
  async disconnect(): Promise<void>;
  async healthCheck(): Promise<HealthStatus>;
  
  // Transaction Management
  async transaction<T>(
    fn: (tx: Transaction) => Promise<T>
  ): Promise<T>;
  
  // Migration Management
  async migrate(options?: MigrationOptions): Promise<void>;
  async rollback(steps?: number): Promise<void>;
  
  // Query Builder Access
  getQueryBuilder(): QueryBuilder;
  
  // Events
  on(event: DatabaseEvent, handler: EventHandler): this;
  off(event: DatabaseEvent, handler: EventHandler): this;
}
```

### Connection Pool

```typescript
interface PoolOptions {
  min: number;
  max: number;
  idleTimeout?: number;
  acquireTimeout?: number;
  createTimeout?: number;
}

class ConnectionPool {
  constructor(options: PoolOptions);
  
  // Pool Management
  async acquire(): Promise<Connection>;
  async release(connection: Connection): Promise<void>;
  async clear(): Promise<void>;
  
  // Pool Status
  getStatus(): PoolStatus;
  getMetrics(): PoolMetrics;
}
```

## Query Building

### Query Builder

```typescript
interface QueryOptions {
  timeout?: number;
  useReplica?: boolean;
  consistency?: ConsistencyLevel;
}

class QueryBuilder {
  // Table Operations
  table(name: string): TableQueryBuilder;
  raw(sql: string, params?: unknown[]): RawQueryBuilder;
  
  // Transactions
  transaction(): Transaction;
  
  // Schema Operations
  schema(): SchemaBuilder;
  
  // Utilities
  escape(value: unknown): string;
  format(sql: string, params: unknown[]): string;
}
```

### Table Query Builder

```typescript
interface TableQueryBuilder<T = any> {
  // Select Operations
  select(...columns: string[]): SelectQueryBuilder<T>;
  where(conditions: WhereConditions): this;
  orderBy(column: string, direction?: 'asc' | 'desc'): this;
  limit(limit: number): this;
  offset(offset: number): this;
  
  // Insert Operations
  insert(data: Partial<T>): InsertQueryBuilder<T>;
  insertMany(data: Partial<T>[]): InsertQueryBuilder<T>;
  
  // Update Operations
  update(data: Partial<T>): UpdateQueryBuilder<T>;
  
  // Delete Operations
  delete(): DeleteQueryBuilder;
  
  // Joins
  join(table: string, conditions: JoinConditions): this;
  leftJoin(table: string, conditions: JoinConditions): this;
  rightJoin(table: string, conditions: JoinConditions): this;
  
  // Aggregations
  count(column?: string): Promise<number>;
  sum(column: string): Promise<number>;
  avg(column: string): Promise<number>;
  min(column: string): Promise<number>;
  max(column: string): Promise<number>;
  
  // Execution
  execute(): Promise<QueryResult<T>>;
}
```

### Schema Builder

```typescript
interface SchemaBuilder {
  // Table Operations
  createTable(name: string, fn: TableBuilder): SchemaBuilder;
  dropTable(name: string): SchemaBuilder;
  renameTable(from: string, to: string): SchemaBuilder;
  
  // Column Operations
  addColumn(table: string, column: ColumnDefinition): SchemaBuilder;
  dropColumn(table: string, column: string): SchemaBuilder;
  renameColumn(
    table: string,
    from: string,
    to: string
  ): SchemaBuilder;
  
  // Index Operations
  createIndex(
    table: string,
    columns: string[],
    options?: IndexOptions
  ): SchemaBuilder;
  dropIndex(table: string, indexName: string): SchemaBuilder;
  
  // Foreign Key Operations
  addForeignKey(
    table: string,
    reference: ForeignKeyReference
  ): SchemaBuilder;
  dropForeignKey(
    table: string,
    foreignKey: string
  ): SchemaBuilder;
  
  // Execution
  execute(): Promise<void>;
}
```

## Migrations

### Migration System

```typescript
interface MigrationOptions {
  directory: string;
  tableName?: string;
  sortOrder?: 'asc' | 'desc';
  transaction?: boolean;
}

interface Migration {
  up(db: QueryBuilder): Promise<void>;
  down(db: QueryBuilder): Promise<void>;
}

class MigrationManager {
  constructor(options: MigrationOptions);
  
  // Migration Operations
  async migrate(options?: MigrationOptions): Promise<void>;
  async rollback(steps?: number): Promise<void>;
  async reset(): Promise<void>;
  async refresh(): Promise<void>;
  
  // Migration Status
  async getStatus(): Promise<MigrationStatus[]>;
  async getPending(): Promise<Migration[]>;
  async getExecuted(): Promise<Migration[]>;
  
  // Migration Creation
  async create(name: string): Promise<string>;
}
```

## Models

### Base Model

```typescript
interface ModelOptions {
  table: string;
  primaryKey?: string;
  timestamps?: boolean;
  softDeletes?: boolean;
}

class Model<T> {
  constructor(data: Partial<T>);
  
  // CRUD Operations
  static async find(id: string | number): Promise<T>;
  static async findBy(conditions: WhereConditions): Promise<T[]>;
  static async create(data: Partial<T>): Promise<T>;
  static async update(id: string | number, data: Partial<T>): Promise<T>;
  static async delete(id: string | number): Promise<void>;
  
  // Query Building
  static query(): TableQueryBuilder<T>;
  
  // Relationships
  hasOne<R>(
    related: typeof Model,
    foreignKey: string
  ): RelationshipBuilder<R>;
  hasMany<R>(
    related: typeof Model,
    foreignKey: string
  ): RelationshipBuilder<R>;
  belongsTo<R>(
    related: typeof Model,
    foreignKey: string
  ): RelationshipBuilder<R>;
  
  // Instance Methods
  async save(): Promise<this>;
  async refresh(): Promise<this>;
  async delete(): Promise<void>;
}
```

### Model Relationships

```typescript
interface RelationshipOptions {
  foreignKey: string;
  localKey?: string;
  onDelete?: 'cascade' | 'set null' | 'restrict';
  onUpdate?: 'cascade' | 'set null' | 'restrict';
}

class RelationshipBuilder<T> {
  // Query Modification
  select(...columns: string[]): this;
  where(conditions: WhereConditions): this;
  orderBy(column: string, direction?: 'asc' | 'desc'): this;
  
  // Eager Loading
  with(...relations: string[]): this;
  withCount(...relations: string[]): this;
  
  // Execution
  get(): Promise<T[]>;
  first(): Promise<T>;
  count(): Promise<number>;
}
```

## Implementation Notes

1. Database Configuration
   - Environment-based configuration
   - Connection pooling
   - SSL support
   - Timeout handling
   - Retry strategies

2. Query Building
   - Type-safe queries
   - Query optimization
   - Parameter binding
   - SQL injection prevention

3. Schema Management
   - Automated migrations
   - Schema versioning
   - Data integrity
   - Index optimization

4. Model Layer
   - Active Record pattern
   - Relationship management
   - Eager loading
   - Event system

5. Performance
   - Connection pooling
   - Query caching
   - Batch operations
   - Lazy loading

6. Security
   - SQL injection prevention
   - Data validation
   - Access control
   - Encryption support

## Testing Requirements

1. Connection Tests
   - Pool management
   - Connection lifecycle
   - Error handling
   - Retry logic

2. Query Tests
   - CRUD operations
   - Complex queries
   - Transactions
   - Concurrency

3. Migration Tests
   - Up/down migrations
   - Rollback scenarios
   - Schema changes
   - Data preservation

4. Model Tests
   - Relationship loading
   - Event handling
   - Validation
   - Serialization

5. Performance Tests
   - Connection pool
   - Query execution
   - Batch operations
   - Memory usage

## Usage Examples

### Basic Database Operations

```typescript
const db = new DatabaseManager({
  engine: 'postgres',
  url: process.env.DATABASE_URL,
  poolSize: 10
});

await db.connect();

const result = await db
  .getQueryBuilder()
  .table('users')
  .select('id', 'name', 'email')
  .where({ active: true })
  .execute();
```

### Model Usage

```typescript
class User extends Model<User> {
  static table = 'users';
  static timestamps = true;
  
  id: number;
  name: string;
  email: string;
  posts?: Post[];
  
  static async findByEmail(email: string): Promise<User> {
    return this.findBy({ email }).first();
  }
  
  async getPosts(): Promise<Post[]> {
    return this.hasMany(Post, 'userId').get();
  }
}

// Create a user
const user = await User.create({
  name: 'John Doe',
  email: 'john@example.com'
});

// Find with relationships
const userWithPosts = await User.query()
  .where({ id: 1 })
  .with('posts')
  .first();
```

### Migrations

```typescript
export class CreateUsersTable implements Migration {
  async up(db: QueryBuilder): Promise<void> {
    await db.schema()
      .createTable('users', table => {
        table.increments('id');
        table.string('name').notNull();
        table.string('email').unique().notNull();
        table.timestamp('createdAt').defaultTo(db.fn.now());
        table.timestamp('updatedAt').defaultTo(db.fn.now());
      })
      .execute();
  }

  async down(db: QueryBuilder): Promise<void> {
    await db.schema()
      .dropTable('users')
      .execute();
  }
}
```

### Transactions

```typescript
await db.transaction(async tx => {
  const user = await tx
    .table('users')
    .insert({ name: 'John', email: 'john@example.com' })
    .execute();
    
  await tx
    .table('profiles')
    .insert({ userId: user.id, bio: 'Hello!' })
    .execute();
});
```
