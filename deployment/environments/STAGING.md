# Jadugar Staging Environment Guide

## Technology Stack

### Infrastructure Technologies
```yaml
cloud:
  provider: AWS
  region: us-east-1
  services:
    - EKS (Kubernetes)
    - RDS (PostgreSQL)
    - ElastiCache (Redis)
    - S3 (Storage)
    - CloudFront (CDN)

container:
  orchestration: Kubernetes 1.28
  runtime: containerd
  registry: Amazon ECR

networking:
  cdn: CloudFront
  ssl: Let's Encrypt
  dns: Route53
```

### CI/CD Technologies
```yaml
pipeline:
  platform: GitHub Actions
  testing: Jest, Playwright
  linting: ESLint, Prettier
  security: Snyk, OWASP ZAP
  quality: SonarCloud

artifacts:
  registry: Amazon ECR
  storage: S3
  versioning: Semantic Versioning

deployment:
  tool: ArgoCD 2.8
  strategy: Blue/Green
  rollback: Automated
```

### Monitoring Technologies
```yaml
metrics:
  collector: Prometheus
  visualization: Grafana
  alerting: AlertManager

logging:
  collector: Fluentd
  storage: Elasticsearch
  visualization: Kibana

tracing:
  system: OpenTelemetry
  visualization: Jaeger
```

## Infrastructure Setup

### 1. Kubernetes Cluster
```yaml
# eks-cluster.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: jadugar-staging
  region: us-east-1
  version: "1.28"

managedNodeGroups:
  - name: general
    instanceType: t3.large
    minSize: 2
    maxSize: 4
    desiredCapacity: 2
    volumeSize: 100
    
  - name: builds
    instanceType: c5.xlarge
    minSize: 2
    maxSize: 6
    desiredCapacity: 2
    volumeSize: 100
    labels:
      role: build
    taints:
      - key: dedicated
        value: build
        effect: NoSchedule
```

### 2. Database Setup
```yaml
# rds-instance.yaml
apiVersion: rds.aws.crossplane.io/v1beta1
kind: RDSInstance
metadata:
  name: jadugar-staging-db
spec:
  forProvider:
    region: us-east-1
    dbInstanceClass: db.t3.large
    engine: postgres
    engineVersion: "15.4"
    masterUsername: jadugar_staging
    allocatedStorage: 100
    publiclyAccessible: false
    vpcSecurityGroupIds:
      - sg-staging-db
```

### 3. Cache Setup
```yaml
# elasticache.yaml
apiVersion: cache.aws.crossplane.io/v1beta1
kind: ReplicationGroup
metadata:
  name: jadugar-staging-cache
spec:
  forProvider:
    region: us-east-1
    engine: redis
    engineVersion: "7.0"
    cacheNodeType: cache.t3.medium
    numCacheNodes: 2
    autoMinorVersionUpgrade: true
```

## CI/CD Pipeline

### 1. Build Pipeline
```yaml
# .github/workflows/staging.yml
name: Staging Pipeline

on:
  push:
    branches: [ staging ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run test
      - run: npm run test:e2e
      
  security:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: snyk/actions/node@master
      - uses: zaproxy/action-baseline@v0.9.0
      
  quality:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: SonarSource/sonarcloud-github-action@v2
        
  build:
    needs: [security, quality]
    runs-on: ubuntu-latest
    steps:
      - uses: aws-actions/amazon-ecr-login@v2
      - run: |
          docker build -t jadugar-staging .
          docker push jadugar-staging:latest
```

### 2. Deployment Pipeline
```yaml
# argocd/staging.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: jadugar-staging
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/jadugar.git
    targetRevision: HEAD
    path: k8s/staging
  destination:
    server: https://kubernetes.default.svc
    namespace: jadugar-staging
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

## Monitoring Setup

### 1. Metrics Configuration
```yaml
# prometheus-values.yaml
prometheus:
  prometheusSpec:
    retention: 15d
    resources:
      requests:
        cpu: 500m
        memory: 2Gi
      limits:
        cpu: 1
        memory: 4Gi
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: gp2
          resources:
            requests:
              storage: 50Gi

alertmanager:
  config:
    global:
      resolve_timeout: 5m
    route:
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 12h
      receiver: 'slack'
    receivers:
    - name: 'slack'
      slack_configs:
      - channel: '#staging-alerts'
```

### 2. Logging Configuration
```yaml
# elastic-stack-values.yaml
elasticsearch:
  replicas: 2
  resources:
    requests:
      cpu: 1
      memory: 2Gi
    limits:
      cpu: 2
      memory: 4Gi
  volumeClaimTemplate:
    resources:
      requests:
        storage: 100Gi

kibana:
  resources:
    requests:
      cpu: 500m
      memory: 1Gi
    limits:
      cpu: 1
      memory: 2Gi

fluentd:
  resources:
    requests:
      cpu: 200m
      memory: 512Mi
    limits:
      cpu: 500m
      memory: 1Gi
```

## Performance Testing

### 1. Load Testing Configuration
```typescript
// k6-config.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '5m', target: 100 },
    { duration: '10m', target: 100 },
    { duration: '5m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  const response = http.get('https://staging.jadugar.example.com/api/health');
  check(response, {
    'status is 200': (r) => r.status === 200,
  });
  sleep(1);
}
```

### 2. Stress Testing Configuration
```typescript
// artillery-config.yml
config:
  target: "https://staging.jadugar.example.com"
  phases:
    - duration: 300
      arrivalRate: 5
      rampTo: 50
    - duration: 600
      arrivalRate: 50
    - duration: 300
      arrivalRate: 50
      rampTo: 5

