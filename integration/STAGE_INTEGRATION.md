# Jadugar Stage Integration Guide

## Overview
This guide details how Build Observatory (Stage 1) and Application Lighthouse (Stage 2) integrate to provide a seamless application lifecycle management experience.

## Integration Architecture

### 1. Shared Components
```typescript
// Shared Types
interface JadugarContext {
  projectId: string;
  environment: string;
  version: string;
  timestamp: Date;
}

// Unified Event System
interface JadugarEvent {
  context: JadugarContext;
  type: 'build' | 'deploy' | 'monitor';
  data: BuildEvent | DeployEvent | MonitorEvent;
}

// Common Configuration
interface JadugarConfig {
  project: ProjectConfig;
  build: BuildConfig;
  monitor: MonitorConfig;
}
```

## Data Flow Integration

### 1. Build to Monitor Pipeline
```typescript
// Build Context Propagation
interface BuildContext {
  buildId: string;
  commit: string;
  branch: string;
  artifacts: ArtifactInfo[];
}

// Deployment Bridge
interface DeploymentBridge {
  // Triggered when build completes
  async onBuildComplete(build: Build): Promise<void> {
    // 1. Extract monitoring configuration
    const monitorConfig = extractMonitorConfig(build);
    
    // 2. Initialize monitoring
    await initializeMonitoring(build.id, monitorConfig);
    
    // 3. Link build to monitoring
    await linkBuildToMonitor(build.id);
  }
}

// Monitor Integration
interface MonitorIntegration {
  // Initialize monitoring with build context
  async initialize(context: BuildContext): Promise<void>;
  
  // Update monitoring based on build events
  async onBuildEvent(event: BuildEvent): Promise<void>;
}
```

### 2. Unified Event Pipeline
```typescript
// Event Processing
interface EventProcessor {
  // Process events from both systems
  async process(event: JadugarEvent): Promise<void> {
    switch (event.type) {
      case 'build':
        await processBuildEvent(event);
        break;
      case 'deploy':
        await processDeployEvent(event);
        break;
      case 'monitor':
        await processMonitorEvent(event);
        break;
    }
  }
}

// Event Correlation
interface EventCorrelator {
  // Correlate build and monitoring events
  async correlate(
    buildEvents: BuildEvent[],
    monitorEvents: MonitorEvent[]
  ): Promise<CorrelationResult>;
}
```

## API Integration

### 1. Unified API Layer
```typescript
// Unified API Routes
interface UnifiedAPI {
  // Get combined build and monitoring status
  GET /api/projects/:projectId/status
  
  // Get deployment history with monitoring data
  GET /api/projects/:projectId/deployments
  
  // Get build-monitor correlation data
  GET /api/projects/:projectId/correlation
}

// Response Types
interface UnifiedStatus {
  build: {
    status: BuildStatus;
    progress: number;
    metrics: BuildMetrics;
  };
  monitor: {
    health: HealthStatus;
    metrics: MonitorMetrics;
    alerts: Alert[];
  };
}
```

### 2. GraphQL Integration
```graphql
# Unified GraphQL Schema
type Project {
  id: ID!
  name: String!
  builds: [Build!]!
  monitoring: Monitoring!
  deployments: [Deployment!]!
}

type Build {
  id: ID!
  status: BuildStatus!
  monitoring: Monitoring
  deployments: [Deployment!]!
}

type Monitoring {
  health: Health!
  metrics: [Metric!]!
  alerts: [Alert!]!
  builds: [Build!]!
}
```

## Database Integration

### 1. Relationship Schema
```sql
-- Build-Monitor Relationship
CREATE TABLE build_monitor_links (
  id SERIAL PRIMARY KEY,
  build_id VARCHAR(50) REFERENCES builds(id),
  monitor_id VARCHAR(50) REFERENCES monitors(id),
  link_type VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Deployment Tracking
CREATE TABLE deployments (
  id SERIAL PRIMARY KEY,
  build_id VARCHAR(50) REFERENCES builds(id),
  environment VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL,
  started_at TIMESTAMP DEFAULT NOW(),
  completed_at TIMESTAMP,
  monitoring_config JSONB
);
```

### 2. Data Access Layer
```typescript
// Unified Repository
interface UnifiedRepository {
  // Get build with monitoring data
  async getBuildWithMonitoring(
    buildId: string
  ): Promise<BuildWithMonitoring>;
  
  // Get monitoring with build context
  async getMonitoringWithBuild(
    monitorId: string
  ): Promise<MonitoringWithBuild>;
  
  // Link build and monitoring
  async linkBuildMonitor(
    buildId: string,
    monitorId: string
  ): Promise<void>;
}
```

## UI Integration

### 1. Unified Dashboard
```typescript
// Dashboard Components
interface UnifiedDashboard {
  // Combined status view
  StatusView: {
    buildStatus: BuildStatus;
    monitorHealth: HealthStatus;
    deploymentStatus: DeploymentStatus;
  };
  
  // Timeline view
  TimelineView: {
    builds: BuildEvent[];
    deployments: DeploymentEvent[];
    monitors: MonitorEvent[];
  };
  
  // Analytics view
  AnalyticsView: {
    buildMetrics: BuildMetrics;
    monitorMetrics: MonitorMetrics;
    correlation: CorrelationData;
  };
}
```

