# Troubleshooting Guide

## Overview
This guide provides solutions for common issues encountered during development of the Jadugar project.

## Environment Issues

### 1. Node Version Mismatch
```bash
# Problem: Wrong Node.js version
node -v # Shows incorrect version

# Solution: Use NVM
nvm install 20.18.2
nvm use 20.18.2
nvm alias default 20.18.2
```

### 2. Yarn Issues
```bash
# Problem: Yarn not working
yarn -v # Command not found

# Solution: Install Yarn
npm install -g yarn@1.22.22

# Verify installation
yarn -v # Should show 1.22.22
```

### 3. Dependencies
```bash
# Problem: Missing dependencies
yarn start # Module not found

# Solution: Clean install
rm -rf node_modules
rm yarn.lock
yarn install
```

## Build Issues

### 1. TypeScript Errors
```typescript
// Problem: Type errors
interface Props {
  value: string;
}

// Error: Property 'value' is missing
const Component: React.FC<Props> = () => {
  return null;
};

// Solution: Add required props
const Component: React.FC<Props> = ({ value }) => {
  return null;
};
```

### 2. Next.js Build
```bash
# Problem: Next.js build fails
yarn build # Build error

# Solution: Clear cache and rebuild
rm -rf .next
yarn build
```

### 3. React Native Web
```typescript
// Problem: Platform-specific code
const styles = StyleSheet.create({
  container: {
    flex: 1,
    // Error: Property not supported
    elevation: 5,
  },
});

// Solution: Use platform-specific styles
const styles = StyleSheet.create({
  container: {
    flex: 1,
    ...Platform.select({
      ios: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
      },
      android: {
        elevation: 5,
      },
      web: {
        boxShadow: '0 2px 4px rgba(0,0,0,0.2)',
      },
    }),
  },
});
```

## Runtime Issues

### 1. React Hooks
```typescript
// Problem: Hook rules violation
function Component() {
  if (condition) {
    // Error: Hook called conditionally
    const [state, setState] = useState(null);
  }
}

// Solution: Move hook to top level
function Component() {
  const [state, setState] = useState(null);
  
  if (condition) {
    // Use state here
  }
}
```

### 2. Performance
```typescript
// Problem: Unnecessary re-renders
const Component = ({ data }) => {
  // Re-created every render
  const handler = () => {
    process(data);
  };
  
  return <Button onPress={handler} />;
};

// Solution: Memoize callback
const Component = ({ data }) => {
  const handler = useCallback(() => {
    process(data);
  }, [data]);
  
  return <Button onPress={handler} />;
};
```

### 3. Memory Leaks
```typescript
// Problem: Memory leak in useEffect
useEffect(() => {
  const subscription = api.subscribe(callback);
  // Missing cleanup
}, []);

// Solution: Clean up subscriptions
useEffect(() => {
  const subscription = api.subscribe(callback);
  return () => {
    subscription.unsubscribe();
  };
}, [callback]);
```

## Testing Issues

### 1. Jest Configuration
```javascript
// Problem: Test environment issues
// jest.config.js
module.exports = {
  // Missing configuration
};

// Solution: Configure environment
module.exports = {
  preset: 'react-native',
  setupFilesAfterEnv: ['@testing-library/jest-native/extend-expect'],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx'],
  transform: {
    '^.+\\.(js|jsx|ts|tsx)$': 'babel-jest',
  },
};
```

### 2. Test Failures
```typescript
// Problem: Async test failures
it('loads data', () => { // Missing async
  const data = await fetchData();
  expect(data).toBeDefined();
});

// Solution: Handle async properly
it('loads data', async () => {
  const data = await fetchData();
  expect(data).toBeDefined();
});
```

### 3. Mock Issues
```typescript
// Problem: Incomplete mocks
jest.mock('./api');
// Missing mock implementation

// Solution: Implement mocks
jest.mock('./api', () => ({
  fetchData: jest.fn().mockResolvedValue({ id: 1 }),
}));
```

## Debugging Tools

### 1. React DevTools
```bash
# Install React DevTools
yarn global add react-devtools

# Start DevTools
react-devtools
```

### 2. Logging
```typescript
// Development logging utility
const log = (message: string, data?: unknown) => {
  if (__DEV__) {
    console.log(`[${new Date().toISOString()}] ${message}`, data);
  }
};

// Usage
log('Component mounted', { props });
```

### 3. Error Tracking
```typescript
// Error boundary with logging
class ErrorBoundary extends React.Component<Props, State> {
  componentDidCatch(error: Error, info: React.ErrorInfo) {
    // Log to service
    logError({
      error,
      info,
      timestamp: new Date().toISOString(),
    });
  }
}
```

## Verification Scripts

### 1. Environment Check
```bash
# Create environment verification script
cat > scripts/verify-env.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Verifying Environment${NC}"

# Check Node.js version
NODE_VERSION=$(node -v)
if [[ $NODE_VERSION == *"20.18"* ]]; then
    echo -e "${GREEN}✓ Node.js version correct${NC}"
else
    echo -e "${RED}❌ Wrong Node.js version${NC}"
    exit 1
fi

# Check Yarn version
YARN_VERSION=$(yarn -v)
if [[ $YARN_VERSION == "1.22.22" ]]; then
    echo -e "${GREEN}✓ Yarn version correct${NC}"
else
    echo -e "${RED}❌ Wrong Yarn version${NC}"
    exit 1
fi

echo -e "\n${GREEN}✓ Environment verified${NC}"
EOF

# Make script executable
chmod +x scripts/verify-env.sh
```

### 2. Build Verification
```bash
# Create build verification script
cat > scripts/verify-build.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Verifying Build${NC}"

# Clean previous builds
yarn clean

# Install dependencies
yarn install

# Run type check
echo "Running type check..."
if yarn type-check; then
    echo -e "${GREEN}✓ Type check passed${NC}"
else
    echo -e "${RED}❌ Type check failed${NC}"
    exit 1
fi

# Build project
echo "Building project..."
if yarn build; then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo -e "\n${GREEN}✓ Build verified${NC}"
EOF

# Make script executable
chmod +x scripts/verify-build.sh
```

## Common Solutions

### 1. Development Server
```bash
# Problem: Development server not starting
# Solution: Clear cache and restart
rm -rf .next
yarn dev
```

### 2. Type Errors
```bash
# Problem: Type errors after dependency update
# Solution: Update type definitions
yarn add -D @types/package@latest
```

### 3. Test Failures
```bash
# Problem: Test failures after changes
# Solution: Update snapshots and clear cache
yarn test -u --clearCache
```

## Verification Checklist
- [ ] Environment correct
- [ ] Dependencies installed
- [ ] Build successful
- [ ] Tests passing
- [ ] No type errors
- [ ] Development server running

## Next Steps
1. Set up monitoring
2. Configure error tracking
3. Implement logging

## Resources
- [React Native Debugging](https://reactnative.dev/docs/debugging)
- [Next.js Troubleshooting](https://nextjs.org/docs/deployment#troubleshooting)
- [TypeScript Common Issues](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html)