scenarios:
  - name: "Build API Flow"
    flow:
      - post:
          url: "/api/builds"
          json:
            projectId: "test-project"
      - think: 5
      - get:
          url: "/api/builds/{{ buildId }}"
```

## Security Testing

### 1. OWASP ZAP Configuration
```yaml
# zap-config.yaml
env:
  contexts:
    - name: "Staging"
      urls: ["https://staging.jadugar.example.com"]
      includePaths: ["https://staging.jadugar.example.com.*"]
      excludePaths: []
      authentication:
        method: "script"
        script: "auth.js"
        parameters:
          username: "test@example.com"
          password: "test123"

  rules:
    - id: 10020
      threshold: "Medium"
    - id: 10021
      threshold: "Medium"
```

### 2. Snyk Configuration
```yaml
# .snyk
version: v1.25.0
ignore:
  'npm:moment:20170905':
    - moment:
        reason: 'No direct usage of affected features'
        expires: '2024-12-31T00:00:00.000Z'

exclude:
  global:
    - node_modules
    - dist
    - build
```

## Integration Testing

### 1. API Testing
```typescript
// integration-tests/api.test.ts
import { test, expect } from '@playwright/test';

test.describe('Staging API Tests', () => {
  test('build workflow', async ({ request }) => {
    // Create build
    const createResponse = await request.post('/api/builds', {
      data: {
        projectId: 'test-project'
      }
    });
    expect(createResponse.ok()).toBeTruthy();
    
    // Get build status
    const buildId = createResponse.json().id;
    const statusResponse = await request.get(`/api/builds/${buildId}`);
    expect(statusResponse.ok()).toBeTruthy();
  });
});
```

### 2. E2E Testing
```typescript
// integration-tests/e2e.test.ts
import { test, expect } from '@playwright/test';

test.describe('Staging E2E Tests', () => {
  test('complete build flow', async ({ page }) => {
    await page.goto('https://staging.jadugar.example.com');
    
    // Login
    await page.fill('[data-testid="email"]', 'test@example.com');
    await page.fill('[data-testid="password"]', 'test123');
    await page.click('[data-testid="login-button"]');
    
    // Create build
    await page.click('[data-testid="new-build"]');
    await expect(page.locator('[data-testid="build-status"]'))
      .toHaveText('Running');
  });
});
```

## Configuration Management

### 1. Environment Configuration
```yaml
# config/staging.yaml
api:
  url: https://api.staging.jadugar.example.com
  version: v1
  timeout: 30000

database:
  host: jadugar-staging-db.cluster-xyz.region.rds.amazonaws.com
  port: 5432
  ssl: true

cache:
  host: jadugar-staging-cache.xyz.region.cache.amazonaws.com
  port: 6379
  tls: true

monitoring:
  metrics:
    enabled: true
    endpoint: http://prometheus:9090
  logging:
    enabled: true
    level: info
```

### 2. Feature Flags
```typescript
// feature-flags.ts
export const featureFlags = {
  staging: {
    realTimeBuildUpdates: true,
    advancedAnalytics: true,
    autoScaling: true,
    newBuildSystem: false  // staged rollout
  }
};
```

## Rollback Procedures

### 1. Application Rollback
```bash
#!/bin/bash

# Rollback deployment
rollback_deployment() {
  # Get previous version
  PREV_VERSION=$(kubectl get deployment jadugar-api \
    -n jadugar-staging \
    -o=jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision-history}' \
    | tr ',' '\n' | tail -n 2 | head -n 1)
    
  # Rollback
  kubectl rollout undo deployment jadugar-api \
    -n jadugar-staging \
    --to-revision=$PREV_VERSION
    
  # Verify rollback
  kubectl rollout status deployment jadugar-api \
    -n jadugar-staging
}
```

### 2. Database Rollback
```sql
-- Create backup before migration
CREATE OR REPLACE FUNCTION backup_before_migration()
RETURNS void AS $$
BEGIN
  -- Create backup tables
  EXECUTE format(
    'CREATE TABLE %I AS TABLE %I',
    'backup_' || to_char(now(), 'YYYY_MM_DD_HH24_MI_SS'),
    'target_table'
  );
END;
$$ LANGUAGE plpgsql;

-- Rollback migration
CREATE OR REPLACE FUNCTION rollback_migration(
  backup_timestamp timestamp
)
RETURNS void AS $$
BEGIN
  -- Restore from backup
  EXECUTE format(
    'DROP TABLE IF EXISTS %I; 
     CREATE TABLE %I AS TABLE %I',
    'target_table',
    'target_table',
    'backup_' || to_char(backup_timestamp, 'YYYY_MM_DD_HH24_MI_SS')
  );
END;
$$ LANGUAGE plpgsql;
```

## Staging Maintenance

### 1. Database Maintenance
```sql
-- Vacuum Analysis
VACUUM ANALYZE;

-- Update Statistics
ANALYZE VERBOSE;

-- Index Maintenance
REINDEX DATABASE jadugar_staging;

-- Connection Monitoring
SELECT * FROM pg_stat_activity
WHERE datname = 'jadugar_staging';
```

### 2. Cache Maintenance
```bash
#!/bin/bash

# Redis maintenance
redis_maintenance() {
  # Memory analysis
  redis-cli -h $REDIS_HOST info memory
  
  # Key space analysis
  redis-cli -h $REDIS_HOST info keyspace
  
  # Clean expired keys
  redis-cli -h $REDIS_HOST BGREWRITEAOF
}
```
