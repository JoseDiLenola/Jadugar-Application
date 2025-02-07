# Validation Interfaces

## IValidator

The base validator interface that all other validators extend.

### Methods

```typescript
interface IValidator<T = unknown> {
  validate(data: T): Promise<ValidationResult>;
  addRule(name: string, rule: ValidationRule<T>): void;
  removeRule(name: string): void;
  getRules(): Map<string, ValidationRule<T>>;
}
```

### Usage Example

```typescript
class UserValidator implements IValidator<User> {
  private rules = new Map<string, ValidationRule<User>>();

  constructor() {
    this.addRule('email', async (user) => {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return {
        valid: emailRegex.test(user.email),
        errors: emailRegex.test(user.email) ? undefined : [{
          path: 'email',
          message: 'Invalid email format',
          code: 'INVALID_EMAIL'
        }]
      };
    });
  }

  async validate(user: User): Promise<ValidationResult> {
    const results = await Promise.all(
      Array.from(this.rules.values()).map(rule => rule(user))
    );
    
    return results.reduce((acc, result) => ({
      valid: acc.valid && result.valid,
      errors: [...(acc.errors || []), ...(result.errors || [])]
    }), { valid: true });
  }

  // ... other implementations
}
```

## ISchemaValidator

JSON Schema-based validator with caching support.

### Methods

```typescript
interface ISchemaValidator extends IValidator {
  addSchema(name: string, schema: JsonSchema): void;
  removeSchema(name: string): void;
  getSchema(name: string): JsonSchema | null;
  clearCache(): void;
}
```

### Usage Example

```typescript
class JsonSchemaValidator implements ISchemaValidator {
  private schemas = new Map<string, JsonSchema>();
  private cache = new Map<string, ValidationResult>();

  async validate(data: unknown): Promise<ValidationResult> {
    const cacheKey = JSON.stringify(data);
    if (this.cache.has(cacheKey)) {
      return this.cache.get(cacheKey)!;
    }

    // Validate against schema
    const result = await this.validateAgainstSchema(data);
    this.cache.set(cacheKey, result);
    return result;
  }

  addSchema(name: string, schema: JsonSchema) {
    this.schemas.set(name, schema);
    this.clearCache(); // Invalidate cache when schema changes
  }

  // ... other implementations
}
```

## IHipaaValidator

HIPAA compliance validator for healthcare data.

### Methods

```typescript
interface IHipaaValidator extends IValidator {
  validatePHI(data: unknown): Promise<ValidationResult>;
  containsPHI(data: unknown): boolean;
  getHipaaRules(): Map<string, ValidationRule<unknown>>;
}
```

### Usage Example

```typescript
class HipaaValidator implements IHipaaValidator {
  private phiRules = new Map<string, ValidationRule<unknown>>();

  constructor() {
    this.addHipaaRule('ssn', data => ({
      valid: this.validateSSN(data),
      errors: this.validateSSN(data) ? undefined : [{
        path: 'ssn',
        message: 'Invalid SSN format',
        code: 'INVALID_SSN'
      }]
    }));
  }

  async validatePHI(data: unknown): Promise<ValidationResult> {
    if (!this.containsPHI(data)) {
      return { valid: true };
    }

    return this.validate(data);
  }

  containsPHI(data: unknown): boolean {
    // Check for PHI markers
    return true;
  }

  // ... other implementations
}
```

## ITenantValidator

Multi-tenant validation support.

### Methods

```typescript
interface ITenantValidator extends IValidator {
  validateForTenant(tenantId: string, data: unknown): Promise<ValidationResult>;
  addTenantRules(tenantId: string, rules: Map<string, ValidationRule<unknown>>): void;
  removeTenantRules(tenantId: string): void;
}
```

### Usage Example

```typescript
class TenantValidator implements ITenantValidator {
  private tenantRules = new Map<string, Map<string, ValidationRule<unknown>>>();

  async validateForTenant(tenantId: string, data: unknown): Promise<ValidationResult> {
    const rules = this.tenantRules.get(tenantId);
    if (!rules) {
      return { valid: true };
    }

    const results = await Promise.all(
      Array.from(rules.values()).map(rule => rule(data))
    );

    return results.reduce((acc, result) => ({
      valid: acc.valid && result.valid,
      errors: [...(acc.errors || []), ...(result.errors || [])]
    }), { valid: true });
  }

  // ... other implementations
}
```

## IOfflineValidator

Offline-first validation support.

### Methods

```typescript
interface IOfflineValidator extends IValidator {
  enableOffline(): void;
  disableOffline(): void;
  isOfflineEnabled(): boolean;
  syncRules(): Promise<void>;
}
```

### Usage Example

```typescript
class OfflineValidator implements IOfflineValidator {
  private offlineEnabled = false;
  private localRules = new Map<string, ValidationRule<unknown>>();
  private serverRules = new Map<string, ValidationRule<unknown>>();

  async validate(data: unknown): Promise<ValidationResult> {
    const rules = this.offlineEnabled ? this.localRules : this.serverRules;
    const results = await Promise.all(
      Array.from(rules.values()).map(rule => rule(data))
    );

    return results.reduce((acc, result) => ({
      valid: acc.valid && result.valid,
      errors: [...(acc.errors || []), ...(result.errors || [])]
    }), { valid: true });
  }

  async syncRules(): Promise<void> {
    // Sync rules with server
    this.localRules = new Map(this.serverRules);
  }

  // ... other implementations
}
```

## ICompositeValidator

Combined validation strategies.

### Methods

```typescript
interface ICompositeValidator extends IValidator {
  addValidator(name: string, validator: IValidator): void;
  removeValidator(name: string): void;
  getValidators(): Map<string, IValidator>;
  setStrategy(strategy: ValidationStrategy): void;
}
```

### Usage Example

```typescript
class CompositeValidator implements ICompositeValidator {
  private validators = new Map<string, IValidator>();
  private strategy: ValidationStrategy = 'all';

  async validate(data: unknown): Promise<ValidationResult> {
    const results = await Promise.all(
      Array.from(this.validators.values()).map(validator => validator.validate(data))
    );

    switch (this.strategy) {
      case 'all':
        return this.validateAll(results);
      case 'any':
        return this.validateAny(results);
      case 'majority':
        return this.validateMajority(results);
      default:
        throw new Error(`Unknown strategy: ${this.strategy}`);
    }
  }

  setStrategy(strategy: ValidationStrategy) {
    this.strategy = strategy;
  }

  // ... other implementations
}
```

## Best Practices

1. **Performance**
   - Use caching for expensive validations
   - Implement batch validation where possible
   - Support async validation

2. **Error Handling**
   - Provide detailed validation errors
   - Include error paths for nested objects
   - Support custom error messages

3. **Extensibility**
   - Allow custom validation rules
   - Support plugin validators
   - Enable rule composition

4. **Security**
   - Sanitize input data
   - Validate against injection attacks
   - Implement rate limiting

5. **Testing**
   - Test all validation rules
   - Include edge cases
   - Test performance with large datasets
