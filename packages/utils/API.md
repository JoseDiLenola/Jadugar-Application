# @jadugar/utils API Documentation

## 1. Type Utilities

### 1.1 Type Guards
```typescript
/**
 * Type guard for string values
 * @param value - Value to check
 * @returns True if value is string
 */
function isString(value: unknown): value is string;

/**
 * Type guard for number values
 * @param value - Value to check
 * @returns True if value is number
 */
function isNumber(value: unknown): value is number;

/**
 * Type guard for array values
 * @param value - Value to check
 * @returns True if value is array
 */
function isArray(value: unknown): value is unknown[];

/**
 * Type guard for object values
 * @param value - Value to check
 * @returns True if value is object
 */
function isObject(value: unknown): value is object;
```

### 1.2 Type Conversion
```typescript
/**
 * Convert value to string
 * @param value - Value to convert
 * @returns String representation
 */
function toString(value: unknown): string;

/**
 * Convert value to number
 * @param value - Value to convert
 * @returns Number representation
 * @throws If value cannot be converted
 */
function toNumber(value: unknown): number;

/**
 * Convert value to array
 * @param value - Value to convert
 * @returns Array representation
 */
function toArray<T>(value: T | T[]): T[];

/**
 * Convert value to object
 * @param value - Value to convert
 * @returns Object representation
 * @throws If value cannot be converted
 */
function toObject(value: unknown): object;
```

## 2. String Utilities

### 2.1 Case Operations
```typescript
/**
 * Convert string to camelCase
 * @param value - String to convert
 * @returns Camel case string
 */
function camelCase(value: string): string;

/**
 * Convert string to snake_case
 * @param value - String to convert
 * @returns Snake case string
 */
function snakeCase(value: string): string;

/**
 * Convert string to kebab-case
 * @param value - String to convert
 * @returns Kebab case string
 */
function kebabCase(value: string): string;

/**
 * Convert string to PascalCase
 * @param value - String to convert
 * @returns Pascal case string
 */
function pascalCase(value: string): string;
```

### 2.2 String Operations
```typescript
/**
 * Capitalize first letter
 * @param value - String to capitalize
 * @returns Capitalized string
 */
function capitalize(value: string): string;

/**
 * Truncate string to length
 * @param value - String to truncate
 * @param length - Max length
 * @param suffix - Optional suffix
 * @returns Truncated string
 */
function truncate(
    value: string,
    length: number,
    suffix?: string
): string;

/**
 * Pad string to length
 * @param value - String to pad
 * @param length - Target length
 * @param char - Pad character
 * @returns Padded string
 */
function pad(
    value: string,
    length: number,
    char?: string
): string;
```

## 3. Number Utilities

### 3.1 Math Operations
```typescript
/**
 * Clamp number between min and max
 * @param value - Number to clamp
 * @param min - Minimum value
 * @param max - Maximum value
 * @returns Clamped number
 */
function clamp(
    value: number,
    min: number,
    max: number
): number;

/**
 * Round number to decimals
 * @param value - Number to round
 * @param decimals - Decimal places
 * @returns Rounded number
 */
function round(
    value: number,
    decimals: number
): number;

/**
 * Get random number in range
 * @param min - Minimum value
 * @param max - Maximum value
 * @returns Random number
 */
function random(
    min: number,
    max: number
): number;
```

### 3.2 Number Formatting
```typescript
/**
 * Format number with commas
 * @param value - Number to format
 * @returns Formatted string
 */
function formatNumber(value: number): string;

/**
 * Format as currency
 * @param value - Number to format
 * @param currency - Currency code
 * @returns Formatted string
 */
function formatCurrency(
    value: number,
    currency?: string
): string;

/**
 * Format as percentage
 * @param value - Number to format
 * @param decimals - Decimal places
 * @returns Formatted string
 */
function formatPercent(
    value: number,
    decimals?: number
): string;
```

## 4. Array Utilities

### 4.1 Array Operations
```typescript
/**
 * Get unique values
 * @param array - Array to process
 * @returns Unique values
 */
function unique<T>(array: T[]): T[];

/**
 * Group array by key
 * @param array - Array to group
 * @param key - Group key
 * @returns Grouped object
 */
function groupBy<T>(
    array: T[],
    key: keyof T
): Record<string, T[]>;

/**
 * Chunk array into parts
 * @param array - Array to chunk
 * @param size - Chunk size
 * @returns Array of chunks
 */
function chunk<T>(
    array: T[],
    size: number
): T[][];
```

### 4.2 Array Search
```typescript
/**
 * Find first match
 * @param array - Array to search
 * @param predicate - Search function
 * @returns First match or undefined
 */
function find<T>(
    array: T[],
    predicate: (item: T) => boolean
): T | undefined;

/**
 * Find all matches
 * @param array - Array to search
 * @param predicate - Search function
 * @returns All matches
 */
function filter<T>(
    array: T[],
    predicate: (item: T) => boolean
): T[];

/**
 * Find index of match
 * @param array - Array to search
 * @param predicate - Search function
 * @returns Index or -1
 */
function findIndex<T>(
    array: T[],
    predicate: (item: T) => boolean
): number;
```

