# Logging Types

## File: packages/types/src/logging/index.ts

Generate a complete TypeScript file with the following specifications:

### Required Types and Interfaces

```typescript
// Log Levels and Categories
type LogLevel = 'debug' | 'info' | 'warn' | 'error' | 'fatal';
type LogCategory = 'system' | 'security' | 'performance' | 'business' | 'audit';

// Core Log Types
interface LogEntry {
    id: string;
    timestamp: Date;
    level: LogLevel;
    category: LogCategory;
    message: string;
    context: LogContext;
    metadata: LogMetadata;
    error?: LogError;
}

interface LogContext {
    requestId?: string;
    userId?: string;
    sessionId?: string;
    traceId?: string;
    source: string;
    environment: string;
}

interface LogMetadata {
    component: string;
    function: string;
    file: string;
    line: number;
    version: string;
    tags: string[];
    custom?: Record<string, any>;
}

interface LogError {
    name: string;
    message: string;
    stack?: string;
    code?: string;
    details?: Record<string, any>;
    cause?: Error;
}

// Logger Configuration
interface LoggerConfig {
    minLevel: LogLevel;
    enabled: boolean;
    transports: LogTransport[];
    formatters: LogFormatter[];
    filters: LogFilter[];
    metadata: Record<string, any>;
}

interface LogTransport {
    type: TransportType;
    config: TransportConfig;
    formatter?: LogFormatter;
    filter?: LogFilter;
}

type TransportType = 'console' | 'file' | 'http' | 'elasticsearch' | 'custom';

interface TransportConfig {
    // Console Transport
    colors?: boolean;
    prettyPrint?: boolean;

    // File Transport
    filename?: string;
    maxSize?: string;
    maxFiles?: number;
    compress?: boolean;

    // HTTP Transport
    endpoint?: string;
    headers?: Record<string, string>;
    batchSize?: number;
    retryConfig?: RetryConfig;

    // Elasticsearch Transport
    nodes?: string[];
    index?: string;
    auth?: {
        username: string;
        password: string;
    };

    // Custom Transport
    options?: Record<string, any>;
}

interface RetryConfig {
    maxAttempts: number;
    initialDelay: number;
    maxDelay: number;
    backoff: number;
}

// Log Formatting
interface LogFormatter {
    format(entry: LogEntry): string | object;
    contentType: string;
}

interface JsonFormatter extends LogFormatter {
    spacing?: number;
    replacer?: (key: string, value: any) => any;
}

interface TextFormatter extends LogFormatter {
    template: string;
    colors?: boolean;
    timestamp?: string;
}

// Log Filtering
interface LogFilter {
    shouldLog(entry: LogEntry): boolean;
}

interface LevelFilter extends LogFilter {
    minLevel: LogLevel;
    maxLevel?: LogLevel;
}

interface CategoryFilter extends LogFilter {
    include?: LogCategory[];
    exclude?: LogCategory[];
}

interface MetadataFilter extends LogFilter {
    key: string;
    value: any;
    operator: 'equals' | 'contains' | 'startsWith' | 'endsWith' | 'regex';
}

// Log Aggregation
interface LogAggregator {
    aggregate(entries: LogEntry[]): LogAggregation;
}

interface LogAggregation {
    timeRange: {
        start: Date;
        end: Date;
    };
    totalEntries: number;
    byLevel: Record<LogLevel, number>;
    byCategory: Record<LogCategory, number>;
    topErrors: LogError[];
    patterns: LogPattern[];
}

interface LogPattern {
    pattern: string;
    count: number;
    examples: LogEntry[];
    firstSeen: Date;
    lastSeen: Date;
}
```

### Required Functions

```typescript
// Type Guards
function isLogLevel(value: string): value is LogLevel;
function isLogCategory(value: string): value is LogCategory;
function isTransportType(value: string): value is TransportType;

// Creation Functions
function createLogEntry(level: LogLevel, message: string, options?: Partial<LogEntry>): LogEntry;
function createLogContext(source: string, environment: string): LogContext;
function createLogError(error: Error): LogError;

// Validation Functions
function validateLogEntry(entry: LogEntry): ValidationResult;
function validateLoggerConfig(config: LoggerConfig): ValidationResult;
function validateTransportConfig(type: TransportType, config: TransportConfig): ValidationResult;

// Utility Functions
function formatLogEntry(entry: LogEntry, formatter: LogFormatter): string | object;
function filterLogEntry(entry: LogEntry, filter: LogFilter): boolean;
function aggregateLogs(entries: LogEntry[], options?: AggregationOptions): LogAggregation;
function maskSensitiveData(entry: LogEntry, fields: string[]): LogEntry;
```

### Required Exports
```typescript
export {
    LogLevel,
    LogCategory,
    LogEntry,
    LogContext,
    LogMetadata,
    LogError,
    LoggerConfig,
    LogTransport,
    TransportType,
    TransportConfig,
    RetryConfig,
    LogFormatter,
    JsonFormatter,
    TextFormatter,
    LogFilter,
    LevelFilter,
    CategoryFilter,
    MetadataFilter,
    LogAggregator,
    LogAggregation,
    LogPattern,
    isLogLevel,
    isLogCategory,
    isTransportType,
    createLogEntry,
    createLogContext,
    createLogError,
    validateLogEntry,
    validateLoggerConfig,
    validateTransportConfig,
    formatLogEntry,
    filterLogEntry,
    aggregateLogs,
    maskSensitiveData,
};
```

### Additional Requirements
1. All interfaces must have JSDoc documentation
2. Include proper type assertions
3. Add proper validation logic
4. Include proper error handling
5. Add proper null checks
6. Include proper date handling
7. Add proper log formatting
8. Include log filtering logic
9. Add log aggregation utilities
10. Include sensitive data masking
