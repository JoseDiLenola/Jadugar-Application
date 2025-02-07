# @jadugar/core Testing Layer

This document specifies the testing layer implementation for the Jadugar project. The testing layer provides comprehensive testing utilities, fixtures, and test runners for all components.

## Testing Architecture

### Test Manager

```typescript
interface TestOptions {
  runners?: TestRunner[];
  reporters?: TestReporter[];
  fixtures?: TestFixture[];
  coverage?: CoverageOptions;
}

class TestManager {
  constructor(options: TestOptions);
  
  // Test Operations
  async run(suite: TestSuite): Promise<TestResult>;
  async runFile(path: string): Promise<TestResult>;
  async runPattern(pattern: string): Promise<TestResult>;
  
  // Runner Management
  addRunner(runner: TestRunner): void;
  removeRunner(name: string): void;
  
  // Configuration
  configure(options: TestOptions): void;
  getConfig(): TestConfig;
}
```

## Test Runners

### Runner Interface

```typescript
interface TestRunner {
  name: string;
  
  // Runner Operations
  run(suite: TestSuite): Promise<TestResult>;
  setup(): Promise<void>;
  teardown(): Promise<void>;
  
  // Runner Management
  configure(options: RunnerOptions): void;
  isReady(): boolean;
}
```

### Runner Implementations

```typescript
class UnitTestRunner implements TestRunner {
  constructor(options?: UnitRunnerOptions);
  
  // Implementation
  async run(suite: TestSuite): Promise<TestResult> {
    // Run unit tests
  }
}

class IntegrationTestRunner implements TestRunner {
  constructor(options: IntegrationOptions);
  
  // Implementation
  async run(suite: TestSuite): Promise<TestResult> {
    // Run integration tests
  }
}

class E2ETestRunner implements TestRunner {
  constructor(options: E2EOptions);
  
  // Implementation
  async run(suite: TestSuite): Promise<TestResult> {
    // Run end-to-end tests
  }
}
```

## Test Fixtures

### Fixture Interface

```typescript
interface TestFixture {
  name: string;
  
  // Fixture Operations
  setup(): Promise<void>;
  teardown(): Promise<void>;
  reset(): Promise<void>;
  
  // Data Management
  getData(): Promise<FixtureData>;
  cleanup(): Promise<void>;
}
```

### Fixture Implementations

```typescript
class DatabaseFixture implements TestFixture {
  constructor(options: DatabaseFixtureOptions);
  
  // Implementation
  async setup(): Promise<void> {
    // Setup test database
  }
  
  async teardown(): Promise<void> {
    // Cleanup database
  }
}

class HTTPFixture implements TestFixture {
  constructor(options: HTTPFixtureOptions);
  
  // Implementation
  async setup(): Promise<void> {
    // Setup HTTP mocks
  }
  
  async teardown(): Promise<void> {
    // Cleanup mocks
  }
}
```

## Test Reporters

### Reporter Interface

```typescript
interface TestReporter {
  name: string;
  
  // Reporter Operations
  report(result: TestResult): Promise<void>;
  start(suite: TestSuite): Promise<void>;
  end(summary: TestSummary): Promise<void>;
  
  // Reporter Management
  configure(options: ReporterOptions): void;
  getOutput(): ReporterOutput;
}
```

### Reporter Implementations

```typescript
class ConsoleReporter implements TestReporter {
  constructor(options?: ConsoleReporterOptions);
  // Implementation of TestReporter interface
}

class JUnitReporter implements TestReporter {
  constructor(options: JUnitReporterOptions);
  // Implementation of TestReporter interface
}

class HTMLReporter implements TestReporter {
  constructor(options: HTMLReporterOptions);
  // Implementation of TestReporter interface
}
```

## Test Coverage

### Coverage System

```typescript
interface CoverageOptions {
  reporters?: CoverageReporter[];
  threshold?: CoverageThreshold;
  exclude?: string[];
}

class CoverageCollector {
  constructor(options: CoverageOptions);
  
  // Coverage Operations
  start(): Promise<void>;
  stop(): Promise<void>;
  
  // Report Generation
  generateReport(): Promise<CoverageReport>;
  checkThresholds(): Promise<boolean>;
}
```

### Coverage Reporters

```typescript
interface CoverageReporter {
  name: string;
  
  // Reporter Operations
  report(coverage: CoverageData): Promise<void>;
  format(coverage: CoverageData): Promise<string>;
  
  // Reporter Management
  configure(options: ReporterOptions): void;
  getOutput(): ReporterOutput;
}

class IstanbulReporter implements CoverageReporter {
  constructor(options?: IstanbulOptions);
  // Implementation of CoverageReporter interface
}
```

## Test Assertions

### Assertion Library

