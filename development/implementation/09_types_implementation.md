# @jadugar/types Implementation Guide

This document provides detailed implementation instructions for the `@jadugar/types` package. Follow these instructions to generate the complete type system.

## Package Structure

```
@jadugar/types/
├── src/
│   ├── api/
│   │   ├── index.ts
│   │   ├── request.ts
│   │   ├── response.ts
│   │   └── types.ts
│   ├── auth/
│   │   ├── index.ts
│   │   ├── permissions.ts
│   │   ├── roles.ts
│   │   └── types.ts
│   ├── common/
│   │   ├── index.ts
│   │   ├── errors.ts
│   │   └── validation.ts
│   ├── config/
│   │   ├── index.ts
│   │   ├── env.ts
│   │   └── types.ts
│   ├── logging/
│   │   ├── index.ts
│   │   ├── formatters.ts
│   │   └── types.ts
│   ├── utils/
│   │   ├── index.ts
│   │   ├── date/
│   │   │   ├── index.ts
│   │   │   ├── calendar.ts
│   │   │   ├── datetime.ts
│   │   │   ├── duration.ts
│   │   │   ├── interval.ts
│   │   │   └── timezone.ts
│   │   ├── validation/
│   │   │   ├── index.ts
│   │   │   ├── array.ts
│   │   │   ├── date.ts
│   │   │   ├── number.ts
│   │   │   ├── object.ts
│   │   │   └── string.ts
│   │   └── guards/
│   │       ├── index.ts
│   │       ├── api.ts
│   │       ├── auth.ts
│   │       └── common.ts
│   └── index.ts
├── tests/
│   ├── api/
│   ├── auth/
│   ├── config/
│   ├── logging/
│   └── utils/
├── package.json
├── tsconfig.json
└── README.md
```

## Implementation Steps

### 1. Package Setup

```json
{
  "name": "@jadugar/types",
  "version": "0.1.0",
  "private": true,
  "main": "dist/index.js",
  "module": "dist/index.mjs",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsup",
    "test": "jest",
    "lint": "eslint src",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "date-fns": "^2.30.0",
    "date-fns-tz": "^2.0.0",
    "zod": "^3.22.0"
  },
  "devDependencies": {
    "@types/jest": "^29.5.0",
    "@types/node": "^20.0.0",
    "tsup": "^7.0.0",
    "typescript": "^5.0.0"
  }
}
```

### 2. Type Definitions

#### Common Types (src/common/types.ts)

```typescript
export interface Result<T, E = Error> {
  success: boolean;
  data?: T;
  error?: E;
}

export interface Metadata {
  timestamp: number;
  correlationId?: string;
  requestId?: string;
  [key: string]: unknown;
}

export interface Pagination {
  page: number;
  limit: number;
  total?: number;
  hasMore?: boolean;
}
```

#### API Types (src/api/types.ts)

```typescript
import { Metadata, Pagination } from '../common/types';

export interface ApiRequest<T = unknown> {
  path: string;
  method: HttpMethod;
  headers: Record<string, string>;
  query?: Record<string, string>;
  body?: T;
  metadata: Metadata;
}

export interface ApiResponse<T = unknown> {
  status: number;
  headers: Record<string, string>;
  body?: T;
  metadata: Metadata;
  pagination?: Pagination;
}
```

### 3. Validation Implementation

#### String Validator (src/utils/validation/string.ts)

```typescript
import { z } from 'zod';
import { Validator, ValidationResult } from './types';

export class StringValidator implements Validator<string> {
  private schema: z.ZodString;

  constructor(options?: StringValidationOptions) {
    this.schema = z.string();
    
    if (options?.minLength) {
      this.schema = this.schema.min(options.minLength);
    }
    
    if (options?.maxLength) {
      this.schema = this.schema.max(options.maxLength);
    }
    
    if (options?.pattern) {
      this.schema = this.schema.regex(options.pattern);
    }
  }

  validate(value: unknown): ValidationResult {
    const result = this.schema.safeParse(value);
    
    if (result.success) {
      return { valid: true, errors: [] };
    }
    
    return {
      valid: false,
      errors: result.error.errors.map(err => ({
        field: err.path.join('.'),
        code: err.code,
        message: err.message
      }))
    };
  }

  isValid(value: unknown): value is string {
    return this.schema.safeParse(value).success;
  }
}
```

### 4. Date Utilities Implementation

#### DateTime (src/utils/date/datetime.ts)

