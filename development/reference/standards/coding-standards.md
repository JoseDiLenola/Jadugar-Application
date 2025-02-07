# Coding Standards

## Overview
This document defines the coding standards for the Jadugar project, ensuring consistency and maintainability across the codebase.

## TypeScript Standards

### 1. Type Definitions
```typescript
// ✅ DO: Use explicit types
interface User {
  id: string;
  name: string;
  email: string;
}

// ❌ DON'T: Use any
const user: any = { /* ... */ };

// ✅ DO: Use unknown for truly unknown types
function processData(data: unknown) {
  if (typeof data === 'string') {
    // Type-safe operation
  }
}
```

### 2. Type Assertions
```typescript
// ✅ DO: Use type guards
function isUser(value: unknown): value is User {
  return (
    typeof value === 'object' &&
    value !== null &&
    'id' in value &&
    'name' in value &&
    'email' in value
  );
}

// ❌ DON'T: Use type assertions without checks
const user = data as User;

// ✅ DO: Use safe type assertions
if (isUser(data)) {
  const user = data; // Type-safe
}
```

### 3. Generics
```typescript
// ✅ DO: Use descriptive generic names
interface Repository<TEntity> {
  find(id: string): Promise<TEntity>;
}

// ❌ DON'T: Use single letters
interface Cache<T> {
  get(key: string): T;
}

// ✅ DO: Use constraints when needed
interface DataService<TEntity extends { id: string }> {
  getById(id: string): Promise<TEntity>;
}
```

## React Standards

### 1. Component Structure
```typescript
// ✅ DO: Use functional components
const UserCard: React.FC<UserCardProps> = ({
  user,
  onEdit,
}) => {
  return (
    // Implementation
  );
};

// ❌ DON'T: Use class components
class UserCard extends React.Component {
  // Implementation
}
```

### 2. Props
```typescript
// ✅ DO: Define prop interfaces
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

// ❌ DON'T: Use loose prop types
const Button = (props: any) => {
  // Implementation
};

// ✅ DO: Use destructuring
const Button: React.FC<ButtonProps> = ({
  label,
  onClick,
  variant = 'primary',
  disabled = false,
}) => {
  // Implementation
};
```

### 3. Hooks
```typescript
// ✅ DO: Use typed hooks
function useUser(id: string) {
  const [user, setUser] = useState<User | null>(null);
  // Implementation
}

// ❌ DON'T: Skip dependency arrays
useEffect(() => {
  // Side effect
}); // Missing dependency array

// ✅ DO: Use proper dependencies
useEffect(() => {
  // Side effect
}, [id, callback]);
```

## Style Standards

### 1. StyleSheet
```typescript
// ✅ DO: Use StyleSheet.create
const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: spacing.medium,
  },
  title: {
    fontSize: typography.h1,
    color: colors.text,
  },
});

// ❌ DON'T: Use inline styles
<View style={{ flex: 1, padding: 16 }} />;

// ✅ DO: Use theme values
<View style={[styles.container, { backgroundColor: theme.colors.background }]} />;
```

### 2. Theme Usage
```typescript
// ✅ DO: Use theme constants
const theme = {
  colors: {
    primary: '#007AFF',
    text: '#000000',
  },
  spacing: {
    small: 8,
    medium: 16,
  },
};

// ❌ DON'T: Hardcode values
const styles = StyleSheet.create({
  container: {
    padding: 16, // Bad: Magic number
  },
});

// ✅ DO: Reference theme
const styles = StyleSheet.create({
  container: {
    padding: theme.spacing.medium,
  },
});
```

## File Organization

### 1. Directory Structure
```
src/
├── components/
│   ├── Button/
│   │   ├── index.tsx
│   │   ├── styles.ts
│   │   └── types.ts
│   └── Card/
├── hooks/
│   └── useUser.ts
├── services/
│   └── api.ts
└── utils/
    └── helpers.ts
```

### 2. File Naming
```
// ✅ DO: Use consistent casing
MyComponent.tsx
useMyHook.ts
my-util.ts

// ❌ DON'T: Mix cases
myComponent.tsx
Use_hook.ts
UTIL.ts
```

### 3. Exports
```typescript
// ✅ DO: Use named exports
export interface Props {
  // ...
}
export const MyComponent: React.FC<Props> = () => {
  // ...
};

// ❌ DON'T: Use default exports
export default MyComponent;

// ✅ DO: Use barrel exports
export * from './Button';
export * from './Card';
```

## Documentation Standards

### 1. Component Documentation
```typescript
/**
 * Button component with customizable variants.
 *
 * @param props - Component props
 * @param props.label - Button text
 * @param props.onClick - Click handler
 * @param props.variant - Visual style variant
 * @param props.disabled - Disabled state
 *
 * @example
 * ```tsx
 * <Button
 *   label="Submit"
 *   onClick={handleSubmit}
 *   variant="primary"
 * />
 * ```
 */
const Button: React.FC<ButtonProps> = (props) => {
  // Implementation
};
```

### 2. Function Documentation
```typescript
/**
 * Formats a date string to a localized format.
 *
 * @param date - ISO date string
 * @param locale - Locale string (e.g., 'en-US')
 * @returns Formatted date string
 *
 * @throws {Error} If date string is invalid
 *
 * @example
 * ```ts
 * const formatted = formatDate('2025-02-05', 'en-US');
 * console.log(formatted); // "February 5, 2025"
 * ```
 */
function formatDate(date: string, locale: string): string {
  // Implementation
}
```

## Verification

### 1. ESLint Rules
```json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended"
  ],
  "rules": {
    "@typescript-eslint/explicit-function-return-type": "error",
    "@typescript-eslint/no-explicit-any": "error",
    "react/prop-types": "off"
  }
}
```

### 2. Prettier Configuration
```json
{
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 80,
  "tabWidth": 2,
  "semi": true
}
```

## Common Issues

### 1. Type Issues
```typescript
// ❌ Problem: Type widening
let id = '123'; // Type: string
id = 123; // Error: Type 'number' not assignable

// ✅ Solution: Explicit types
let id: string = '123';
```

### 2. Hook Issues
```typescript
// ❌ Problem: Stale closures
function Counter() {
  const [count, setCount] = useState(0);
  useEffect(() => {
    const timer = setInterval(() => {
      setCount(count + 1); // Stale closure
    }, 1000);
    return () => clearInterval(timer);
  }, []); // Missing dependency

  return <div>{count}</div>;
}

// ✅ Solution: Functional updates
function Counter() {
  const [count, setCount] = useState(0);
  useEffect(() => {
    const timer = setInterval(() => {
      setCount(c => c + 1); // Functional update
    }, 1000);
    return () => clearInterval(timer);
  }, []); // No dependencies needed

  return <div>{count}</div>;
}
```

## Verification Checklist
- [ ] TypeScript strict mode enabled
- [ ] ESLint configuration applied
- [ ] Prettier configuration applied
- [ ] No lint errors
- [ ] Documentation complete
- [ ] Type coverage complete

## Next Steps
1. Set up automated linting
2. Configure CI checks
3. Add documentation generation

## Resources
- [TypeScript Guidelines](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html)
- [React Patterns](https://reactpatterns.com/)
- [ESLint Rules](https://eslint.org/docs/rules/)