```typescript
class Assertions {
  // Value Assertions
  equals(actual: any, expected: any): void;
  notEquals(actual: any, expected: any): void;
  
  // Type Assertions
  typeOf(value: any, type: string): void;
  instanceOf(value: any, constructor: Function): void;
  
  // State Assertions
  truthy(value: any): void;
  falsy(value: any): void;
  null(value: any): void;
  
  // Error Assertions
  throws(fn: Function): void;
  doesNotThrow(fn: Function): void;
  rejects(promise: Promise<any>): Promise<void>;
}
```

### Custom Matchers

```typescript
interface CustomMatcher {
  name: string;
  
  // Matcher Operations
  match(actual: any, expected: any): boolean;
  message(actual: any, expected: any): string;
  
  // Matcher Management
  configure(options: MatcherOptions): void;
  validate(value: any): boolean;
}
```

## Test Mocking

### Mock System

```typescript
interface MockOptions {
  type: 'function' | 'class' | 'object';
  behavior?: MockBehavior;
  tracking?: TrackingOptions;
}

class MockFactory {
  constructor(options?: MockOptions);
  
  // Mock Creation
  createMock<T>(target: T): Mock<T>;
  createSpy(target: Function): Spy;
  createStub(target: any): Stub;
  
  // Mock Management
  reset(): void;
  verify(): void;
  restore(): void;
}
```

### Mock Types

```typescript
interface Mock<T> {
  // Mock Operations
  when(method: keyof T): MockBuilder;
  verify(method: keyof T): MockVerifier;
  
  // State Management
  reset(): void;
  restore(): void;
  getCalls(): MockCall[];
}

interface Spy {
  // Spy Operations
  called(): boolean;
  calledWith(...args: any[]): boolean;
  callCount(): number;
  
  // Call History
  getCall(index: number): SpyCall;
  getAllCalls(): SpyCall[];
}
```

## Implementation Notes

1. Test Types
   - Unit tests
   - Integration tests
   - End-to-end tests
   - Performance tests

2. Test Organization
   - Suite structure
   - Test grouping
   - Fixture management
   - Coverage tracking

3. Performance
   - Parallel execution
   - Resource cleanup
   - Cache management
   - Report generation

4. Integration
   - CI/CD systems
   - Test frameworks
   - Coverage tools
   - Reporting platforms

5. Best Practices
   - Isolation
   - Repeatability
   - Maintainability
   - Documentation

## Testing Requirements

1. Unit Tests
   - Component isolation
   - Mock integration
   - State verification
   - Error handling

2. Integration Tests
   - Component interaction
   - Data flow
   - Error scenarios
   - Performance impact

3. E2E Tests
   - User workflows
   - System integration
   - Error recovery
   - Performance metrics

4. Performance Tests
   - Load testing
   - Stress testing
   - Scalability
   - Resource usage

## Usage Examples

### Basic Test Suite

```typescript
const testManager = new TestManager({
  runners: [new UnitTestRunner()],
  reporters: [new ConsoleReporter()]
});

const suite = {
  name: 'Authentication Tests',
  tests: [
    {
      name: 'should authenticate valid user',
      async fn() {
        const auth = new AuthService();
        const result = await auth.authenticate({
          username: 'test',
          password: 'password'
        });
        assert.truthy(result.success);
      }
    }
  ]
};

await testManager.run(suite);
```

### Test with Fixtures

```typescript
const dbFixture = new DatabaseFixture({
  connection: testDbConfig
});

const httpFixture = new HTTPFixture({
  baseUrl: 'http://api.example.com'
});

beforeEach(async () => {
  await dbFixture.setup();
  await httpFixture.setup();
});

afterEach(async () => {
  await httpFixture.teardown();
  await dbFixture.teardown();
});

test('should create user', async () => {
  const userData = await dbFixture.getData('users');
  const response = await httpFixture
    .post('/users', userData);
  
  assert.equals(response.status, 201);
});
```

### Mocking Example

```typescript
const mockFactory = new MockFactory();

const serviceMock = mockFactory.createMock(UserService);
serviceMock
  .when('findUser')
  .thenReturn({
    id: '123',
    name: 'Test User'
  });

const controller = new UserController(serviceMock);
const user = await controller.getUser('123');

serviceMock.verify('findUser').calledWith('123');
assert.equals(user.name, 'Test User');
```

### Coverage Report

```typescript
const coverage = new CoverageCollector({
  reporters: [new IstanbulReporter()],
  threshold: {
    statements: 80,
    branches: 70,
    functions: 80,
    lines: 80
  }
});

await coverage.start();
await runTests();
await coverage.stop();

const report = await coverage.generateReport();
const passed = await coverage.checkThresholds();

if (!passed) {
  console.error('Coverage thresholds not met');
  process.exit(1);
}
```