```typescript
import {
  format,
  parse,
  addDays,
  subDays,
  differenceInMilliseconds
} from 'date-fns';
import { zonedTimeToUtc, utcToZonedTime } from 'date-fns-tz';

export class DateTime {
  private readonly date: Date;
  private readonly timeZone: string;

  constructor(date: Date, timeZone: string = 'UTC') {
    this.date = date;
    this.timeZone = timeZone;
  }

  static now(timeZone?: string): DateTime {
    return new DateTime(new Date(), timeZone);
  }

  static fromISO(text: string, timeZone?: string): DateTime {
    const date = new Date(text);
    return new DateTime(date, timeZone);
  }

  toISO(): string {
    return this.date.toISOString();
  }

  toZone(timeZone: string): DateTime {
    const zonedDate = utcToZonedTime(this.date, timeZone);
    return new DateTime(zonedDate, timeZone);
  }

  plus(duration: Duration): DateTime {
    const newDate = addDays(this.date, duration.days);
    return new DateTime(newDate, this.timeZone);
  }

  minus(duration: Duration): DateTime {
    const newDate = subDays(this.date, duration.days);
    return new DateTime(newDate, this.timeZone);
  }

  diff(other: DateTime): Duration {
    const diffMs = differenceInMilliseconds(
      this.date,
      other.date
    );
    return Duration.fromMillis(diffMs);
  }
}
```

### 5. Type Guards Implementation

#### API Guards (src/utils/guards/api.ts)

```typescript
import { ApiRequest, ApiResponse } from '../../api/types';

export function isApiRequest(value: unknown): value is ApiRequest {
  if (!value || typeof value !== 'object') return false;
  
  const req = value as Partial<ApiRequest>;
  
  return (
    typeof req.path === 'string' &&
    typeof req.method === 'string' &&
    typeof req.headers === 'object' &&
    (!req.query || typeof req.query === 'object') &&
    (!req.body || typeof req.body === 'object') &&
    typeof req.metadata === 'object'
  );
}

export function isApiResponse(value: unknown): value is ApiResponse {
  if (!value || typeof value !== 'object') return false;
  
  const res = value as Partial<ApiResponse>;
  
  return (
    typeof res.status === 'number' &&
    typeof res.headers === 'object' &&
    (!res.body || typeof res.body === 'object') &&
    typeof res.metadata === 'object' &&
    (!res.pagination || typeof res.pagination === 'object')
  );
}
```

## Testing Strategy

### 1. Unit Tests

```typescript
// src/utils/validation/__tests__/string.test.ts
import { StringValidator } from '../string';

describe('StringValidator', () => {
  it('validates string length correctly', () => {
    const validator = new StringValidator({
      minLength: 2,
      maxLength: 5
    });
    
    expect(validator.validate('abc').valid).toBe(true);
    expect(validator.validate('a').valid).toBe(false);
    expect(validator.validate('abcdef').valid).toBe(false);
  });
});
```

### 2. Integration Tests

```typescript
// tests/integration/validation.test.ts
import {
  StringValidator,
  ObjectValidator,
  ArrayValidator
} from '../../src/utils/validation';

describe('Validation Integration', () => {
  it('validates complex objects', () => {
    const validator = new ObjectValidator({
      name: new StringValidator({ minLength: 2 }),
      tags: new ArrayValidator(
        new StringValidator({ maxLength: 10 })
      )
    });
    
    const result = validator.validate({
      name: 'John',
      tags: ['tag1', 'tag2']
    });
    
    expect(result.valid).toBe(true);
  });
});
```

## Build Configuration

### tsconfig.json

```json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

### tsup.config.ts

```typescript
import { defineConfig } from 'tsup';

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['cjs', 'esm'],
  dts: true,
  splitting: false,
  sourcemap: true,
  clean: true
});
```

## Implementation Notes

1. Use strict TypeScript configuration
2. Implement proper error handling
3. Add comprehensive JSDoc comments
4. Follow consistent naming conventions
5. Use immutable patterns where possible
6. Implement proper null checks
7. Add debug logging where appropriate
8. Use proper error messages

## Validation Requirements

1. All types must be properly exported
2. No any types allowed
3. Full test coverage required
4. Documentation must be complete
5. All utilities must be immutable
6. Performance benchmarks must pass
7. Memory usage must be optimized
8. No circular dependencies

## Next Steps

1. Implement the package structure
2. Add core type definitions
3. Implement validation system
4. Add date utilities
5. Implement type guards
6. Add comprehensive tests
7. Generate documentation
8. Perform integration testing
