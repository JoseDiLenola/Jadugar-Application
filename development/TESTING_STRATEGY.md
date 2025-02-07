# Testing Strategy

## Package Testing Hierarchy

### 1. @jadugar/types
```typescript
// Unit Tests
describe('BuildConfig', () => {
  it('should validate build configuration', () => {
    const config: BuildConfig = {
      projectId: 'test',
      timeout: 3600
    };
    expect(validateBuildConfig(config)).toBe(true);
  });
});
```

### 2. @jadugar/utils
```typescript
// Unit Tests
describe('logger', () => {
  it('should format log messages', () => {
    const message = formatLog('test', 'info');
    expect(message).toMatch(/\[INFO\]/);
  });
});

// Integration Tests
describe('validation', () => {
  it('should validate against types', () => {
    const data = { id: 1 };
    expect(validateAgainstType(data, 'Entity')).toBe(true);
  });
});
```

### 3. @jadugar/core
```typescript
// Unit Tests
describe('BuildTracker', () => {
  it('should track build progress', async () => {
    const tracker = new BuildTracker();
    await tracker.start();
    expect(tracker.status).toBe('running');
  });
});

// Integration Tests
describe('BuildSystem', () => {
  it('should integrate with utils', async () => {
    const system = new BuildSystem();
    await system.initialize();
    expect(system.logger).toBeDefined();
  });
});

// E2E Tests
describe('BuildWorkflow', () => {
  it('should complete build process', async () => {
    const result = await completeBuildWorkflow();
    expect(result.status).toBe('success');
  });
});
```

### 4. @jadugar/ui
```typescript
// Unit Tests
describe('BuildStatus', () => {
  it('should render status correctly', () => {
    render(<BuildStatus status="running" />);
    expect(screen.getByText('Running')).toBeInTheDocument();
  });
});

// Integration Tests
describe('BuildDashboard', () => {
  it('should integrate with core', async () => {
    const { result } = renderHook(() => useBuildStatus());
    expect(result.current.status).toBeDefined();
  });
});

// Visual Tests
describe('BuildProgress', () => {
  it('should match snapshot', () => {
    const tree = renderer.create(<BuildProgress value={50} />);
    expect(tree).toMatchSnapshot();
  });
});
```

### 5. @jadugar/api
```typescript
// Unit Tests
describe('BuildController', () => {
  it('should handle build requests', async () => {
    const response = await buildController.start({ projectId: '1' });
    expect(response.status).toBe(200);
  });
});

// Integration Tests
describe('BuildAPI', () => {
  it('should integrate with core', async () => {
    const api = new BuildAPI();
    const result = await api.createBuild();
    expect(result.buildId).toBeDefined();
  });
});

// Load Tests
describe('BuildEndpoints', () => {
  it('should handle concurrent requests', async () => {
    const results = await loadTest('/api/builds', 100);
    expect(results.success).toBeGreaterThan(95);
  });
});
```

## Test Types

### 1. Unit Tests
- Test individual functions
- Mock dependencies
- Fast execution
- High coverage

### 2. Integration Tests
- Test package interactions
- Limited mocking
- Cross-package validation
- Real dependencies

### 3. E2E Tests
- Test complete workflows
- No mocking
- Real environment
- Critical paths

### 4. Performance Tests
- Load testing
- Stress testing
- Memory profiling
- Response times

## Test Coverage Requirements

### 1. Types Package
- Unit Tests: 100%
- No integration tests required
- Type validation tests
- Documentation tests

### 2. Utils Package
- Unit Tests: 95%+
- Integration Tests: 80%+
- Performance benchmarks
- Error handling tests

### 3. Core Package
- Unit Tests: 90%+
- Integration Tests: 85%+
- E2E Tests: Critical paths
- Performance Tests: Required

### 4. UI Package
- Unit Tests: 90%+
- Integration Tests: 80%+
- Visual Tests: Required
- Accessibility Tests: Required

### 5. API Package
- Unit Tests: 90%+
- Integration Tests: 85%+
- Load Tests: Required
- Security Tests: Required

## Testing Tools

### 1. Test Runners
```json
{
  "devDependencies": {
    "jest": "^29.0.0",
    "vitest": "^1.0.0",
    "cypress": "^13.0.0"
  }
}
```

### 2. Testing Libraries
```json
{
  "devDependencies": {
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.0.0",
    "supertest": "^6.0.0",
    "mock-socket": "^9.0.0"
  }
}
```

### 3. Coverage Tools
```json
{
  "jest": {
    "coverageThreshold": {
      "global": {
        "branches": 90,
        "functions": 90,
        "lines": 90,
        "statements": 90
      }
    }
  }
}
```

## Test Environment

### 1. Development
```bash
# Run tests in watch mode
npm run test:watch

# Update snapshots
npm run test:update

# Check coverage
npm run test:coverage
```

### 2. CI/CD
```bash
# Full test suite
npm run test:ci

# E2E tests
npm run test:e2e

# Performance tests
npm run test:perf
```

### 3. Pre-release
```bash
# Integration suite
npm run test:integration

# Load tests
npm run test:load

# Security tests
npm run test:security
```

## Best Practices

### 1. Test Organization
```typescript
// Group by feature
describe('BuildFeature', () => {
  describe('when starting build', () => {
    it('should initialize correctly', () => {});
    it('should handle errors', () => {});
  });
});
```

### 2. Test Naming
```typescript
// Clear and descriptive names
it('should update build status when progress changes', () => {});
it('should throw error when configuration is invalid', () => {});
```

### 3. Test Setup
```typescript
// Use beforeEach for common setup
beforeEach(() => {
  buildSystem = new BuildSystem();
  mockLogger = jest.fn();
});
```

### 4. Assertions
```typescript
// Clear assertions
expect(result.status).toBe('success');
expect(error).toBeInstanceOf(BuildError);
expect(handler).toHaveBeenCalledWith(expect.any(Error));
