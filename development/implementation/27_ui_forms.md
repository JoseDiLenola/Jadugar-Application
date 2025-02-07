# @jadugar/ui Form System

This document specifies the form system implementation for the Jadugar UI package. The form system provides comprehensive form handling with validation, state management, and dynamic form generation.

## Form Architecture

### Form Manager

```typescript
interface FormOptions {
  validators?: FormValidator[];
  transformers?: FormTransformer[];
  plugins?: FormPlugin[];
  persistence?: FormPersistence;
}

class FormManager {
  constructor(options: FormOptions);
  
  // Form Operations
  create(schema: FormSchema): Form;
  validate(form: Form): ValidationResult;
  
  // System Management
  register(plugin: FormPlugin): void;
  unregister(name: string): void;
  
  // Configuration
  configure(options: FormOptions): void;
  getConfig(): FormConfig;
}
```

## Form Components

### Base Form

```typescript
interface FormProps {
  schema: FormSchema;
  initialValues?: FormValues;
  onSubmit?: (values: FormValues) => void;
  onValidate?: (values: FormValues) => ValidationResult;
}

class Form {
  constructor(props: FormProps);
  
  // Form Operations
  submit(): Promise<void>;
  reset(): void;
  
  // State Management
  setValues(values: Partial<FormValues>): void;
  setErrors(errors: ValidationErrors): void;
  
  // Field Management
  registerField(field: FormField): void;
  unregisterField(name: string): void;
}
```

### Form Field

```typescript
interface FieldProps {
  name: string;
  type: FieldType;
  label?: string;
  value?: any;
  validation?: ValidationRule[];
}

class FormField {
  constructor(props: FieldProps);
  
  // Field Operations
  setValue(value: any): void;
  setError(error: string): void;
  
  // State Management
  validate(): ValidationResult;
  reset(): void;
  
  // Event Handling
  onChange(value: any): void;
  onBlur(): void;
}
```

## Form Validation

### Validation System

```typescript
interface ValidationOptions {
  mode?: 'onChange' | 'onBlur' | 'onSubmit';
  stopOnFirst?: boolean;
  parallel?: boolean;
}

class ValidationManager {
  constructor(options: ValidationOptions);
  
  // Validation Operations
  validate(values: FormValues, rules: ValidationRule[]): ValidationResult;
  validateField(value: any, rules: ValidationRule[]): ValidationResult;
  
  // Rule Management
  addRule(rule: ValidationRule): void;
  removeRule(name: string): void;
}
```

### Validation Rules

```typescript
interface ValidationRule {
  name: string;
  message: string;
  
  // Rule Operations
  validate(value: any, options?: any): boolean | Promise<boolean>;
  getMessage(value: any, options?: any): string;
  
  // Rule Management
  configure(options: RuleOptions): void;
  isAsync(): boolean;
}
```

## Form State

### State Management

```typescript
interface FormState {
  values: FormValues;
  errors: ValidationErrors;
  touched: TouchedFields;
  dirty: DirtyFields;
  isSubmitting: boolean;
  isValidating: boolean;
}

class FormStateManager {
  constructor(initialState: Partial<FormState>);
  
  // State Operations
  setState(state: Partial<FormState>): void;
  getState(): FormState;
  
  // Field State
  setFieldValue(name: string, value: any): void;
  setFieldError(name: string, error: string): void;
  
  // Batch Operations
  batch(updates: StateUpdate[]): void;
  subscribe(listener: StateListener): Unsubscribe;
}
```

### Field Array

```typescript
interface ArrayFieldProps {
  name: string;
  initialValues?: any[];
  validation?: ValidationRule[];
}

class FieldArray {
  constructor(props: ArrayFieldProps);
  
  // Array Operations
  push(value: any): void;
  remove(index: number): void;
  insert(index: number, value: any): void;
  move(from: number, to: number): void;
  
  // State Management
  getValue(): any[];
  setValue(values: any[]): void;
}
```

## Form Generation

### Schema System

