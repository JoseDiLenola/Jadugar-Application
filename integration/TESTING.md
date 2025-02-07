# Integration Testing Guide

## 1. Integration Test Strategy

### 1.1 Test Levels
1. Package Integration
   - Cross-package functionality
   - Type compatibility
   - API contracts
   - Event handling

2. System Integration
   - End-to-end flows
   - Performance
   - Error handling
   - State management

### 1.2 Test Coverage
1. Required Coverage
   - Integration tests: 95%
   - API coverage: 100%
   - Event coverage: 100%
   - Error coverage: 100%

## 2. Package Integration Tests

### 2.1 Types with Utils
```typescript
import { BaseType, Validator } from '@jadugar/types';
import { processType } from '@jadugar/utils';

describe('Types-Utils Integration', () => {
    test('processes valid type', () => {
        const data: BaseType = {
            id: '1',
            value: 'test'
        };
        
        const result = processType(data);
        expect(result.success).toBe(true);
    });
    
    test('handles invalid type', () => {
        const invalid = { wrong: true };
        expect(() => {
            processType(invalid);
        }).toThrow();
    });
});
```

### 2.2 Utils with Core
```typescript
import { processType } from '@jadugar/utils';
import { CoreService } from '@jadugar/core';

describe('Utils-Core Integration', () => {
    test('core uses processed data', () => {
        const data = { id: '1' };
        const processed = processType(data);
        const result = CoreService.handle(processed);
        expect(result).toBeDefined();
    });
});
```

## 3. System Integration Tests

### 3.1 End-to-End Flow
```typescript
import { createType } from '@jadugar/types';
import { processType } from '@jadugar/utils';
import { CoreService } from '@jadugar/core';
import { UIComponent } from '@jadugar/ui';

describe('End-to-End Integration', () => {
    test('complete flow', async () => {
        // Create data
        const data = createType({
            id: '1',
            value: 'test'
        });
        
        // Process data
        const processed = processType(data);
        
        // Handle in core
        const result = await CoreService.handle(processed);
        
        // Render in UI
        const { container } = render(
            <UIComponent data={result} />
        );
        
        expect(container).toMatchSnapshot();
    });
});
```

### 3.2 Error Flow
```typescript
describe('Error Integration', () => {
    test('handles errors across packages', async () => {
        // Invalid data
        const invalid = { wrong: true };
        
        // Should be caught by types
        expect(() => {
            createType(invalid);
        }).toThrow();
        
        // Should be caught by utils
        expect(() => {
            processType(invalid);
        }).toThrow();
        
        // Should be caught by core
        await expect(
            CoreService.handle(invalid)
        ).rejects.toThrow();
        
        // Should be handled by UI
        const { container } = render(
            <UIComponent data={invalid} />
        );
        
        expect(container).toHaveTextContent('Error');
    });
});
```

## 4. Performance Integration

### 4.1 Cross-Package Performance
```typescript
describe('Performance Integration', () => {
    test('meets performance requirements', () => {
        const start = performance.now();
        
        // Types
        const data = createType({
            id: '1',
            value: 'test'
        });
        
        // Utils
        const processed = processType(data);
        
        // Core
        const result = CoreService.handle(processed);
        
        // UI
        render(<UIComponent data={result} />);
        
        const end = performance.now();
        expect(end - start).toBeLessThan(100);
    });
});
```

### 4.2 Memory Integration
```typescript
describe('Memory Integration', () => {
    test('memory usage across packages', () => {
        const before = process.memoryUsage();
        
        // Run integration flow
        const data = createType({/*...*/});
        const processed = processType(data);
        const result = CoreService.handle(processed);
        render(<UIComponent data={result} />);
        
        const after = process.memoryUsage();
        expect(after.heapUsed - before.heapUsed)
            .toBeLessThan(1024 * 1024); // 1MB
    });
});
```

## 5. Event Integration

