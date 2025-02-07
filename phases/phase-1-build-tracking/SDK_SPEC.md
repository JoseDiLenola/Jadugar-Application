# Jadugar SDK Specification

## Overview
The Jadugar SDK enables real-time build tracking by integrating directly with build tools and processes.

## Core Features

### 1. Build Tracking API
```typescript
class JadugarBuildTracker {
  constructor(config: {
    projectId: string;
    buildId: string;
    endpoint?: string;
  });

  // Core Methods
  startBuild(): Promise<void>;
  updateProgress(phase: string, progress?: number): Promise<void>;
  logError(error: Error): Promise<void>;
  completeBuild(): Promise<void>;

  // Metrics
  recordMetric(name: string, value: number): Promise<void>;
  addBuildInfo(info: Record<string, any>): Promise<void>;
}
```

### 2. Build Tool Plugins

#### Webpack Plugin
```typescript
// webpack.config.js
const { JadugarWebpackPlugin } = require('@jadugar/webpack-plugin');

module.exports = {
  plugins: [
    new JadugarWebpackPlugin({
      projectId: 'my-app',
      buildId: process.env.BUILD_ID
    })
  ]
};
```

#### Vite Plugin
```typescript
// vite.config.ts
import { jadugarVitePlugin } from '@jadugar/vite-plugin';

export default defineConfig({
  plugins: [
    jadugarVitePlugin({
      projectId: 'my-app',
      buildId: process.env.BUILD_ID
    })
  ]
});
```

#### Jest Reporter
```typescript
// jest.config.js
module.exports = {
  reporters: [
    'default',
    ['@jadugar/jest-reporter', {
      projectId: 'my-app',
      buildId: process.env.BUILD_ID
    }]
  ]
};
```

### 3. CI/CD Integration

#### GitHub Actions
```yaml
# .github/workflows/build.yml
steps:
  - uses: actions/checkout@v2
  - uses: jadugar/build-tracker-action@v1
    with:
      project-id: my-app
      api-key: ${{ secrets.JADUGAR_API_KEY }}
```

#### CircleCI
```yaml
# .circleci/config.yml
orbs:
  jadugar: jadugar/build-tracker@1.0.0

jobs:
  build:
    steps:
      - jadugar/track-build:
          project-id: my-app
```

## Implementation Details

### 1. SDK Core
```typescript
// Core functionality
interface BuildProgress {
  phase: string;
  progress: number;
  timestamp: Date;
  metadata?: Record<string, any>;
}

interface BuildError {
  message: string;
  stack?: string;
  phase: string;
  timestamp: Date;
}

interface BuildMetric {
  name: string;
  value: number;
  timestamp: Date;
}
```

### 2. Real-time Updates
```typescript
// WebSocket connection
class BuildSocket {
  private socket: WebSocket;

  constructor(buildId: string) {
    this.socket = new WebSocket(`wss://api.jadugar.io/builds/${buildId}`);
  }

  sendUpdate(progress: BuildProgress): void {
    this.socket.send(JSON.stringify(progress));
  }
}
```

### 3. Error Handling
```typescript
// Error management
class ErrorManager {
  logError(error: BuildError): void {
    // Log error
    // Notify dashboard
    // Update build status
  }

  handleFailure(): void {
    // Graceful degradation
    // Retry mechanism
    // Offline support
  }
}
```

## Usage Examples

### 1. Basic Usage
```typescript
const tracker = new JadugarBuildTracker({
  projectId: 'my-app',
  buildId: 'build-123'
});

async function build() {
  await tracker.startBuild();
  
  try {
    await tracker.updateProgress('Installing dependencies');
    // npm install
    
    await tracker.updateProgress('Compiling');
    // webpack build
    
    await tracker.updateProgress('Testing');
    // run tests
    
    await tracker.completeBuild();
  } catch (error) {
    await tracker.logError(error);
    throw error;
  }
}
```

### 2. With Build Tools
```typescript
// Webpack example
new JadugarWebpackPlugin({
  projectId: 'my-app',
  buildId: 'build-123',
  hooks: {
    onStart: () => console.log('Build started'),
    onProgress: (progress) => console.log(`${progress}% complete`),
    onError: (error) => console.error('Build failed:', error)
  }
});
```

### 3. Custom Integration
```typescript
class CustomBuildTool {
  private tracker: JadugarBuildTracker;

  constructor() {
    this.tracker = new JadugarBuildTracker({
      projectId: 'my-app',
      buildId: `build-${Date.now()}`
    });
  }

  async build() {
    await this.tracker.startBuild();
    // Custom build logic
    await this.tracker.completeBuild();
  }
}
```

## Best Practices

### 1. Error Handling
```typescript
// Always use try-catch
try {
  await tracker.updateProgress('Building');
} catch (error) {
  // Log error but don't fail build
  console.error('Failed to update progress:', error);
}
```

### 2. Progress Updates
```typescript
// Regular updates with meaningful phases
await tracker.updateProgress('Installing dependencies', 0);
await tracker.updateProgress('Installing dependencies', 50);
await tracker.updateProgress('Installing dependencies', 100);
```

### 3. Metrics Collection
```typescript
// Track important metrics
await tracker.recordMetric('build_time', buildDuration);
await tracker.recordMetric('bundle_size', bundleSize);
await tracker.recordMetric('test_coverage', coverage);
```

## Security Considerations

### 1. Authentication
```typescript
// Use environment variables
const tracker = new JadugarBuildTracker({
  projectId: process.env.JADUGAR_PROJECT_ID,
  apiKey: process.env.JADUGAR_API_KEY
});
```

### 2. Data Privacy
```typescript
// Control what data is sent
tracker.configure({
  sendSourceMaps: false,
  sendDependencies: true,
  sendEnvironment: false
});
```

## Next Steps

### 1. Implementation Priority
1. Core SDK
   - Basic tracking
   - Error handling
   - Real-time updates

2. Build Tool Plugins
   - Webpack plugin
   - Vite plugin
   - Jest reporter

3. CI/CD Integration
   - GitHub Actions
   - CircleCI
   - GitLab CI