### 2. Navigation Integration
```typescript
// Unified Navigation
interface UnifiedNavigation {
  // Context-aware navigation
  async navigateWithContext(
    context: NavigationContext
  ): Promise<void> {
    switch (context.type) {
      case 'build':
        await navigateToBuild(context);
        break;
      case 'monitor':
        await navigateToMonitor(context);
        break;
      case 'deployment':
        await navigateToDeployment(context);
        break;
    }
  }
}
```

## Configuration Integration

### 1. Unified Configuration
```yaml
# jadugar.config.yaml
project:
  id: string
  name: string
  
build:
  tracking:
    enabled: boolean
    plugins:
      - name: string
        config: object
        
monitor:
  enabled: boolean
  agents:
    - type: string
      config: object
  
integration:
  correlation:
    enabled: boolean
    rules:
      - name: string
        conditions: object
```

### 2. Configuration Management
```typescript
// Configuration Manager
interface ConfigManager {
  // Load unified configuration
  async loadConfig(): Promise<JadugarConfig>;
  
  // Validate configuration
  async validateConfig(
    config: JadugarConfig
  ): Promise<ValidationResult>;
  
  // Apply configuration
  async applyConfig(
    config: JadugarConfig
  ): Promise<void>;
}
```

## Security Integration

### 1. Unified Authentication
```typescript
// Authentication Service
interface AuthService {
  // Authenticate across services
  async authenticate(
    credentials: Credentials
  ): Promise<JadugarToken>;
  
  // Validate token
  async validateToken(
    token: JadugarToken
  ): Promise<ValidationResult>;
}

// Authorization
interface AuthorizationService {
  // Check permissions across services
  async checkPermission(
    token: JadugarToken,
    resource: string,
    action: string
  ): Promise<boolean>;
}
```

### 2. Audit Integration
```typescript
// Unified Audit
interface AuditService {
  // Log audit events
  async logAudit(event: AuditEvent): Promise<void>;
  
  // Get unified audit trail
  async getAuditTrail(
    filter: AuditFilter
  ): Promise<AuditTrail>;
}
```

## Testing Integration

### 1. Integration Tests
```typescript
// Integration Test Suite
interface IntegrationTests {
  // Test build-monitor flow
  async testBuildMonitorFlow(): Promise<void> {
    // 1. Start build
    const build = await startBuild();
    
    // 2. Complete build
    await completeBuild(build.id);
    
    // 3. Verify monitoring
    await verifyMonitoring(build.id);
  }
}
```

### 2. End-to-End Tests
```typescript
// E2E Test Suite
interface E2ETests {
  // Test complete lifecycle
  async testLifecycle(): Promise<void> {
    // 1. Build phase
    const build = await runBuildPhase();
    
    // 2. Deploy phase
    const deployment = await runDeployPhase(build);
    
    // 3. Monitor phase
    await runMonitorPhase(deployment);
  }
}
```

## Deployment Integration

### 1. Unified Deployment
```typescript
// Deployment Service
interface DeploymentService {
  // Deploy with monitoring
  async deploy(
    build: Build,
    config: DeployConfig
  ): Promise<Deployment> {
    // 1. Pre-deployment checks
    await runPreDeployChecks(build);
    
    // 2. Deploy application
    const deployment = await deployApplication(build);
    
    // 3. Initialize monitoring
    await initializeMonitoring(deployment);
    
    return deployment;
  }
}
```

### 2. Rollback Integration
```typescript
// Rollback Service
interface RollbackService {
  // Unified rollback
  async rollback(
    deployment: Deployment
  ): Promise<void> {
    // 1. Stop monitoring
    await stopMonitoring(deployment);
    
    // 2. Rollback deployment
    await rollbackDeployment(deployment);
    
    // 3. Restore monitoring
    await restoreMonitoring(deployment);
  }
}
```

## Metrics Integration

### 1. Unified Metrics
```typescript
// Metrics Service
interface MetricsService {
  // Collect unified metrics
  async collectMetrics(): Promise<UnifiedMetrics> {
    const buildMetrics = await collectBuildMetrics();
    const monitorMetrics = await collectMonitorMetrics();
    return correlateMetrics(buildMetrics, monitorMetrics);
  }
}
```

### 2. Analytics Integration
```typescript
// Analytics Service
interface AnalyticsService {
  // Generate unified analytics
  async generateAnalytics(
    timeRange: TimeRange
  ): Promise<UnifiedAnalytics> {
    const buildAnalytics = await analyzeBuildData(timeRange);
    const monitorAnalytics = await analyzeMonitorData(timeRange);
    return correlateAnalytics(buildAnalytics, monitorAnalytics);
  }
}
```

## Alert Integration

### 1. Unified Alerts
```typescript
// Alert Service
interface AlertService {
  // Process unified alerts
  async processAlert(alert: Alert): Promise<void> {
    if (alert.type === 'build') {
      await processBuildAlert(alert);
    } else if (alert.type === 'monitor') {
      await processMonitorAlert(alert);
    }
    
    await correlateAlerts(alert);
  }
}
```

### 2. Notification Integration
```typescript
// Notification Service
interface NotificationService {
  // Send unified notifications
  async notify(
    event: JadugarEvent
  ): Promise<void> {
    const context = buildNotificationContext(event);
    await sendNotification(context);
  }
}
```