### 5.1 Event Flow
```typescript
describe('Event Integration', () => {
    test('events flow through packages', () => {
        // Create event in types
        const event = createEvent('test');
        
        // Process in utils
        const processed = processEvent(event);
        
        // Handle in core
        const result = CoreService.handleEvent(processed);
        
        // React in UI
        const { container } = render(
            <UIComponent onEvent={result} />
        );
        
        fireEvent.click(container);
        expect(result).toHaveBeenCalled();
    });
});
```

### 5.2 Event Error Handling
```typescript
describe('Event Error Integration', () => {
    test('handles event errors', () => {
        const invalid = createInvalidEvent();
        
        // Should be caught
        expect(() => {
            processEvent(invalid);
        }).toThrow();
        
        // Should be handled
        const { container } = render(
            <UIComponent onEvent={() => {
                throw new Error('Test');
            }} />
        );
        
        fireEvent.click(container);
        expect(container).toHaveTextContent('Error');
    });
});
```

## 6. State Integration

### 6.1 State Flow
```typescript
describe('State Integration', () => {
    test('state flows through packages', () => {
        // Create in types
        const state = createState({
            value: 'test'
        });
        
        // Process in utils
        const processed = processState(state);
        
        // Manage in core
        const { result } = renderHook(() => 
            useCore(processed)
        );
        
        // Use in UI
        const { container } = render(
            <UIComponent state={result.current} />
        );
        
        expect(container).toMatchSnapshot();
    });
});
```

### 6.2 State Updates
```typescript
describe('State Update Integration', () => {
    test('updates flow through packages', async () => {
        // Initial state
        const state = createState({
            value: 'test'
        });
        
        // Setup core
        const { result } = renderHook(() => 
            useCore(state)
        );
        
        // Render UI
        const { container } = render(
            <UIComponent state={result.current} />
        );
        
        // Update state
        act(() => {
            result.current.update('new');
        });
        
        await waitFor(() => {
            expect(container).toHaveTextContent('new');
        });
    });
});
```

## 7. API Integration

### 7.1 API Flow
```typescript
describe('API Integration', () => {
    test('API flow through packages', async () => {
        // Create request
        const request = createRequest({
            endpoint: '/test'
        });
        
        // Process request
        const processed = processRequest(request);
        
        // Send through core
        const response = await CoreService.send(processed);
        
        // Handle in UI
        const { container } = render(
            <UIComponent data={response} />
        );
        
        expect(container).toMatchSnapshot();
    });
});
```

### 7.2 API Error Handling
```typescript
describe('API Error Integration', () => {
    test('handles API errors', async () => {
        // Create error request
        const request = createRequest({
            endpoint: '/error'
        });
        
        // Should be caught
        await expect(
            CoreService.send(request)
        ).rejects.toThrow();
        
        // Should be handled
        const { container } = render(
            <UIComponent onError={() => {}} />
        );
        
        expect(container).toHaveTextContent('Error');
    });
});
```

## 8. Documentation Integration

### 8.1 Example Testing
```typescript
describe('Documentation Integration', () => {
    test('documentation examples work', () => {
        // Get example
        const example = getExample('integration');
        
        // Should work
        expect(() => {
            eval(example);
        }).not.toThrow();
    });
});
```

### 8.2 API Documentation
```typescript
describe('API Documentation', () => {
    test('API documentation is accurate', () => {
        const docs = getApiDocs();
        const api = getActualApi();
        
        expect(docs).toMatchObject(api);
    });
});
```

## 9. CI Integration

### 9.1 Integration Pipeline
```yaml
steps:
  - name: Integration Tests
    run: yarn test:integration
    
  - name: Performance Tests
    run: yarn test:performance
    
  - name: Documentation Tests
    run: yarn test:docs
```

### 9.2 Results
```yaml
steps:
  - name: Collect Results
    run: yarn collect-results
    
  - name: Upload Results
    uses: actions/upload-artifact
```

## 10. Maintenance

### 10.1 Regular Tasks
1. Run integration tests
2. Update snapshots
3. Check performance
4. Verify documentation

### 10.2 Updates
1. Update test cases
2. Maintain coverage
3. Monitor performance
4. Keep docs current
