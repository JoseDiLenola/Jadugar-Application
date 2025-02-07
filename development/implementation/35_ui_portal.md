# @jadugar/ui Portal System

This document specifies the portal system implementation for the Jadugar UI package. The portal system provides a way to render children into a DOM node that exists outside the DOM hierarchy of the parent component.

## Portal Architecture

### Portal Manager

```typescript
interface PortalOptions {
  container?: HTMLElement;
  plugins?: PortalPlugin[];
  zIndex?: number | ((portal: Portal) => number);
}

class PortalManager {
  constructor(options: PortalOptions);
  
  // Portal Operations
  create(config: PortalConfig): Portal;
  remove(id: string): Promise<void>;
  
  // System Management
  register(plugin: PortalPlugin): void;
  unregister(name: string): void;
  
  // Configuration
  configure(options: PortalOptions): void;
  getConfig(): PortalConfig;
}
```

## Portal System

### Portal Container

```typescript
interface ContainerOptions {
  target?: HTMLElement;
  strategy?: MountStrategy;
  cleanup?: boolean;
}

class PortalContainer {
  constructor(options: ContainerOptions);
  
  // Container Operations
  mount(content: PortalContent): void;
  unmount(): Promise<void>;
  
  // DOM Management
  append(element: Element): void;
  remove(element: Element): void;
}
```

### Portal Content

```typescript
interface ContentOptions {
  key?: string;
  children: any;
  context?: any;
}

class PortalContent {
  constructor(options: ContentOptions);
  
  // Content Operations
  render(): Element;
  update(children: any): void;
  
  // Context Management
  setContext(context: any): void;
  getContext(): any;
}
```

## Context System

### Context Manager

```typescript
interface ContextOptions {
  inherit?: boolean;
  isolate?: boolean;
  merge?: ContextMergeStrategy;
}

class ContextManager {
  constructor(options: ContextOptions);
  
  // Context Operations
  provide(key: string, value: any): void;
  consume(key: string): any;
  
  // Inheritance
  inherit(parent: Context): void;
  isolate(): void;
}
```

### Context Bridge

```typescript
interface BridgeOptions {
  keys?: string[];
  transform?: (value: any) => any;
}

class ContextBridge {
  constructor(options: BridgeOptions);
  
  // Bridge Operations
  connect(source: Context, target: Context): void;
  disconnect(): void;
  
  // Transform Management
  setTransform(key: string, transform: Transform): void;
  removeTransform(key: string): void;
}
```

## Event System

### Event Manager

```typescript
interface EventOptions {
  bubble?: boolean;
  capture?: boolean;
  once?: boolean;
}

class EventManager {
  constructor(options: EventOptions);
  
  // Event Operations
  dispatch(event: PortalEvent): void;
  forward(event: PortalEvent): void;
  
  // Handler Management
  addHandler(type: string, handler: EventHandler): void;
  removeHandler(type: string, handler: EventHandler): void;
}
```

### Event Bridge

```typescript
interface EventBridgeOptions {
  types?: string[];
  transform?: EventTransform;
}

class EventBridge {
  constructor(options: EventBridgeOptions);
  
  // Bridge Operations
  connect(source: EventTarget, target: EventTarget): void;
  disconnect(): void;
  
  // Filter Management
  addFilter(type: string, filter: EventFilter): void;
  removeFilter(type: string): void;
}
```

## Lifecycle System

### Lifecycle Manager

```typescript
interface LifecycleOptions {
  mount?: LifecycleHook;
  unmount?: LifecycleHook;
  update?: LifecycleHook;
}

class LifecycleManager {
  constructor(options: LifecycleOptions);
  
  // Lifecycle Operations
  mount(): Promise<void>;
  unmount(): Promise<void>;
  update(): Promise<void>;
  
  // Hook Management
  addHook(type: string, hook: LifecycleHook): void;
  removeHook(type: string): void;
}
```

### Lifecycle Hooks

```typescript
interface HookOptions {
  async?: boolean;
  timeout?: number;
  errorHandler?: ErrorHandler;
}

class LifecycleHook {
  constructor(options: HookOptions);
  
  // Hook Operations
  execute(...args: any[]): Promise<void>;
  cancel(): void;
  
  // Error Management
  onError(handler: ErrorHandler): void;
  offError(handler: ErrorHandler): void;
}
```

## Implementation Notes

1. Portal Design
   - Mount strategies
   - Context handling
   - Event bubbling
   - Lifecycle management

2. Performance
   - DOM operations
   - Event delegation
   - Context updates
   - Memory management

3. Features
   - Multiple portals
   - Nested portals
   - Context bridging
   - Event forwarding

4. Integration
   - Framework binding
   - State management
   - Animation system
   - Error handling

5. Best Practices
   - Portal patterns
   - Context usage
   - Event handling
   - Cleanup strategies

## Testing Requirements

1. Portal Tests
   - Mount/unmount
   - Content updates
   - Context flow
   - Event handling

2. Performance Tests
   - Mount time
   - Update time
   - Memory usage
   - Event overhead

3. Feature Tests
   - Multiple portals
   - Nested portals
   - Context bridging
   - Event forwarding

4. Integration Tests
   - Framework binding
   - State updates
   - Animation system
   - Error scenarios

## Usage Examples

### Basic Portal

```typescript
const portals = new PortalManager({
  container: document.body,
  zIndex: 1000
});

// Create portal
const portal = portals.create({
  content: <div>Portal Content</div>,
  target: document.querySelector('#portal-root')
});

// Update content
portal.update(<div>Updated Content</div>);

// Remove portal
await portal.remove();
```

### Context Bridge

```typescript
const bridge = new ContextBridge({
  keys: ['theme', 'locale'],
  transform: {
    theme: (value) => ({ ...value, portal: true })
  }
});

// Connect contexts
bridge.connect(parentContext, portalContext);

// Handle updates
bridge.onUpdate((key, value) => {
  console.log(`Context ${key} updated:`, value);
});

// Cleanup
bridge.disconnect();
```

### Event Forwarding

```typescript
const events = new EventManager({
  bubble: true,
  capture: false
});

// Add event handler
events.addHandler('click', (event) => {
  console.log('Portal clicked:', event);
});

// Forward events
const bridge = new EventBridge({
  types: ['click', 'focus', 'blur']
});

bridge.connect(portalElement, parentElement);

// Add event filter
bridge.addFilter('click', (event) => {
  return event.target.matches('.interactive');
});
```

### Lifecycle Hooks

```typescript
const lifecycle = new LifecycleManager({
  mount: async () => {
    await setupPortal();
  },
  unmount: async () => {
    await cleanupPortal();
  }
});

// Add custom hook
lifecycle.addHook('update', async () => {
  await updatePortalContent();
});

// Handle errors
lifecycle.onError((error) => {
  console.error('Lifecycle error:', error);
});

// Execute lifecycle
await lifecycle.mount();
```