```typescript
interface SchemaOptions {
  components?: FormComponents;
  layouts?: FormLayouts;
  transformers?: SchemaTransformer[];
}

class SchemaGenerator {
  constructor(options: SchemaOptions);
  
  // Generation Operations
  generate(schema: FormSchema): Form;
  preview(schema: FormSchema): FormPreview;
  
  // Component Management
  registerComponent(component: FormComponent): void;
  unregisterComponent(name: string): void;
}
```

### Dynamic Forms

```typescript
interface DynamicFormProps {
  schema: FormSchema;
  data?: FormData;
  onChange?: (data: FormData) => void;
}

class DynamicForm {
  constructor(props: DynamicFormProps);
  
  // Form Operations
  update(schema: Partial<FormSchema>): void;
  reset(): void;
  
  // Data Management
  setData(data: FormData): void;
  getData(): FormData;
}
```

## Form Persistence

### Persistence System

```typescript
interface PersistenceOptions {
  storage?: Storage;
  key?: string;
  debounce?: number;
}

class FormPersistence {
  constructor(options: PersistenceOptions);
  
  // Persistence Operations
  save(form: Form): Promise<void>;
  load(form: Form): Promise<void>;
  
  // State Management
  clear(): Promise<void>;
  restore(): Promise<FormState>;
}
```

### Auto Save

```typescript
interface AutoSaveOptions {
  interval?: number;
  condition?: (state: FormState) => boolean;
  onSave?: (state: FormState) => void;
}

class AutoSave {
  constructor(form: Form, options: AutoSaveOptions);
  
  // Save Operations
  start(): void;
  stop(): void;
  
  // State Management
  isPaused(): boolean;
  getLastSave(): Date;
}
```

## Implementation Notes

1. Form Design
   - Field composition
   - Layout system
   - Error display
   - Loading states

2. Validation
   - Async validation
   - Cross-field validation
   - Custom rules
   - Error messages

3. Performance
   - State updates
   - Validation timing
   - Field arrays
   - Form generation

4. Integration
   - Data binding
   - API integration
   - File uploads
   - Custom fields

5. Best Practices
   - Error handling
   - Accessibility
   - UX patterns
   - Testing strategies

## Testing Requirements

1. Form Tests
   - Submission
   - Reset
   - State updates
   - Event handling

2. Validation Tests
   - Rule execution
   - Error messages
   - Async validation
   - Cross-field rules

3. Field Tests
   - Value updates
   - Event handling
   - Array operations
   - Custom components

4. Integration Tests
   - Data flow
   - API calls
   - File handling
   - State persistence

## Usage Examples

### Basic Form

```typescript
const form = new Form({
  schema: {
    fields: {
      email: {
        type: 'email',
        label: 'Email Address',
        validation: [
          { type: 'required' },
          { type: 'email' }
        ]
      },
      password: {
        type: 'password',
        label: 'Password',
        validation: [
          { type: 'required' },
          { type: 'minLength', value: 8 }
        ]
      }
    }
  },
  onSubmit: async (values) => {
    await submitForm(values);
  }
});
```

### Dynamic Form

```typescript
const dynamicForm = new DynamicForm({
  schema: {
    fields: {
      type: {
        type: 'select',
        options: ['personal', 'business']
      }
    },
    conditions: {
      'type === "business"': {
        fields: {
          companyName: {
            type: 'text',
            required: true
          }
        }
      }
    }
  }
});

// Update form based on data
dynamicForm.setData({
  type: 'business',
  companyName: 'Acme Inc'
});
```

### Field Array

```typescript
const contacts = new FieldArray({
  name: 'contacts',
  initialValues: [],
  validation: [
    { type: 'minItems', value: 1 }
  ]
});

// Add new contact
contacts.push({
  name: '',
  email: ''
});

// Remove contact
contacts.remove(0);

// Move contact
contacts.move(0, 2);
```

### Form Persistence

```typescript
const persistence = new FormPersistence({
  storage: localStorage,
  key: 'user-form',
  debounce: 1000
});

// Auto-save form
const autoSave = new AutoSave(form, {
  interval: 5000,
  condition: (state) => state.dirty,
  onSave: (state) => {
    console.log('Form saved:', state);
  }
});

autoSave.start();
```
