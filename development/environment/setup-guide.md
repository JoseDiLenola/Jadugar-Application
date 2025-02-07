# Environment Setup Guide

## Overview
This guide provides instructions for setting up the development environment for Jadugar. Our configuration system follows strict principles of data minimization, type safety, and performance optimization.

## Prerequisites

### Required Software
- Node.js (v18.x)
- Yarn (v1.22.x)
- Git (v2.x)
- AWS CLI (v2.x)
- Docker (optional, for local development)

### Development Tools
- VS Code (recommended)
- ESLint extension
- TypeScript extension
- Jest extension

## Initial Setup

### 1. Clone the Repository
```bash
git clone https://github.com/your-org/jadugar.git
cd jadugar
```

### 2. Install Dependencies
```bash
yarn install
```

### 3. Runtime Configuration
Create a `.env` file with required configuration:

```env
# Required Configuration
NODE_ENV=development  # development | production | test
PORT=3000            # Valid port number (1-65535)
API_URL=http://localhost:3001  # Valid URL
```

#### Configuration System Features
Our configuration system provides:
- Type-safe access to all values
- Runtime validation
- Performance optimization through caching
- Immutable configuration objects

Example usage:
```typescript
import { Environment } from '@/core/config/environment';

// Get the environment instance (validates on first access)
const env = Environment.getInstance();

// Type-safe access to values
const nodeEnv = env.get('nodeEnv'); // typed as 'development' | 'production' | 'test'
const port = env.get('port');       // typed as number
const apiUrl = env.get('apiUrl');   // typed as string

// Access is cached for performance
const cachedPort = env.get('port'); // returns cached value
```

### 4. Type Safety
The project uses strict TypeScript configuration:
```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "target": "es2018",
    "module": "commonjs",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  }
}
```

### 5. Running Tests
```bash
# Run all tests
yarn test

# Run tests with coverage
yarn test --coverage

# Run specific test file
yarn test src/core/config/__tests__/environment.test.ts
```

### 6. Development Workflow
1. Start development server:
   ```bash
   yarn dev
   ```

2. Run type checking:
   ```bash
   yarn type-check
   ```

3. Run linting:
   ```bash
   yarn lint
   ```

## Project Structure
```
src/
├── core/
│   └── config/           # Runtime configuration
│       ├── environment.ts  # Configuration singleton
│       ├── types.ts        # Type definitions
│       └── __tests__/      # Test files
└── types/               # Core type definitions
```

## Best Practices

### Configuration Management
1. Always use type-safe accessors
2. Never modify configuration at runtime
3. Add validation for new values
4. Use the caching system
5. Handle errors appropriately

### Error Handling
Configuration errors are handled through `ConfigValidationError`:
```typescript
try {
  const env = Environment.getInstance();
} catch (error) {
  if (error instanceof ConfigValidationError) {
    // Handle invalid configuration
  }
}
```

### Performance Considerations
- Configuration values are cached after first access
- Validation occurs only on initialization
- Immutable objects prevent unnecessary updates

For more details on our development principles and practices, see the [Development Principles](../principles.md) guide.
