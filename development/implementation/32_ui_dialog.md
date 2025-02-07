# @jadugar/ui Dialog System

This document specifies the dialog system implementation for the Jadugar UI package. The dialog system provides comprehensive support for modals, drawers, popovers, and other overlay components.

## Dialog Architecture

### Dialog Manager

```typescript
interface DialogOptions {
  container?: HTMLElement;
  plugins?: DialogPlugin[];
  defaults?: DialogDefaults;
  zIndex?: number;
}

class DialogManager {
  constructor(options: DialogOptions);
  
  // Dialog Operations
  open(config: DialogConfig): Dialog;
  close(id: string): Promise<void>;
  
  // System Management
  register(plugin: DialogPlugin): void;
  unregister(name: string): void;
  
  // Configuration
  configure(options: DialogOptions): void;
  getConfig(): DialogConfig;
}
```

## Modal System

### Modal Manager

```typescript
interface ModalOptions {
  backdrop?: boolean | 'static';
  keyboard?: boolean;
  centered?: boolean;
  scrollable?: boolean;
}

class ModalManager {
  constructor(options: ModalOptions);
  
  // Modal Operations
  show(content: ModalContent, options?: ModalOptions): Modal;
  hide(id: string): Promise<void>;
  
  // Stack Management
  bringToFront(id: string): void;
  sendToBack(id: string): void;
}
```

### Modal Stack

```typescript
interface StackOptions {
  maxModals?: number;
  spacing?: number;
  animation?: StackAnimation;
}

class ModalStack {
  constructor(options: StackOptions);
  
  // Stack Operations
  push(modal: Modal): void;
  pop(): Modal;
  
  // Layout Management
  arrange(): void;
  reset(): void;
}
```

## Drawer System

### Drawer Manager

```typescript
interface DrawerOptions {
  position?: DrawerPosition;
  size?: string | number;
  overlay?: boolean;
}

class DrawerManager {
  constructor(options: DrawerOptions);
  
  // Drawer Operations
  open(content: DrawerContent, options?: DrawerOptions): Drawer;
  close(id: string): Promise<void>;
  
  // Position Management
  setPosition(position: DrawerPosition): void;
  setSize(size: string | number): void;
}
```

### Drawer Panel

```typescript
interface PanelOptions {
  resizable?: boolean;
  minSize?: number;
  maxSize?: number;
}

class DrawerPanel {
  constructor(options: PanelOptions);
  
  // Panel Operations
  resize(size: number): void;
  collapse(): void;
  expand(): void;
  
  // State Management
  getState(): PanelState;
  setState(state: PanelState): void;
}
```

## Popover System

### Popover Manager

```typescript
interface PopoverOptions {
  placement?: PopoverPlacement;
  trigger?: PopoverTrigger;
  offset?: number;
}

class PopoverManager {
  constructor(options: PopoverOptions);
  
  // Popover Operations
  show(target: Element, content: PopoverContent): Popover;
  hide(id: string): Promise<void>;
  
  // Position Management
  updatePosition(id: string): void;
  updateAll(): void;
}
```

### Popover Positioning

```typescript
interface PositionOptions {
  strategy?: PositionStrategy;
  fallback?: PopoverPlacement[];
  boundary?: Element;
}

class PopoverPosition {
  constructor(options: PositionOptions);
  
  // Position Operations
  compute(target: Element, popover: Element): Position;
  update(position: Position): void;
  
  // Boundary Management
  setBoundary(element: Element): void;
  checkBoundary(position: Position): boolean;
}
```

## Overlay System

### Overlay Manager

```typescript
interface OverlayOptions {
  backdrop?: boolean;
  keyboard?: boolean;
  scrollLock?: boolean;
}

class OverlayManager {
  constructor(options: OverlayOptions);
  
  // Overlay Operations
  create(config: OverlayConfig): Overlay;
  destroy(id: string): Promise<void>;
  
  // Stack Management
  push(overlay: Overlay): void;
  pop(): Overlay;
}
```

