# @jadugar/ui Notification System

This document specifies the notification system implementation for the Jadugar UI package. The notification system provides comprehensive support for alerts, toasts, badges, and other notification types.

## Notification Architecture

### Notification Manager

```typescript
interface NotificationOptions {
  position?: NotificationPosition;
  maxCount?: number;
  duration?: number;
  plugins?: NotificationPlugin[];
}

class NotificationManager {
  constructor(options: NotificationOptions);
  
  // Notification Operations
  show(config: NotificationConfig): Notification;
  update(id: string, config: Partial<NotificationConfig>): void;
  
  // System Management
  register(plugin: NotificationPlugin): void;
  unregister(name: string): void;
  
  // Configuration
  configure(options: NotificationOptions): void;
  getConfig(): NotificationConfig;
}
```

## Toast System

### Toast Manager

```typescript
interface ToastOptions {
  position?: ToastPosition;
  animation?: ToastAnimation;
  theme?: ToastTheme;
}

class ToastManager {
  constructor(options: ToastOptions);
  
  // Toast Operations
  show(message: string, options?: ToastOptions): Toast;
  success(message: string, options?: ToastOptions): Toast;
  error(message: string, options?: ToastOptions): Toast;
  
  // Queue Management
  clear(): void;
  clearAll(): void;
}
```

### Toast Container

```typescript
interface ContainerOptions {
  maxToasts?: number;
  spacing?: number;
  offset?: Offset;
}

class ToastContainer {
  constructor(options: ContainerOptions);
  
  // Container Operations
  add(toast: Toast): void;
  remove(id: string): void;
  
  // Layout Management
  setPosition(position: ToastPosition): void;
  updateLayout(): void;
}
```

## Alert System

### Alert Manager

```typescript
interface AlertOptions {
  type?: AlertType;
  icon?: AlertIcon;
  actions?: AlertAction[];
}

class AlertManager {
  constructor(options: AlertOptions);
  
  // Alert Operations
  show(message: string, options?: AlertOptions): Alert;
  confirm(message: string, options?: AlertOptions): Promise<boolean>;
  prompt(message: string, options?: AlertOptions): Promise<string>;
  
  // Action Management
  addAction(action: AlertAction): void;
  removeAction(id: string): void;
}
```

### Alert Dialog

```typescript
interface DialogOptions {
  modal?: boolean;
  closeOnEscape?: boolean;
  closeOnOverlayClick?: boolean;
}

class AlertDialog {
  constructor(options: DialogOptions);
  
  // Dialog Operations
  open(content: AlertContent): void;
  close(result?: any): void;
  
  // Event Handling
  onOpen(handler: EventHandler): void;
  onClose(handler: EventHandler): void;
}
```

## Badge System

### Badge Manager

```typescript
interface BadgeOptions {
  position?: BadgePosition;
  color?: string;
  size?: BadgeSize;
}

class BadgeManager {
  constructor(options: BadgeOptions);
  
  // Badge Operations
  add(target: Element, content: BadgeContent): Badge;
  remove(target: Element): void;
  
  // State Management
  update(target: Element, content: BadgeContent): void;
  clear(target: Element): void;
}
```

### Badge Types

```typescript
interface CountBadge extends Badge {
  // Count Operations
  increment(value?: number): void;
  decrement(value?: number): void;
  
  // State Management
  getCount(): number;
  setCount(count: number): void;
}

interface StatusBadge extends Badge {
  // Status Operations
  setStatus(status: Status): void;
  pulse(duration?: number): void;
  
  // Style Management
  setColor(color: string): void;
  setSize(size: BadgeSize): void;
}
```

## Progress System

### Progress Manager

```typescript
interface ProgressOptions {
  type?: ProgressType;
  color?: string;
  size?: ProgressSize;
}

class ProgressManager {
  constructor(options: ProgressOptions);
  
  // Progress Operations
  start(options?: ProgressOptions): Progress;
  update(id: string, value: number): void;
  complete(id: string): void;
  
  // State Management
  pause(id: string): void;
  resume(id: string): void;
}
```

### Progress Types

```typescript
interface LinearProgress extends Progress {
  // Progress Operations
  setProgress(value: number): void;
  setBuffer(value: number): void;
  
  // Style Management
  setColor(color: string): void;
  setHeight(height: number): void;
}

interface CircularProgress extends Progress {
  // Progress Operations
  setProgress(value: number): void;
  rotate(degrees: number): void;
  
  // Style Management
  setSize(size: number): void;
  setThickness(thickness: number): void;
}
```

## Implementation Notes

1. Notification Design
   - Toast positioning
   - Alert styling
   - Badge placement
   - Progress indicators

2. Animation
   - Entry/exit animations
   - Progress animations
   - Badge transitions
   - Alert dialogs

3. Accessibility
   - ARIA roles
   - Keyboard navigation
   - Screen reader support
   - Focus management

4. Performance
   - Queue management
   - Animation throttling
   - DOM updates
   - Event handling

5. Best Practices
   - Message clarity
   - Timing
   - Placement
   - User experience

## Testing Requirements

1. Notification Tests
   - Display timing
   - Queue management
   - Update handling
   - Dismissal behavior

2. Animation Tests
   - Smoothness
   - Performance
   - Edge cases
   - Device support

3. Accessibility Tests
   - Screen readers
   - Keyboard usage
   - ARIA compliance
   - Focus handling

4. Integration Tests
   - Framework binding
   - Theme support
   - Plugin system
   - Event handling

## Usage Examples

### Toast Notifications

```typescript
const toasts = new ToastManager({
  position: 'top-right',
  animation: 'slide',
  theme: 'light'
});

// Show success toast
toasts.success('Operation completed successfully', {
  duration: 3000,
  action: {
    label: 'Undo',
    onClick: () => handleUndo()
  }
});

// Show error toast
toasts.error('Failed to save changes', {
  duration: 5000,
  dismissible: true
});
```

### Alert Dialogs

```typescript
const alerts = new AlertManager({
  type: 'default',
  icon: true
});

// Show confirmation dialog
const confirmed = await alerts.confirm('Delete this item?', {
  type: 'danger',
  actions: [
    { label: 'Cancel', value: false },
    { label: 'Delete', value: true }
  ]
});

if (confirmed) {
  // Handle deletion
}

// Show prompt dialog
const name = await alerts.prompt('Enter your name:', {
  placeholder: 'John Doe',
  validation: {
    required: true,
    minLength: 2
  }
});
```

### Progress Indicators

```typescript
const progress = new ProgressManager({
  type: 'linear',
  color: 'primary'
});

// Start upload progress
const uploadId = progress.start({
  type: 'linear',
  buffer: true
});

// Update progress
let value = 0;
const interval = setInterval(() => {
  value += 10;
  progress.update(uploadId, value);
  
  if (value >= 100) {
    clearInterval(interval);
    progress.complete(uploadId);
  }
}, 500);
```

### Badges

```typescript
const badges = new BadgeManager({
  position: 'top-right',
  size: 'small'
});

// Add count badge
const countBadge = badges.add(menuButton, {
  type: 'count',
  initial: 5,
  max: 99
});

// Update count
countBadge.increment();

// Add status badge
const statusBadge = badges.add(statusIcon, {
  type: 'status',
  status: 'online',
  pulse: true
});

// Update status
statusBadge.setStatus('away');
```
