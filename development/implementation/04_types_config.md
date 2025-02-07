# Configuration Types

## File: packages/types/src/config/index.ts

Generate a complete TypeScript file with the following specifications:

### Required Types and Interfaces

```typescript
// Environment Configuration
interface EnvironmentConfig {
    environment: Environment;
    debug: boolean;
    logLevel: LogLevel;
    server: ServerConfig;
    database: DatabaseConfig;
    auth: AuthConfig;
    cache: CacheConfig;
    monitoring: MonitoringConfig;
}

type Environment = 'development' | 'staging' | 'production' | 'test';
type LogLevel = 'debug' | 'info' | 'warn' | 'error';

// Server Configuration
interface ServerConfig {
    host: string;
    port: number;
    baseUrl: string;
    cors: CorsConfig;
    rateLimit: RateLimitConfig;
    compression: CompressionConfig;
    timeout: TimeoutConfig;
}

interface CorsConfig {
    enabled: boolean;
    origins: string[];
    methods: string[];
    headers: string[];
    credentials: boolean;
}

interface RateLimitConfig {
    enabled: boolean;
    windowMs: number;
    maxRequests: number;
    message: string;
}

interface CompressionConfig {
    enabled: boolean;
    level: number;
    threshold: number;
}

interface TimeoutConfig {
    server: number;
    api: number;
    socket: number;
}

// Database Configuration
interface DatabaseConfig {
    type: DatabaseType;
    host: string;
    port: number;
    name: string;
    user: string;
    password: string;
    ssl: boolean;
    pool: PoolConfig;
    migrations: MigrationConfig;
}

type DatabaseType = 'postgres' | 'mysql' | 'mongodb';

interface PoolConfig {
    min: number;
    max: number;
    idleTimeout: number;
}

interface MigrationConfig {
    directory: string;
    tableName: string;
    transactional: boolean;
}

// Authentication Configuration
interface AuthConfig {
    jwt: JwtConfig;
    session: SessionConfig;
    password: PasswordConfig;
    oauth: OAuthConfig;
}

interface JwtConfig {
    secret: string;
    expiresIn: string;
    refreshExpiresIn: string;
    algorithm: string;
}

interface SessionConfig {
    secret: string;
    name: string;
    resave: boolean;
    saveUninitialized: boolean;
    cookie: CookieConfig;
}

interface CookieConfig {
    secure: boolean;
    httpOnly: boolean;
    maxAge: number;
    domain: string;
    sameSite: 'strict' | 'lax' | 'none';
}

interface PasswordConfig {
    saltRounds: number;
    minLength: number;
    requireNumbers: boolean;
    requireSpecialChars: boolean;
    requireUppercase: boolean;
    requireLowercase: boolean;
}

interface OAuthConfig {
    google?: OAuthProviderConfig;
    github?: OAuthProviderConfig;
    facebook?: OAuthProviderConfig;
}

interface OAuthProviderConfig {
    enabled: boolean;
    clientId: string;
    clientSecret: string;
    callbackUrl: string;
    scope: string[];
}

// Cache Configuration
interface CacheConfig {
    type: CacheType;
    host: string;
    port: number;
    password?: string;
    ttl: number;
    prefix: string;
}

type CacheType = 'redis' | 'memcached' | 'memory';

// Monitoring Configuration
interface MonitoringConfig {
    metrics: MetricsConfig;
    tracing: TracingConfig;
    logging: LoggingConfig;
    alerting: AlertingConfig;
}

interface MetricsConfig {
    enabled: boolean;
    interval: number;
    prefix: string;
    tags: Record<string, string>;
}

interface TracingConfig {
    enabled: boolean;
    serviceName: string;
    sampleRate: number;
}

interface LoggingConfig {
    format: 'json' | 'text';
    destination: 'file' | 'console' | 'service';
    maxFiles: number;
    maxSize: string;
}

interface AlertingConfig {
    enabled: boolean;
    providers: AlertProvider[];
    thresholds: Record<string, number>;
}

interface AlertProvider {
    type: 'email' | 'slack' | 'webhook';
    config: Record<string, any>;
}
```

### Required Functions

```typescript
// Type Guards
function isEnvironment(value: string): value is Environment;
function isLogLevel(value: string): value is LogLevel;
function isDatabaseType(value: string): value is DatabaseType;
function isCacheType(value: string): value is CacheType;

// Validation Functions
function validateEnvironmentConfig(config: EnvironmentConfig): ValidationResult;
function validateServerConfig(config: ServerConfig): ValidationResult;
function validateDatabaseConfig(config: DatabaseConfig): ValidationResult;
function validateAuthConfig(config: AuthConfig): ValidationResult;
function validateCacheConfig(config: CacheConfig): ValidationResult;
function validateMonitoringConfig(config: MonitoringConfig): ValidationResult;

// Configuration Utilities
function createDefaultConfig(env: Environment): EnvironmentConfig;
function mergeConfigs(base: EnvironmentConfig, override: Partial<EnvironmentConfig>): EnvironmentConfig;
function validateConfig(config: EnvironmentConfig): ValidationResult;
function maskSensitiveData(config: EnvironmentConfig): EnvironmentConfig;
```

### Required Exports
```typescript
export {
    EnvironmentConfig,
    Environment,
    LogLevel,
    ServerConfig,
    CorsConfig,
    RateLimitConfig,
    CompressionConfig,
    TimeoutConfig,
    DatabaseConfig,
    DatabaseType,
    PoolConfig,
    MigrationConfig,
    AuthConfig,
    JwtConfig,
    SessionConfig,
    CookieConfig,
    PasswordConfig,
    OAuthConfig,
    OAuthProviderConfig,
    CacheConfig,
    CacheType,
    MonitoringConfig,
    MetricsConfig,
    TracingConfig,
    LoggingConfig,
    AlertingConfig,
    AlertProvider,
    isEnvironment,
    isLogLevel,
    isDatabaseType,
    isCacheType,
    validateEnvironmentConfig,
    validateServerConfig,
    validateDatabaseConfig,
    validateAuthConfig,
    validateCacheConfig,
    validateMonitoringConfig,
    createDefaultConfig,
    mergeConfigs,
    validateConfig,
    maskSensitiveData,
};
```

### Additional Requirements
1. All interfaces must have JSDoc documentation
2. Include proper type assertions
3. Add proper validation logic
4. Include proper error handling
5. Add proper null checks
6. Include sensitive data masking
7. Add configuration merging logic
8. Include environment-specific defaults
9. Add proper validation for all config options
10. Include proper type guards for all types
