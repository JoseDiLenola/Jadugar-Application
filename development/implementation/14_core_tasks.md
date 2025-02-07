# @jadugar/core Task Management Layer

This document specifies the task management layer implementation for the Jadugar project. The task management layer provides a robust system for handling background jobs, scheduled tasks, and distributed processing.

## Task Architecture

### Task Manager

```typescript
interface TaskOptions {
  scheduler?: SchedulerOptions;
  worker?: WorkerOptions;
  storage?: StorageOptions;
  monitoring?: MonitoringOptions;
}

class TaskManager {
  constructor(options: TaskOptions);
  
  // Task Operations
  async schedule(
    task: Task,
    options?: ScheduleOptions
  ): Promise<string>;
  async cancel(taskId: string): Promise<void>;
  async pause(taskId: string): Promise<void>;
  async resume(taskId: string): Promise<void>;
  
  // Batch Operations
  async scheduleBatch(
    tasks: Task[],
    options?: BatchOptions
  ): Promise<string[]>;
  async cancelBatch(taskIds: string[]): Promise<void>;
  
  // Task Management
  async getTask(taskId: string): Promise<TaskInfo>;
  async listTasks(filter?: TaskFilter): Promise<TaskInfo[]>;
  async purgeCompleted(age?: number): Promise<void>;
  
  // Worker Management
  async startWorkers(count?: number): Promise<void>;
  async stopWorkers(): Promise<void>;
  async scaleWorkers(count: number): Promise<void>;
}
```

### Task Definition

```typescript
interface Task {
  name: string;
  handler: TaskHandler;
  payload?: unknown;
  options?: TaskOptions;
  retryStrategy?: RetryStrategy;
  timeout?: number;
}

interface TaskInfo {
  id: string;
  name: string;
  status: TaskStatus;
  progress?: number;
  result?: unknown;
  error?: Error;
  attempts: number;
  timing: TaskTiming;
  metadata: TaskMetadata;
}

type TaskStatus =
  | 'pending'
  | 'scheduled'
  | 'running'
  | 'completed'
  | 'failed'
  | 'cancelled'
  | 'paused';

interface TaskTiming {
  createdAt: number;
  scheduledAt?: number;
  startedAt?: number;
  completedAt?: number;
  nextRunAt?: number;
}
```

## Task Scheduling

### Scheduler

```typescript
interface SchedulerOptions {
  type: 'cron' | 'interval' | 'date';
  pattern?: string;
  interval?: number;
  date?: Date;
  timezone?: string;
}

class TaskScheduler {
  constructor(options?: SchedulerOptions);
  
  // Schedule Management
  schedule(task: Task, options: ScheduleOptions): Promise<string>;
  reschedule(taskId: string, options: ScheduleOptions): Promise<void>;
  unschedule(taskId: string): Promise<void>;
  
  // Schedule Information
  getNextRun(taskId: string): Promise<Date>;
  listScheduled(): Promise<ScheduleInfo[]>;
  
  // Schedule Operations
  pause(): Promise<void>;
  resume(): Promise<void>;
  clear(): Promise<void>;
}
```

### Cron Scheduling

```typescript
interface CronOptions extends SchedulerOptions {
  type: 'cron';
  pattern: string;
  timezone?: string;
}

class CronScheduler extends TaskScheduler {
  constructor(options: CronOptions);
  
  // Cron Management
  validatePattern(pattern: string): boolean;
  getNextOccurrence(pattern: string): Date;
  
  // Schedule Operations
  addJob(pattern: string, task: Task): Promise<string>;
  removeJob(jobId: string): Promise<void>;
}
```

## Task Processing

### Worker Pool

```typescript
interface WorkerOptions {
  concurrency: number;
  maxMemory?: number;
  idleTimeout?: number;
  warmup?: boolean;
}

class WorkerPool {
  constructor(options: WorkerOptions);
  
  // Worker Management
  async start(): Promise<void>;
  async stop(): Promise<void>;
  async restart(): Promise<void>;
  
  // Task Processing
  async process(task: Task): Promise<TaskResult>;
  
  // Pool Management
  async scale(count: number): Promise<void>;
  getStatus(): WorkerStatus;
  getMetrics(): WorkerMetrics;
}
```

### Task Worker

```typescript
interface WorkerConfig {
  id: string;
  maxTasks?: number;
  timeout?: number;
  isolate?: boolean;
}

class TaskWorker {
  constructor(config: WorkerConfig);
  
  // Task Execution
  async execute(task: Task): Promise<TaskResult>;
  async abort(taskId: string): Promise<void>;
  
  // Worker Lifecycle
  async start(): Promise<void>;
  async stop(): Promise<void>;
  
  // Worker Status
  isIdle(): boolean;
  getLoad(): number;
  getMetrics(): WorkerMetrics;
}
```

## Task Storage

### Storage Interface

```typescript
interface TaskStorage {
  // Task Operations
  save(task: TaskInfo): Promise<void>;
  load(taskId: string): Promise<TaskInfo>;
  update(taskId: string, updates: Partial<TaskInfo>): Promise<void>;
  delete(taskId: string): Promise<void>;
  
  // Query Operations
  find(filter: TaskFilter): Promise<TaskInfo[]>;
  count(filter: TaskFilter): Promise<number>;
  
  // Maintenance
  cleanup(age: number): Promise<void>;
  vacuum(): Promise<void>;
}
```

