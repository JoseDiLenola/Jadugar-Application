# A1 Core Setup - Technical Implementation Guide

## A. Environment Setup

### Required Versions
```bash
node: ">=18.0.0"
npm: ">=9.0.0"
react: "18.2.0"
react-native: "0.72.0"
next: "13.4.0"
typescript: "5.0.0"
```

### Setup Commands
```bash
# Initialize monorepo
npm install -g turbo
npx create-turbo@latest jadugar

# Install core dependencies
cd jadugar
npm install react@18.2.0 react-native@0.72.0 next@13.4.0 typescript@5.0.0
```

## B. Project Structure

### Directory Layout
```
jadugar/
├── apps/
│   ├── mobile/          # React Native app
│   │   ├── src/
│   │   └── package.json
│   └── web/            # Next.js app
│       ├── src/
│       └── package.json
├── packages/
│   ├── ui/             # Shared components
│   │   ├── src/
│   │   └── package.json
│   └── config/         # Shared configs
│       ├── src/
│       └── package.json
└── package.json
```

### Configuration Files

#### Root package.json
```json
{
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "turbo run dev",
    "build": "turbo run build",
    "test": "turbo run test"
  }
}
```

## C. Basic Configuration

### Next.js Configuration (apps/web/next.config.js)
```javascript
const withTM = require('next-transpile-modules')(['@jadugar/ui']);

module.exports = withTM({
  webpack: (config) => {
    config.resolve.alias = {
      ...(config.resolve.alias || {}),
      'react-native$': 'react-native-web'
    };
    return config;
  }
});
```

## D. TypeScript Foundation

### Overview
The TypeScript foundation ensures type safety across our entire cross-platform application. This setup needs to handle:
- Web-specific types (Next.js)
- Mobile-specific types (React Native)
- Shared types between platforms
- Custom type definitions
- Type checking configuration

### 1. Base Configuration

#### Root tsconfig.json
```json
{
  "compilerOptions": {
    "target": "es2017",
    "module": "esnext",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "baseUrl": ".",
    "paths": {
      "@jadugar/*": ["packages/*/src"]
    }
  },
  "exclude": ["node_modules"]
}
```

#### Web App tsconfig.json (apps/web/tsconfig.json)
```json
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "jsx": "preserve",
    "plugins": [
      {
        "name": "next"
      }
    ]
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": ["node_modules"]
}
```

#### Mobile App tsconfig.json (apps/mobile/tsconfig.json)
```json
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "jsx": "react-native",
    "types": ["react-native"]
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

### 2. Type Definitions

#### Platform Types (packages/config/src/platform.ts)
```typescript
// Platform detection and type definitions
export type Platform = 'web' | 'ios' | 'android';
export type PlatformGroup = 'web' | 'mobile';

export interface PlatformConfig {
  platform: Platform;
  group: PlatformGroup;
  isWeb: boolean;
  isMobile: boolean;
  isIOS: boolean;
  isAndroid: boolean;
}

export const getPlatform = (): Platform => {
  if (typeof window === 'undefined') return 'web';
  if (window.navigator.platform.includes('iPhone')) return 'ios';
  if (window.navigator.platform.includes('Android')) return 'android';
  return 'web';
};

export const getPlatformConfig = (): PlatformConfig => {
  const platform = getPlatform();
  return {
    platform,
    group: platform === 'web' ? 'web' : 'mobile',
    isWeb: platform === 'web',
    isMobile: platform !== 'web',
    isIOS: platform === 'ios',
    isAndroid: platform === 'android'
  };
};
```

#### Component Types (packages/ui/src/types/components.ts)
```typescript
import { ViewStyle, TextStyle, TouchableOpacityProps } from 'react-native';

// Base component props
export interface BaseComponentProps {
  testID?: string;
  style?: ViewStyle;
  className?: string; // For web styling
}

// Text component props
export interface TextProps extends BaseComponentProps {
  children: React.ReactNode;
  style?: TextStyle;
  variant?: 'h1' | 'h2' | 'h3' | 'body' | 'caption';
}

