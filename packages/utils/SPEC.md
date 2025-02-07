# @jadugar/utils Package Specification

## 1. Package Purpose

### 1.1 Overview
@jadugar/utils provides essential utilities for the Jadugar framework:
- Type utilities
- Validation utilities
- Common operations
- Helper functions

### 1.2 Core Responsibilities
1. Type Operations
   - Type guards
   - Type conversions
   - Type validation
   - Type utilities

2. Common Utilities
   - String operations
   - Number operations
   - Array operations
   - Object operations

3. Validation
   - Data validation
   - Schema validation
   - Format validation
   - Custom validation

4. Integration
   - Types integration
   - Core support
   - UI helpers
   - Testing utilities

## 2. Utility System

### 2.1 Type Utilities
```typescript
// Type Guards
function isString(value: unknown): value is string {
    return typeof value === 'string';
}

// Type Conversion
function toString(value: unknown): string {
    if (isString(value)) return value;
    return String(value);
}

// Type Validation
function validateType<T>(
    value: unknown,
    validator: (v: unknown) => v is T
): value is T {
    return validator(value);
}

// Type Utilities
function createType<T>(data: unknown): T {
    if (!validateType<T>(data, isValidType)) {
        throw new TypeError('Invalid type');
    }
    return data;
}
```

### 2.2 Common Utilities
```typescript
// String Operations
const string = {
    capitalize: (s: string): string => 
        s.charAt(0).toUpperCase() + s.slice(1),
    
    camelCase: (s: string): string =>
        s.replace(/[-_]([a-z])/g, g => g[1].toUpperCase()),
    
    snakeCase: (s: string): string =>
        s.replace(/[A-Z]/g, c => `_${c.toLowerCase()}`)
};

// Number Operations
const number = {
    clamp: (n: number, min: number, max: number): number =>
        Math.min(Math.max(n, min), max),
    
    round: (n: number, decimals: number): number =>
        Number(Math.round(Number(n + 'e' + decimals)) + 'e-' + decimals)
};

// Array Operations
const array = {
    unique: <T>(arr: T[]): T[] =>
        Array.from(new Set(arr)),
    
    groupBy: <T>(arr: T[], key: keyof T): Record<string, T[]> =>
        arr.reduce((groups, item) => {
            const k = String(item[key]);
            (groups[k] = groups[k] || []).push(item);
            return groups;
        }, {} as Record<string, T[]>)
};

// Object Operations
const object = {
    pick: <T, K extends keyof T>(
        obj: T,
        keys: K[]
    ): Pick<T, K> => {
        const result = {} as Pick<T, K>;
        keys.forEach(key => {
            if (key in obj) result[key] = obj[key];
        });
        return result;
    },
    
    omit: <T, K extends keyof T>(
        obj: T,
        keys: K[]
    ): Omit<T, K> => {
        const result = { ...obj };
        keys.forEach(key => delete result[key]);
        return result as Omit<T, K>;
    }
};
```

## 3. Validation System

### 3.1 Data Validation
```typescript
// Schema Validation
interface Schema {
    type: string;
    required?: boolean;
    validate?: (value: unknown) => boolean;
}

function validateSchema(
    data: unknown,
    schema: Schema
): boolean {
    if (schema.required && data == null) {
        return false;
    }
    
    if (typeof data !== schema.type) {
        return false;
    }
    
    if (schema.validate && !schema.validate(data)) {
        return false;
    }
    
    return true;
}

// Format Validation
const format = {
    email: (value: string): boolean =>
        /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
    
    url: (value: string): boolean =>
        /^https?:\/\//.test(value),
    
    date: (value: string): boolean =>
        !isNaN(Date.parse(value))
};
```

