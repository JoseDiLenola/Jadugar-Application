# Project Structure Guide

## Directory Structure

```
jadugar/
├── apps/                    # Application packages
│   └── web/                # Next.js web application
│       ├── public/         # Static assets
│       ├── src/           
│       │   ├── components/ # Web-specific components
│       │   ├── pages/      # Next.js pages
│       │   └── styles/     # Web-specific styles
│       ├── next.config.js  # Next.js configuration
│       └── tsconfig.json   # Web TypeScript config
│
├── packages/               # Shared packages
│   └── ui/                # Shared UI components
│       ├── src/
│       │   ├── components/
│       │   ├── hooks/
│       │   ├── styles/
│       │   └── types/
│       └── tsconfig.json  # UI package TypeScript config
│
├── scripts/               # Build and verification scripts
│   ├── verify-env.sh     # Environment verification
│   ├── verify-docs.sh    # Documentation checks
│   ├── verify-build.sh   # Build verification
│   └── verify-cache.sh   # Cache verification
│
├── docs/                  # Project documentation
│   └── development/      # Development guides
│
└── config/               # Shared configurations
    ├── eslint/          # ESLint configurations
    └── typescript/      # TypeScript configurations
```

## File Organization

### Naming Conventions

1. **Directories**
   - Use lowercase with hyphens for multi-word names
   - Example: `shared-components/`, `build-scripts/`

2. **Source Files**
   - Use PascalCase for React components: `Button.tsx`, `UserProfile.tsx`
   - Use camelCase for utilities and hooks: `useAuth.ts`, `formatDate.ts`
   - Use `.tsx` extension for files with JSX
   - Use `.ts` extension for pure TypeScript files

3. **Configuration Files**
   - Use lowercase with dots: `tsconfig.json`, `next.config.js`
   - Use `.config.js` suffix for tool configurations

4. **Test Files**
   - Use `.test.ts` or `.test.tsx` suffix
   - Match the name of the file being tested
   - Example: `Button.test.tsx` tests `Button.tsx`

### File Structure Guidelines

1. **Component Files**
   ```typescript
   // imports
   import React from 'react';
   import { StyleSheet } from 'react-native';
   
   // types
   interface Props {
     // ...
   }
   
   // component
   export const Component: React.FC<Props> = () => {
     // ...
   };
   
   // styles
   const styles = StyleSheet.create({
     // ...
   });
   ```

2. **Hook Files**
   ```typescript
   // imports
   import { useState, useEffect } from 'react';
   
   // hook
   export const useHook = () => {
     // ...
   };
   ```

3. **Utility Files**
   ```typescript
   // types
   interface Config {
     // ...
   }
   
   // functions
   export const utilityFunction = () => {
     // ...
   };
   ```

## Import Organization

1. **Import Order**
   ```typescript
   // External dependencies
   import React from 'react';
   import { View } from 'react-native';
   
   // Internal modules
   import { useAuth } from '@jadugar/ui';
   
   // Local imports
   import { styles } from './styles';
   ```

2. **Path Aliases**
   - Use `@jadugar/*` for package imports
   - Example: `import { Button } from '@jadugar/ui'`

## Documentation

1. **Component Documentation**
   ```typescript
   /**
    * Button component with customizable styles and behaviors
    *
    * @example
    * <Button
    *   label="Click me"
    *   onPress={() => {}}
    *   variant="primary"
    * />
    */
   ```

2. **Function Documentation**
   ```typescript
   /**
    * Formats a date string into a localized format
    *
    * @param date - ISO date string
    * @param locale - Locale string (default: 'en-US')
    * @returns Formatted date string
    */
   ```

## Best Practices

1. **Component Organization**
   - One component per file
   - Co-locate component tests
   - Keep components focused and small

2. **Code Splitting**
   - Use dynamic imports for large components
   - Lazy load routes and heavy features

3. **State Management**
   - Use hooks for local state
   - Keep state close to where it's used
   - Lift state up when needed

4. **Performance**
   - Memoize expensive computations
   - Use React.memo for pure components
   - Avoid unnecessary re-renders
