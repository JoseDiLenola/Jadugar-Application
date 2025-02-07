# @jadugar/core Logging Layer

This document specifies the logging layer implementation for the Jadugar project. The logging layer provides comprehensive logging, monitoring, and observability capabilities across the entire application.

## Logging Architecture

### Logger Manager

```typescript
interface LoggerOptions {
  level?: LogLevel;
  format?: LogFormat;
  transports?: Transport[];
  metadata?: LogMetadata;
  sampling?: SamplingOptions;
}

class LoggerManager {
  constructor(options: LoggerOptions);
  
  // Logger Operations
  getLogger(name: string): Logger;
  setLevel(level: LogLevel): void;
  addTransport(transport: Transport): void;
  removeTransport(name: string): void;
  
  // Configuration
  configure(options: LoggerOptions): void;
  getConfig(): LoggerOptions;
  
  // Utility Methods
  flush(): Promise<void>;
  close(): Promise<void>;
}
```

### Logger Interface

```typescript
interface Logger {
  // Log Methods
  trace(message: string, ...args: any[]): void;
  debug(message: string, ...args: any[]): void;
  info(message: string, ...args: any[]): void;
  warn(message: string, ...args: any[]): void;
  error(message: string, ...args: any[]): void;
  fatal(message: string, ...args: any[]): void;
  
  // Context Methods
  child(metadata: LogMetadata): Logger;
  withContext(context: Context): Logger;
  
  // Utility Methods
  isLevelEnabled(level: LogLevel): boolean;
  flush(): Promise<void>;
}
```

## Log Formatting

### Log Format

```typescript
interface LogFormat {
  // Format Configuration
  type: 'json' | 'text' | 'pretty';
  timestamp?: TimestampFormat;
  colorize?: boolean;
  
  // Custom Formatting
  template?: string;
  transform?: (info: LogEntry) => LogEntry;
  
  // Metadata Handling
  includeMeta?: string[];
  excludeMeta?: string[];
}

interface LogEntry {
  level: LogLevel;
  message: string;
  timestamp: string;
  context?: Context;
  metadata?: LogMetadata;
  error?: Error;
  [key: string]: any;
}
```

### Formatters

```typescript
class JsonFormatter implements LogFormatter {
  constructor(options?: JsonFormatterOptions);
  
  // Format Methods
  format(entry: LogEntry): string;
  parse(log: string): LogEntry;
  
  // Configuration
  configure(options: JsonFormatterOptions): void;
}

class PrettyFormatter implements LogFormatter {
  constructor(options?: PrettyFormatterOptions);
  
  // Format Methods
  format(entry: LogEntry): string;
  colorize(text: string, level: LogLevel): string;
  
  // Configuration
  configure(options: PrettyFormatterOptions): void;
}
```

## Log Transport

### Transport Interface

```typescript
interface Transport {
  name: string;
  level: LogLevel;
  
  // Transport Operations
  log(entry: LogEntry): Promise<void>;
  flush(): Promise<void>;
  close(): Promise<void>;
  
  // Configuration
  configure(options: TransportOptions): void;
  isReady(): boolean;
}
```

### Transport Implementations

```typescript
class ConsoleTransport implements Transport {
  constructor(options?: ConsoleTransportOptions);
  // Implementation of Transport interface
}

class FileTransport implements Transport {
  constructor(options: FileTransportOptions);
  // Implementation of Transport interface
}

class NetworkTransport implements Transport {
  constructor(options: NetworkTransportOptions);
  // Implementation of Transport interface
}
```

## Context Management

### Context Interface

```typescript
interface Context {
  // Context Data
  id: string;
  parent?: string;
  metadata: ContextMetadata;
  
  // Context Operations
  set(key: string, value: any): void;
  get(key: string): any;
  delete(key: string): void;
  
  // Context Chain
  createChild(): Context;
  getRoot(): Context;
}
```

### Context Manager