### 3.2 Custom Validation
```typescript
// Custom Validators
interface Validator<T> {
    validate: (value: unknown) => value is T;
    message: string;
}

function createValidator<T>(
    validate: (value: unknown) => value is T,
    message: string
): Validator<T> {
    return { validate, message };
}

// Validation Chain
class ValidationChain<T> {
    private validators: Validator<T>[] = [];
    
    add(validator: Validator<T>): this {
        this.validators.push(validator);
        return this;
    }
    
    validate(value: unknown): value is T {
        return this.validators.every(v => v.validate(value));
    }
    
    getErrors(value: unknown): string[] {
        return this.validators
            .filter(v => !v.validate(value))
            .map(v => v.message);
    }
}
```

## 4. Integration Requirements

### 4.1 Package Dependencies
1. Required
   - @jadugar/types
   
2. Optional
   - None

### 4.2 Integration Points
1. Type System
   - Use types from @jadugar/types
   - Extend with utilities
   - Provide validation
   - Maintain consistency

2. Core Integration
   - Provide utilities
   - Support operations
   - Enable validation
   - Assist testing

3. UI Integration
   - Helper functions
   - Format utilities
   - Style utilities
   - Event utilities

## 5. Performance Requirements

### 5.1 Runtime Performance
1. Type Operations
   - Guard checks < 0.1ms
   - Validation < 1ms
   - Conversion < 0.1ms
   - Utilities < 1ms

2. Common Operations
   - String ops < 0.1ms
   - Number ops < 0.1ms
   - Array ops < 1ms
   - Object ops < 1ms

### 5.2 Memory Usage
1. Static Memory
   - Bundle size < 10KB
   - No memory leaks
   - Efficient caching
   - Minimal overhead

2. Dynamic Memory
   - Operation memory < 1MB
   - No memory growth
   - Quick cleanup
   - Efficient allocation

## 6. Testing Requirements

### 6.1 Unit Tests
1. Coverage Requirements
   - Functions: 100%
   - Branches: 100%
   - Lines: 100%
   - Statements: 100%

2. Test Types
   - Type tests
   - Function tests
   - Edge cases
   - Error cases

### 6.2 Integration Tests
1. Package Tests
   - Types integration
   - Core integration
   - UI integration
   - Cross-package tests

2. Performance Tests
   - Operation speed
   - Memory usage
   - Load time
   - Bundle size

## 7. Documentation Requirements

### 7.1 API Documentation
1. Function Documentation
   - Purpose
   - Parameters
   - Return type
   - Examples

2. Type Documentation
   - Type definitions
   - Type guards
   - Validation
   - Utilities

### 7.2 Usage Documentation
1. Examples
   - Basic usage
   - Advanced usage
   - Edge cases
   - Error handling

2. Integration
   - With types
   - With core
   - With UI
   - Best practices

## 8. Security Requirements

### 8.1 Input Validation
1. Type Safety
   - Runtime checks
   - Type guards
   - Validation
   - Sanitization

2. Data Safety
   - Input validation
   - Output validation
   - Error handling
   - Security checks

### 8.2 Security Measures
1. Code Security
   - No eval
   - No Function
   - Safe JSON
   - Safe regex

2. Data Security
   - Input sanitization
   - Output encoding
   - Error masking
   - Safe defaults

## 9. Maintenance

### 9.1 Version Control
1. Semantic Versioning
   - Major: Breaking
   - Minor: Features
   - Patch: Fixes
   - Pre-release: Beta

2. Change Management
   - Breaking changes
   - Deprecations
   - Migrations
   - Updates

### 9.2 Support
1. Issue Management
   - Bug tracking
   - Feature requests
   - Documentation
   - Examples

2. Updates
   - Security updates
   - Performance updates
   - Documentation updates
   - Example updates

## 10. Next Steps

### 10.1 Current Phase
1. Implementation
   - Type utilities
   - Common utilities
   - Validation system
   - Integration

2. Documentation
   - API docs
   - Examples
   - Integration
   - Testing

### 10.2 Future Plans
1. Enhancements
   - More utilities
   - Better performance
   - Enhanced validation
   - Extended integration

2. Maintenance
   - Regular updates
   - Security patches
   - Performance optimization
   - Documentation updates
