# @jadugar/ui Navigation System

This document specifies the navigation system implementation for the Jadugar UI package. The navigation system provides comprehensive routing, history management, and navigation state handling.

## Navigation Architecture

### Router Manager

```typescript
interface RouterOptions {
  mode?: 'history' | 'hash';
  base?: string;
  plugins?: RouterPlugin[];
  scrollBehavior?: ScrollBehavior;
}

class RouterManager {
  constructor(options: RouterOptions);
  
  // Router Operations
  navigate(to: RouteLocation): Promise<void>;
  replace(to: RouteLocation): Promise<void>;
  
  // Route Management
  register(route: Route): void;
  unregister(name: string): void;
  
  // Configuration
  configure(options: RouterOptions): void;
  getConfig(): RouterConfig;
}
```

## Route System

### Route Manager

```typescript
interface RouteOptions {
  path: string;
  name?: string;
  component?: Component;
  meta?: RouteMeta;
  children?: Route[];
}

class RouteManager {
  constructor(options: RouteOptions);
  
  // Route Operations
  match(path: string): RouteMatch;
  resolve(name: string, params?: RouteParams): string;
  
  // Guard Management
  addGuard(guard: NavigationGuard): void;
  removeGuard(name: string): void;
}
```

### Route Guards

```typescript
interface GuardOptions {
  type: GuardType;
  priority?: number;
  meta?: GuardMeta;
}

class NavigationGuard {
  constructor(options: GuardOptions);
  
  // Guard Operations
  beforeEach(to: Route, from: Route): Promise<boolean>;
  afterEach(to: Route, from: Route): void;
  
  // State Management
  getState(): GuardState;
  setState(state: GuardState): void;
}
```

## History System

### History Manager

```typescript
interface HistoryOptions {
  maxSize?: number;
  storage?: Storage;
  serialize?: boolean;
}

class HistoryManager {
  constructor(options: HistoryOptions);
  
  // History Operations
  push(entry: HistoryEntry): void;
  back(): void;
  forward(): void;
  
  // State Management
  getState(): HistoryState;
  setState(state: HistoryState): void;
}
```

### History Stack

```typescript
interface StackOptions {
  initialEntries?: HistoryEntry[];
  initialIndex?: number;
}

class HistoryStack {
  constructor(options: StackOptions);
  
  // Stack Operations
  push(entry: HistoryEntry): void;
  pop(): HistoryEntry;
  
  // Navigation
  go(delta: number): void;
  canGo(delta: number): boolean;
}
```

## Link System

### Link Manager

```typescript
interface LinkOptions {
  active?: string;
  exact?: boolean;
  replace?: boolean;
}

class LinkManager {
  constructor(options: LinkOptions);
  
  // Link Operations
  create(to: RouteLocation, options?: LinkOptions): Link;
  update(link: Link, options?: LinkOptions): void;
  
  // State Management
  setActive(link: Link): void;
  setInactive(link: Link): void;
}
```

### Link Types

```typescript
interface RouterLink extends Link {
  // Link Operations
  navigate(): Promise<void>;
  isActive(): boolean;
  
  // State Management
  getState(): LinkState;
  setState(state: LinkState): void;
}

interface ExternalLink extends Link {
  // Link Operations
  open(target?: string): void;
  validate(): boolean;
  
  // Security
  setSecurity(options: SecurityOptions): void;
  checkSecurity(): boolean;
}
```

## Navigation State

### State Manager

```typescript
interface StateOptions {
  persist?: boolean;
  storage?: Storage;
  key?: string;
}

class NavigationState {
  constructor(options: StateOptions);
  
  // State Operations
  save(state: State): void;
  restore(): State;
  
  // History Management
  pushState(state: State): void;
  replaceState(state: State): void;
}
```

### State Persistence

```typescript
interface PersistenceOptions {
  storage?: Storage;
  serialize?: boolean;
  expires?: number;
}

class StatePersistence {
  constructor(options: PersistenceOptions);
  
  // Persistence Operations
  save(key: string, value: any): Promise<void>;
  load(key: string): Promise<any>;
  
  // Management
  clear(): Promise<void>;
  cleanup(): Promise<void>;
}
```

## Implementation Notes

1. Navigation Design
   - Route matching
   - Guard execution
   - History management
   - Link handling

2. Performance
   - Route caching
   - History size
   - State serialization
   - Link updates

3. Security
   - Navigation guards
   - External links
   - State validation
   - XSS prevention

4. Integration
   - Framework binding
   - State management
   - Component loading
   - Event handling

5. Best Practices
   - Route organization
   - Guard patterns
   - State management
   - Error handling

## Testing Requirements

1. Router Tests
   - Route matching
   - Navigation
   - Guard execution
   - History management

2. Link Tests
   - Creation
   - Activation
   - Navigation
   - Security

3. State Tests
   - Persistence
   - Restoration
   - History
   - Cleanup

4. Integration Tests
   - Framework binding
   - Component loading
   - Event handling
   - Error scenarios

## Usage Examples

### Basic Routing

```typescript
const router = new RouterManager({
  mode: 'history',
  base: '/app'
});

// Register routes
router.register({
  path: '/users',
  name: 'users',
  component: UserList,
  children: [
    {
      path: ':id',
      name: 'user-detail',
      component: UserDetail
    }
  ]
});

// Navigate
await router.navigate('/users/123');

// Replace current route
await router.replace('/dashboard');
```

### Navigation Guards

```typescript
const authGuard = new NavigationGuard({
  type: 'beforeEach',
  priority: 1
});

// Add guard logic
authGuard.beforeEach(async (to, from) => {
  if (to.meta.requiresAuth && !isAuthenticated()) {
    return false;
  }
  return true;
});

// Register guard
router.addGuard(authGuard);
```

### Router Links

```typescript
const links = new LinkManager({
  active: 'active-link',
  exact: true
});

// Create router link
const userLink = links.create({
  name: 'user-detail',
  params: { id: '123' }
}, {
  replace: false
});

// Handle navigation
userLink.navigate().then(() => {
  console.log('Navigation complete');
});
```

### History Management

```typescript
const history = new HistoryManager({
  maxSize: 100,
  storage: sessionStorage
});

// Push new entry
history.push({
  path: '/users',
  state: { scrollPosition: 0 }
});

// Navigate
history.back();
history.forward();

// Check state
const current = history.getState();
console.log('Current path:', current.path);
```