// Button component props
export interface ButtonProps extends TouchableOpacityProps, BaseComponentProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'text';
  size?: 'small' | 'medium' | 'large';
  loading?: boolean;
  disabled?: boolean;
}
```

### 3. Type Utilities

#### Style Types (packages/ui/src/types/styles.ts)
```typescript
import { ViewStyle, TextStyle, ImageStyle } from 'react-native';

export type NamedStyles<T> = { [P in keyof T]: ViewStyle | TextStyle | ImageStyle };

export type ThemeStyles<T> = (theme: Theme) => T;

export type ResponsiveStyle<T> = {
  base: T;
  sm?: Partial<T>;
  md?: Partial<T>;
  lg?: Partial<T>;
  xl?: Partial<T>;
};
```

### 4. Type Checking Setup

#### VS Code Configuration (.vscode/settings.json)
```json
{
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```

#### Type Checking Scripts (package.json)
```json
{
  "scripts": {
    "type-check": "tsc --noEmit",
    "type-check:watch": "tsc --noEmit --watch"
  }
}
```

### 5. React Native Web Types

#### Custom Type Declarations (packages/config/src/types/react-native-web.d.ts)
```typescript
declare module 'react-native-web' {
  export * from 'react-native';
}

declare module 'react-native' {
  export interface ViewProps {
    className?: string;
    onClick?: () => void;
  }
  
  export interface TextProps {
    className?: string;
    onClick?: () => void;
  }
}
```

### 6. Type Safety Verification

#### Manual Verification Steps
1. Run type checking:
```bash
npm run type-check
```

2. Verify VS Code integration:
- Open any .ts/.tsx file
- Ensure red squiggles appear for type errors
- Verify hover information shows correct types
- Check that auto-imports work correctly

3. Test cross-platform type safety:
```bash
# Check web types
cd apps/web
npm run type-check

# Check mobile types
cd apps/mobile
npm run type-check

# Check shared packages
cd packages/ui
npm run type-check
```

#### Automated Type Tests (packages/config/src/__tests__/platform.test.ts)
```typescript
import { getPlatform, getPlatformConfig } from '../platform';

describe('Platform Detection', () => {
  it('should detect web platform when window is undefined', () => {
    expect(getPlatform()).toBe('web');
  });

  it('should provide correct platform config', () => {
    const config = getPlatformConfig();
    expect(config).toHaveProperty('platform');
    expect(config).toHaveProperty('group');
    expect(config).toHaveProperty('isWeb');
    expect(config).toHaveProperty('isMobile');
  });
});
```

### 7. Common Type Issues and Solutions

#### 1. React Native Web Props
Problem: Missing web-specific props like onClick
Solution: Use custom type declarations (see react-native-web.d.ts above)

#### 2. Next.js Pages
Problem: Type errors in Next.js pages
Solution: Use correct page types:
```typescript
import type { NextPage } from 'next';

const Home: NextPage = () => {
  return <div>Home Page</div>;
};

export default Home;
```

#### 3. Shared Components
Problem: Platform-specific props causing type errors
Solution: Use conditional types:
```typescript
type PlatformProps<T> = Platform extends 'web' 
  ? T & { className?: string }
  : T;
```

### 8. Type Documentation

Create comprehensive type documentation using TypeDoc:

1. Install TypeDoc:
```bash
npm install --save-dev typedoc
```

2. Configure TypeDoc (typedoc.json):
```json
{
  "entryPoints": ["packages/*/src/index.ts"],
  "out": "docs/api",
  "excludePrivate": true,
  "excludeProtected": true,
  "excludeExternals": true
}
```

3. Generate documentation:
```bash
npm run typedoc
```

## Verification Checklists

### For Each Step
1. Installation Verification
```bash
# Verify Node.js version
node -v  # Should be >=18.0.0

# Verify npm version
npm -v   # Should be >=9.0.0

# Verify project setup
npm run build  # Should complete without errors
npm run test   # All tests should pass
```

2. Type Checking
```bash
# Run type checking
npm run type-check  # Should show no errors
```

3. Cross-Platform Verification
```bash
# Start web development
npm run dev:web    # Should start without errors

# Start mobile development
npm run dev:mobile # Should start without errors
```
