# @jadugar/ui State Management

This document specifies the state management system implementation for the Jadugar UI package. The state system provides comprehensive state management with support for local and global state, middleware, and state persistence.

## State Architecture

### State Manager

```typescript
interface StateOptions {
  initial?: State;
  middleware?: StateMiddleware[];
  persistence?: PersistenceOptions;
  devtools?: DevToolsOptions;
}

class StateManager {
  constructor(options: StateOptions);
  
  // State Operations
  setState(path: string, value: any): void;
  getState(path?: string): any;
  
  // State Management
  subscribe(listener: StateListener): Unsubscribe;
  batch(updates: StateUpdate[]): void;
  
  // Configuration
  configure(options: StateOptions): void;
  getConfig(): StateConfig;
}
```

## State Store

### Store Interface

```typescript
interface Store<T = any> {
  // Store Operations
  get(): T;
  set(value: T): void;
  update(updater: (state: T) => T): void;
  
  // Subscriptions
  subscribe(listener: StoreListener<T>): Unsubscribe;
  notify(): void;
  
  // Store Management
  reset(): void;
  destroy(): void;
}
```

### Store Implementation

```typescript
class LocalStore<T> implements Store<T> {
  constructor(initial: T, options?: StoreOptions);
  
  // Implementation
  private state: T;
  private listeners: Set<StoreListener<T>>;
  
  get(): T {
    return this.state;
  }
  
  set(value: T): void {
    this.state = value;
    this.notify();
  }
}

class GlobalStore<T> implements Store<T> {
  constructor(initial: T, options?: GlobalStoreOptions);
  // Global store implementation
}
```

## State Selectors

### Selector System

```typescript
interface SelectorOptions<T, R> {
  equals?: (a: R, b: R) => boolean;
  dependencies?: Store<any>[];
}

class Selector<T, R = T> {
  constructor(
    store: Store<T>,
    selector: (state: T) => R,
    options?: SelectorOptions<T, R>
  );
  
  // Selector Operations
  get(): R;
  subscribe(listener: (value: R) => void): Unsubscribe;
  
  // Cache Management
  invalidate(): void;
  recompute(): R;
}
```

### Computed Values

```typescript
interface ComputedOptions<T> {
  equals?: (a: T, b: T) => boolean;
  cache?: boolean;
}

class Computed<T> {
  constructor(
    compute: () => T,
    options?: ComputedOptions<T>
  );
  
  // Computed Operations
  get(): T;
  subscribe(listener: (value: T) => void): Unsubscribe;
  
  // Cache Management
  invalidate(): void;
  recompute(): T;
}
```

## State Middleware

### Middleware Interface

```typescript
interface StateMiddleware {
  name: string;
  
  // Middleware Operations
  before(state: State, action: Action): void;
  after(state: State, action: Action): void;
  
  // Error Handling
  onError(error: Error, state: State, action: Action): void;
  
  // Middleware Management
  configure(options: MiddlewareOptions): void;
  isEnabled(): boolean;
}
```

### Middleware Implementations

```typescript
class LoggerMiddleware implements StateMiddleware {
  constructor(options?: LoggerOptions);
  
  // Implementation
  before(state: State, action: Action): void {
    console.log('Before:', action, state);
  }
  
  after(state: State, action: Action): void {
    console.log('After:', action, state);
  }
}

class PersistenceMiddleware implements StateMiddleware {
  constructor(options: PersistenceOptions);
  // Persistence middleware implementation
}
```

## State Actions

### Action System

```typescript
interface Action {
  type: string;
  payload?: any;
  meta?: Record<string, any>;
}

class ActionCreator<P = void> {
  constructor(type: string);
  
  // Action Creation
  create(payload: P): Action;
  match(action: Action): action is Action & { payload: P };
  
  // Type Information
  toString(): string;
  getType(): string;
}
```

### Action Handlers

```typescript
interface ActionHandler<S, P> {
  // Handler Operations
  handle(state: S, payload: P): S;
  canHandle(action: Action): boolean;
  
  // Handler Management
  configure(options: HandlerOptions): void;
  isEnabled(): boolean;
}

class ReducerActionHandler<S, P> implements ActionHandler<S, P> {
  constructor(
    type: string,
    reducer: (state: S, payload: P) => S
  );
  // Implementation
}
```

## State Persistence

### Persistence System

```typescript
interface PersistenceOptions {
  storage?: Storage;
  key?: string;
  serialize?: (state: State) => string;
  deserialize?: (data: string) => State;
}

class StatePersistence {
  constructor(options: PersistenceOptions);
  
  // Persistence Operations
  save(state: State): Promise<void>;
  load(): Promise<State>;
  
  // Storage Management
  clear(): Promise<void>;
  migrate(version: number): Promise<void>;
}
```

### Storage Providers

```typescript
interface Storage {
  // Storage Operations
  getItem(key: string): Promise<string | null>;
  setItem(key: string, value: string): Promise<void>;
  removeItem(key: string): Promise<void>;
  
  // Storage Management
  clear(): Promise<void>;
  keys(): Promise<string[]>;
}

class LocalStorage implements Storage {
  constructor(options?: StorageOptions);
  // Local storage implementation
}
```

## Implementation Notes

1. State Design
   - Immutability
   - State shape
   - Performance
   - Memory usage

2. Updates
   - Batching
   - Transactions
   - Optimistic updates
   - Error handling

3. Subscriptions
   - Dependency tracking
   - Memory leaks
   - Update ordering
   - Change detection

4. Integration
   - Framework bindings
   - Middleware chain
   - DevTools
   - Time travel

5. Best Practices
   - State normalization
   - Action patterns
   - Error handling
   - Testing strategies

## Testing Requirements

1. Store Tests
   - State updates
   - Subscriptions
   - Middleware
   - Persistence

2. Action Tests
   - Creation
   - Handling
   - Side effects
   - Error cases

3. Selector Tests
   - Computation
   - Dependencies
   - Caching
   - Invalidation

4. Integration Tests
   - Framework binding
   - Middleware chain
   - Storage providers
   - Performance impact

## Usage Examples

### Basic Store

```typescript
const store = new LocalStore({
  count: 0,
  todos: []
});

// Subscribe to changes
store.subscribe((state) => {
  console.log('New state:', state);
});

// Update state
store.update((state) => ({
  ...state,
  count: state.count + 1
}));
```

### Global Store

```typescript
const userStore = new GlobalStore({
  user: null,
  settings: {}
}, {
  persistence: {
    key: 'user-store',
    storage: new LocalStorage()
  }
});

// Create actions
const setUser = new ActionCreator<User>('SET_USER');
const updateSettings = new ActionCreator<Settings>('UPDATE_SETTINGS');

// Handle actions
userStore.handle(setUser, (state, user) => ({
  ...state,
  user
}));

// Dispatch action
userStore.dispatch(setUser.create({
  id: 1,
  name: 'John'
}));
```

### Computed Values

```typescript
const todoStore = new LocalStore({
  todos: []
});

const completedTodos = new Selector(
  todoStore,
  state => state.todos.filter(todo => todo.completed)
);

const todoStats = new Computed(() => ({
  total: todoStore.get().todos.length,
  completed: completedTodos.get().length
}));

todoStats.subscribe(stats => {
  console.log('Todo stats:', stats);
});
```

### Middleware Usage

```typescript
const store = new StateManager({
  middleware: [
    new LoggerMiddleware(),
    new PersistenceMiddleware({
      storage: new LocalStorage(),
      key: 'app-state'
    })
  ]
});

// Actions will be logged and persisted
store.setState('user', {
  name: 'John',
  role: 'admin'
});
```