```typescript
class ContextManager {
  constructor(options?: ContextOptions);
  
  // Context Operations
  createContext(): Context;
  getContext(id: string): Context;
  
  // Async Context
  bind<T>(fn: (...args: any[]) => T, context: Context): (...args: any[]) => T;
  run<T>(context: Context, fn: () => T): T;
  
  // Utility Methods
  getCurrentContext(): Context;
  getRootContext(): Context;
}
```

## Error Handling

### Error Logger

```typescript
class ErrorLogger {
  constructor(options?: ErrorLoggerOptions);
  
  // Error Logging
  logError(error: Error, context?: Context): void;
  logWarning(warning: Warning, context?: Context): void;
  
  // Error Processing
  processStack(error: Error): ProcessedStack;
  extractContext(error: Error): ErrorContext;
  
  // Error Aggregation
  groupSimilarErrors(): ErrorGroup[];
  getErrorStats(): ErrorStats;
}
```

### Error Processing

```typescript
interface ErrorProcessor {
  // Processing Methods
  process(error: Error): ProcessedError;
  enrich(error: Error): EnrichedError;
  
  // Stack Processing
  parseStack(stack: string): StackFrame[];
  sourceMap(frame: StackFrame): SourceLocation;
  
  // Error Classification
  classify(error: Error): ErrorClass;
  prioritize(error: Error): ErrorPriority;
}
```

## Monitoring Integration

### Metrics Collection

```typescript
interface MetricsCollector {
  // Metric Recording
  increment(name: string, value?: number): void;
  gauge(name: string, value: number): void;
  histogram(name: string, value: number): void;
  
  // Metric Management
  register(metric: MetricDefinition): void;
  unregister(name: string): void;
  
  // Metric Retrieval
  getMetric(name: string): Metric;
  getAllMetrics(): Metric[];
}
```

### Tracing Integration

```typescript
interface TracingIntegration {
  // Trace Operations
  startSpan(name: string, options?: SpanOptions): Span;
  getCurrentSpan(): Span;
  
  // Context Propagation
  inject(context: Context, carrier: unknown): void;
  extract(carrier: unknown): Context;
  
  // Utility Methods
  addEvent(name: string, attributes?: Record<string, any>): void;
  setStatus(status: SpanStatus): void;
}
```

## Implementation Notes

1. Configuration
   - Log levels
   - Format options
   - Transport setup
   - Context management

2. Performance
   - Log sampling
   - Async logging
   - Buffer management
   - Transport batching

3. Reliability
   - Error handling
   - Transport failover
   - Buffer overflow
   - Graceful shutdown

4. Integration
   - OpenTelemetry
   - Prometheus
   - ELK Stack
   - Cloud logging

5. Security
   - PII filtering
   - Log sanitization
   - Access control
   - Encryption

## Testing Requirements

1. Logger Tests
   - Log levels
   - Format options
   - Context propagation
   - Error handling

2. Transport Tests
   - Write operations
   - Failover handling
   - Performance
   - Reliability

3. Integration Tests
   - Monitoring systems
   - Metric collection
   - Trace correlation
   - Error tracking

4. Performance Tests
   - Throughput
   - Latency
   - Resource usage
   - Scalability

## Usage Examples

### Basic Logging

```typescript
const logger = LoggerManager.getLogger('app');

logger.info('Application started', {
  version: '1.0.0',
  environment: 'production'
});

logger.error('Operation failed', {
  operation: 'data_sync',
  error: new Error('Connection timeout')
});
```

### Contextual Logging

```typescript
const contextManager = new ContextManager();
const context = contextManager.createContext();

context.set('requestId', '123');
context.set('userId', 'user-456');

const logger = LoggerManager.getLogger('api')
  .withContext(context);

logger.info('Processing request', {
  endpoint: '/api/data',
  method: 'POST'
});
```

### Error Logging

```typescript
const errorLogger = new ErrorLogger();

try {
  throw new Error('Database connection failed');
} catch (error) {
  errorLogger.logError(error, {
    component: 'database',
    operation: 'connect'
  });
}
```

### Metrics Recording

```typescript
const metrics = new MetricsCollector();

metrics.increment('api_requests_total');
metrics.gauge('active_connections', 42);
metrics.histogram('response_time', 123.45);
```
