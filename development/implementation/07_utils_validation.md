# Validation Utilities

This document specifies the validation utilities for the Jadugar project. These utilities provide a robust, type-safe validation system that can be used across all packages.

## Core Validation Types

### ValidationResult

```typescript
interface ValidationResult {
  valid: boolean;
  errors: ValidationError[];
  warnings?: ValidationWarning[];
  meta?: Record<string, unknown>;
}

interface ValidationError {
  field: string;
  code: string;
  message: string;
  path?: string[];
  details?: Record<string, unknown>;
}

interface ValidationWarning {
  field: string;
  code: string;
  message: string;
  severity: 'low' | 'medium' | 'high';
  suggestion?: string;
}
```

### Validator Interface

```typescript
interface Validator<T> {
  validate(value: unknown): ValidationResult;
  isValid(value: unknown): value is T;
}
```

## String Validation

### StringValidator

```typescript
interface StringValidationOptions {
  minLength?: number;
  maxLength?: number;
  pattern?: RegExp;
  allowEmpty?: boolean;
  trim?: boolean;
  transform?: (value: string) => string;
}

class StringValidator implements Validator<string> {
  constructor(options?: StringValidationOptions);
  validate(value: unknown): ValidationResult;
  isValid(value: unknown): value is string;
}
```

### EmailValidator

```typescript
interface EmailValidationOptions {
  allowLocalDomains?: boolean;
  allowIPDomains?: boolean;
  checkDNS?: boolean;
  customPatterns?: RegExp[];
}

class EmailValidator extends StringValidator {
  constructor(options?: EmailValidationOptions);
}
```

## Number Validation

### NumberValidator

```typescript
interface NumberValidationOptions {
  min?: number;
  max?: number;
  integer?: boolean;
  positive?: boolean;
  precision?: number;
  allowNaN?: boolean;
  allowInfinity?: boolean;
}

class NumberValidator implements Validator<number> {
  constructor(options?: NumberValidationOptions);
  validate(value: unknown): ValidationResult;
  isValid(value: unknown): value is number;
}
```

## Object Validation

### ObjectValidator

```typescript
interface ObjectValidationOptions {
  strict?: boolean;
  allowNull?: boolean;
  allowExtraFields?: boolean;
  requiredFields?: string[];
}

class ObjectValidator<T extends object> implements Validator<T> {
  constructor(schema: Record<keyof T, Validator<any>>, options?: ObjectValidationOptions);
  validate(value: unknown): ValidationResult;
  isValid(value: unknown): value is T;
}
```

## Array Validation

### ArrayValidator

```typescript
interface ArrayValidationOptions {
  minLength?: number;
  maxLength?: number;
  unique?: boolean;
  sort?: boolean;
}

class ArrayValidator<T> implements Validator<T[]> {
  constructor(itemValidator: Validator<T>, options?: ArrayValidationOptions);
  validate(value: unknown): ValidationResult;
  isValid(value: unknown): value is T[];
}
```

## Date Validation

### DateValidator

```typescript
interface DateValidationOptions {
  min?: Date;
  max?: Date;
  future?: boolean;
  past?: boolean;
  timezone?: string;
}

class DateValidator implements Validator<Date> {
  constructor(options?: DateValidationOptions);
  validate(value: unknown): ValidationResult;
  isValid(value: unknown): value is Date;
}
```

## Custom Validation

### CustomValidator

```typescript
type ValidationFunction<T> = (value: unknown) => ValidationResult;

class CustomValidator<T> implements Validator<T> {
  constructor(fn: ValidationFunction<T>);
  validate(value: unknown): ValidationResult;
  isValid(value: unknown): value is T;
}
```

## Validation Pipeline

### ValidationPipeline

```typescript
interface ValidationPipelineOptions {
  stopOnFirstError?: boolean;
  parallel?: boolean;
  timeout?: number;
}

class ValidationPipeline<T> implements Validator<T> {
  constructor(validators: Validator<T>[], options?: ValidationPipelineOptions);
  validate(value: unknown): ValidationResult;
  isValid(value: unknown): value is T;
}
```

## Validation Messages

```typescript
const ValidationMessages = {
  String: {
    INVALID_TYPE: 'Value must be a string',
    TOO_SHORT: 'String is too short',
    TOO_LONG: 'String is too long',
    PATTERN_MISMATCH: 'String does not match required pattern',
    EMPTY_NOT_ALLOWED: 'Empty string is not allowed',
  },
  Number: {
    INVALID_TYPE: 'Value must be a number',
    TOO_SMALL: 'Number is too small',
    TOO_LARGE: 'Number is too large',
    NOT_INTEGER: 'Number must be an integer',
    INVALID_PRECISION: 'Number has invalid precision',
  },
  Array: {
    INVALID_TYPE: 'Value must be an array',
    TOO_FEW: 'Array has too few items',
    TOO_MANY: 'Array has too many items',
    DUPLICATE_ITEMS: 'Array contains duplicate items',
  },
  Object: {
    INVALID_TYPE: 'Value must be an object',
    MISSING_REQUIRED: 'Required field is missing',
    EXTRA_FIELDS: 'Object contains extra fields',
    INVALID_FIELD: 'Field has invalid value',
  },
  Date: {
    INVALID_TYPE: 'Value must be a date',
    INVALID_FORMAT: 'Invalid date format',
    TOO_EARLY: 'Date is too early',
    TOO_LATE: 'Date is too late',
    INVALID_TIMEZONE: 'Invalid timezone',
  },
} as const;
```

## Usage Examples

### Basic String Validation

```typescript
const nameValidator = new StringValidator({
  minLength: 2,
  maxLength: 50,
  trim: true,
});

const result = nameValidator.validate('John Doe');
```

### Complex Object Validation

```typescript
const userValidator = new ObjectValidator({
  email: new EmailValidator(),
  age: new NumberValidator({ min: 18, integer: true }),
  roles: new ArrayValidator(new StringValidator()),
  profile: new ObjectValidator({
    name: new StringValidator({ minLength: 2 }),
    bio: new StringValidator({ allowEmpty: true }),
  }),
});

const result = userValidator.validate({
  email: 'user@example.com',
  age: 25,
  roles: ['user', 'admin'],
  profile: {
    name: 'John',
    bio: '',
  },
});
```

### Validation Pipeline

```typescript
const passwordValidator = new ValidationPipeline([
  new StringValidator({ minLength: 8 }),
  new CustomValidator((value) => {
    const hasUpperCase = /[A-Z]/.test(value as string);
    const hasNumber = /[0-9]/.test(value as string);
    return {
      valid: hasUpperCase && hasNumber,
      errors: [],
    };
  }),
]);
```

## Implementation Notes

1. All validators should be immutable and thread-safe
2. Validation should be performant and avoid unnecessary object creation
3. Error messages should be clear and actionable
4. Support both synchronous and asynchronous validation
5. Provide type inference for TypeScript users
6. Support custom error messages and localization
7. Allow extension and composition of validators
8. Maintain consistent error formats across all validators

## Testing Requirements

1. Unit tests for each validator class
2. Integration tests for complex validation scenarios
3. Performance tests for large objects/arrays
4. Edge case testing for all validation options
5. Type safety tests for TypeScript integration
6. Async validation testing
7. Error message format consistency tests
8. Memory leak tests for large validation chains