### Overlay Stack

```typescript
interface StackState {
  overlays: Overlay[];
  active?: Overlay;
  previous?: Overlay;
}

class OverlayStack {
  constructor(state?: StackState);
  
  // Stack Operations
  add(overlay: Overlay): void;
  remove(id: string): void;
  
  // State Management
  getState(): StackState;
  setState(state: StackState): void;
}
```

## Focus System

### Focus Manager

```typescript
interface FocusOptions {
  trap?: boolean;
  restore?: boolean;
  initialFocus?: string | Element;
}

class FocusManager {
  constructor(options: FocusOptions);
  
  // Focus Operations
  trap(container: Element): void;
  release(): void;
  
  // State Management
  save(): void;
  restore(): void;
}
```

### Focus Trap

```typescript
interface TrapOptions {
  escapeDeactivates?: boolean;
  returnFocusOnDeactivate?: boolean;
  preventScroll?: boolean;
}

class FocusTrap {
  constructor(options: TrapOptions);
  
  // Trap Operations
  activate(element: Element): void;
  deactivate(): void;
  
  // Focus Management
  pause(): void;
  unpause(): void;
}
```

## Implementation Notes

1. Dialog Design
   - Modal patterns
   - Drawer layouts
   - Popover positioning
   - Overlay stacking

2. Accessibility
   - Focus management
   - Keyboard navigation
   - ARIA roles
   - Screen readers

3. Performance
   - Stack management
   - Position calculations
   - Animation frames
   - Event delegation

4. Integration
   - Framework binding
   - Theme support
   - Animation system
   - Portal system

5. Best Practices
   - Dialog patterns
   - User experience
   - Error handling
   - Memory management

## Testing Requirements

1. Dialog Tests
   - Opening/closing
   - Stack management
   - Focus handling
   - Event propagation

2. Position Tests
   - Placement accuracy
   - Boundary detection
   - Resize handling
   - Scroll behavior

3. Accessibility Tests
   - Keyboard navigation
   - Screen readers
   - ARIA compliance
   - Focus trapping

4. Integration Tests
   - Framework binding
   - Theme support
   - Animation system
   - Portal system

## Usage Examples

### Modal Dialog

```typescript
const modals = new ModalManager({
  backdrop: true,
  keyboard: true,
  centered: true
});

// Show modal
const modal = modals.show({
  title: 'Confirmation',
  content: 'Are you sure you want to proceed?',
  actions: [
    {
      label: 'Cancel',
      onClick: () => modal.close()
    },
    {
      label: 'Confirm',
      onClick: () => handleConfirm()
    }
  ]
});

// Handle events
modal.onClose(() => {
  console.log('Modal closed');
});
```

### Drawer Panel

```typescript
const drawers = new DrawerManager({
  position: 'right',
  size: '300px',
  overlay: true
});

// Open drawer
const drawer = drawers.open({
  title: 'Settings',
  content: SettingsPanel,
  footer: {
    actions: [
      {
        label: 'Save',
        onClick: () => handleSave()
      }
    ]
  }
});

// Make resizable
const panel = new DrawerPanel({
  resizable: true,
  minSize: 200,
  maxSize: 500
});

panel.onResize((size) => {
  console.log('New size:', size);
});
```

### Popover Menu

```typescript
const popovers = new PopoverManager({
  placement: 'bottom-start',
  trigger: 'click',
  offset: 8
});

// Show popover
const button = document.querySelector('#menu-button');
const popover = popovers.show(button, {
  content: MenuContent,
  arrow: true,
  interactive: true
});

// Update position on scroll
window.addEventListener('scroll', () => {
  popover.updatePosition();
});
```

### Focus Management

```typescript
const focus = new FocusManager({
  trap: true,
  restore: true
});

// Trap focus in modal
const modal = document.querySelector('.modal');
focus.trap(modal);

// Handle cleanup
modal.addEventListener('hide', () => {
  focus.release();
  focus.restore();
});
```