## 5. Object Utilities

### 5.1 Object Operations
```typescript
/**
 * Pick object properties
 * @param object - Source object
 * @param keys - Keys to pick
 * @returns New object
 */
function pick<T, K extends keyof T>(
    object: T,
    keys: K[]
): Pick<T, K>;

/**
 * Omit object properties
 * @param object - Source object
 * @param keys - Keys to omit
 * @returns New object
 */
function omit<T, K extends keyof T>(
    object: T,
    keys: K[]
): Omit<T, K>;

/**
 * Deep clone object
 * @param object - Object to clone
 * @returns Cloned object
 */
function clone<T>(object: T): T;
```

### 5.2 Object Transformation
```typescript
/**
 * Map object values
 * @param object - Source object
 * @param transform - Transform function
 * @returns New object
 */
function mapValues<T, U>(
    object: Record<string, T>,
    transform: (value: T) => U
): Record<string, U>;

/**
 * Map object keys
 * @param object - Source object
 * @param transform - Transform function
 * @returns New object
 */
function mapKeys<T>(
    object: Record<string, T>,
    transform: (key: string) => string
): Record<string, T>;

/**
 * Deep merge objects
 * @param objects - Objects to merge
 * @returns Merged object
 */
function merge<T>(...objects: Partial<T>[]): T;
```

## 6. Validation Utilities

### 6.1 Schema Validation
```typescript
/**
 * Validate against schema
 * @param data - Data to validate
 * @param schema - Validation schema
 * @returns Validation result
 */
function validate<T>(
    data: unknown,
    schema: Schema
): ValidationResult<T>;

/**
 * Create schema validator
 * @param schema - Validation schema
 * @returns Validator function
 */
function createValidator<T>(
    schema: Schema
): (data: unknown) => ValidationResult<T>;

/**
 * Validate array items
 * @param array - Array to validate
 * @param schema - Item schema
 * @returns Validation result
 */
function validateArray<T>(
    array: unknown[],
    schema: Schema
): ValidationResult<T[]>;
```

### 6.2 Format Validation
```typescript
/**
 * Validate email format
 * @param value - Value to validate
 * @returns True if valid
 */
function isEmail(value: string): boolean;

/**
 * Validate URL format
 * @param value - Value to validate
 * @returns True if valid
 */
function isUrl(value: string): boolean;

/**
 * Validate date format
 * @param value - Value to validate
 * @returns True if valid
 */
function isDate(value: string): boolean;
```

## 7. Error Utilities

### 7.1 Error Creation
```typescript
/**
 * Create type error
 * @param message - Error message
 * @returns TypeError
 */
function createTypeError(message: string): TypeError;

/**
 * Create validation error
 * @param message - Error message
 * @param errors - Validation errors
 * @returns ValidationError
 */
function createValidationError(
    message: string,
    errors?: string[]
): ValidationError;

/**
 * Create assertion error
 * @param message - Error message
 * @returns AssertionError
 */
function createAssertionError(
    message: string
): AssertionError;
```

### 7.2 Error Handling
```typescript
/**
 * Try operation with fallback
 * @param operation - Operation to try
 * @param fallback - Fallback value
 * @returns Result or fallback
 */
function tryOr<T>(
    operation: () => T,
    fallback: T
): T;

/**
 * Try async operation
 * @param operation - Async operation
 * @returns Result or error
 */
async function tryAsync<T>(
    operation: () => Promise<T>
): Promise<Result<T>>;

/**
 * Handle error with handler
 * @param error - Error to handle
 * @param handler - Error handler
 * @returns Handled result
 */
function handleError<T>(
    error: Error,
    handler: (error: Error) => T
): T;
```

## 8. Integration Examples

### 8.1 Type Integration
```typescript
import { BaseType } from '@jadugar/types';
import { isString, validate } from '@jadugar/utils';

// Validate type
function processType(data: unknown): BaseType {
    if (!validate<BaseType>(data, schema)) {
        throw createTypeError('Invalid type');
    }
    return data;
}
```

### 8.2 Core Integration
```typescript
import { CoreService } from '@jadugar/core';
import { tryAsync, handleError } from '@jadugar/utils';

// Process with error handling
async function process(data: unknown) {
    const result = await tryAsync(async () => {
        return CoreService.process(data);
    });
    
    return handleError(result, (error) => {
        // Handle error
        return fallback;
    });
}
```

## 9. Best Practices

### 9.1 Type Safety
1. Always use type guards
2. Validate unknown data
3. Handle type errors
4. Document types

### 9.2 Performance
1. Cache results
2. Optimize loops
3. Minimize allocations
4. Profile operations

## 10. Migration Guide

### 10.1 Version 2.x
1. Breaking Changes
   - New validation API
   - Stricter type checks
   - Updated utilities
   - Changed defaults

2. Migration Steps
   - Update imports
   - Update validators
   - Fix type errors
   - Test changes