### Storage Implementations

```typescript
class MemoryStorage implements TaskStorage {
  constructor(options?: MemoryStorageOptions);
  // Implementation of TaskStorage interface
}

class RedisStorage implements TaskStorage {
  constructor(options: RedisStorageOptions);
  // Implementation of TaskStorage interface
}

class DatabaseStorage implements TaskStorage {
  constructor(options: DatabaseStorageOptions);
  // Implementation of TaskStorage interface
}
```

## Task Monitoring

### Monitoring System

```typescript
interface MonitoringOptions {
  metrics?: MetricsOptions;
  events?: EventOptions;
  alerts?: AlertOptions;
}

class TaskMonitor {
  constructor(options: MonitoringOptions);
  
  // Metrics Collection
  recordMetric(name: string, value: number): void;
  getMetrics(): TaskMetrics;
  
  // Event Handling
  recordEvent(event: TaskEvent): void;
  getEvents(filter: EventFilter): TaskEvent[];
  
  // Alerting
  setAlert(alert: AlertConfig): void;
  checkAlerts(): Promise<Alert[]>;
}
```

### Task Events

```typescript
interface TaskEvent {
  type: TaskEventType;
  taskId: string;
  timestamp: number;
  details: unknown;
}

class EventEmitter {
  constructor(options?: EventEmitterOptions);
  
  // Event Management
  emit(event: TaskEvent): void;
  on(type: TaskEventType, handler: EventHandler): void;
  off(type: TaskEventType, handler: EventHandler): void;
  
  // Event History
  getHistory(filter: EventFilter): TaskEvent[];
  clearHistory(): void;
}
```

## Task Patterns

### Task Chain

```typescript
interface ChainOptions {
  stopOnFailure?: boolean;
  parallel?: boolean;
  maxConcurrency?: number;
}

class TaskChain {
  constructor(options?: ChainOptions);
  
  // Chain Building
  add(task: Task): this;
  addParallel(tasks: Task[]): this;
  addConditional(
    condition: ConditionFn,
    task: Task
  ): this;
  
  // Chain Execution
  execute(): Promise<ChainResult>;
  abort(): Promise<void>;
  
  // Chain Status
  getStatus(): ChainStatus;
  getProgress(): number;
}
```

### Task Group

```typescript
interface GroupOptions {
  concurrency?: number;
  completionPolicy?: CompletionPolicy;
  timeout?: number;
}

class TaskGroup {
  constructor(options?: GroupOptions);
  
  // Group Management
  add(task: Task): this;
  remove(taskId: string): this;
  
  // Group Execution
  execute(): Promise<GroupResult>;
  abort(): Promise<void>;
  
  // Group Status
  getStatus(): GroupStatus;
  getProgress(): number;
}
```

## Implementation Notes

1. Task Configuration
   - Schedule types
   - Worker settings
   - Storage options
   - Monitoring setup

2. Performance Optimization
   - Worker pooling
   - Task batching
   - Resource management
   - Memory limits

3. Reliability
   - Task persistence
   - Error handling
   - Recovery strategies
   - Task isolation

4. Monitoring
   - Task progress
   - Worker health
   - Resource usage
   - Error tracking

5. Security
   - Task validation
   - Worker isolation
   - Resource limits
   - Access control

## Testing Requirements

1. Scheduler Tests
   - Schedule types
   - Task timing
   - Timezone handling
   - Concurrency

2. Worker Tests
   - Task execution
   - Resource usage
   - Error handling
   - Worker lifecycle

3. Storage Tests
   - Data persistence
   - Query performance
   - Concurrent access
   - Data cleanup

4. Integration Tests
   - End-to-end flows
   - Error scenarios
   - Performance
   - Scalability

## Usage Examples

### Basic Task Scheduling

```typescript
const taskManager = new TaskManager({
  scheduler: { type: 'interval' },
  worker: { concurrency: 2 }
});

// Schedule a task
const taskId = await taskManager.schedule({
  name: 'sendEmail',
  handler: async (payload) => {
    await sendEmail(payload);
  },
  payload: {
    to: 'user@example.com',
    subject: 'Welcome'
  }
});
```

### Cron Task

```typescript
const scheduler = new CronScheduler({
  timezone: 'UTC'
});

await scheduler.schedule({
  name: 'dailyReport',
  handler: async () => {
    await generateReport();
  }
}, {
  type: 'cron',
  pattern: '0 0 * * *' // Daily at midnight
});
```

### Task Chain

```typescript
const chain = new TaskChain({
  stopOnFailure: true
});

chain
  .add({
    name: 'processUpload',
    handler: processUpload
  })
  .add({
    name: 'generateThumbnail',
    handler: generateThumbnail
  })
  .add({
    name: 'notifyUser',
    handler: notifyUser
  });

await chain.execute();
```

### Task Group

```typescript
const group = new TaskGroup({
  concurrency: 3
});

const files = ['file1.jpg', 'file2.jpg', 'file3.jpg'];

for (const file of files) {
  group.add({
    name: 'processImage',
    handler: async () => {
      await processImage(file);
    }
  });
}

await group.execute();
```
