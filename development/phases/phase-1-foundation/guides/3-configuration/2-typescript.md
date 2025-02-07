# 3.2 TypeScript Configuration

## Overview
This guide covers the TypeScript configuration for the Jadugar project, including base configuration, path aliases, and type definitions.

## Dependencies
- ✅ [Next.js Setup](1-next-setup.md) completed
- ✅ TypeScript installed
- ✅ Project structure verified

## Steps

### 1. Root Configuration
```bash
# Create root tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "target": "es2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "baseUrl": ".",
    "paths": {
      "@jadugar/*": ["packages/*/src"]
    }
  },
  "exclude": ["node_modules"]
}
EOF
```

### 2. Web Application Configuration
```bash
# Create web app tsconfig.json
cat > apps/web/tsconfig.json << 'EOF'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"],
      "@jadugar/*": ["../../packages/*/src"]
    },
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
EOF

# Create type definitions
cat > apps/web/types/global.d.ts << 'EOF'
/// <reference types="next" />
/// <reference types="react-native" />

declare module "*.css" {
  const content: { [className: string]: string };
  export default content;
}

declare module "*.png" {
  const content: any;
  export default content;
}

declare module "*.svg" {
  const content: any;
  export default content;
}
EOF
```

### 3. UI Package Configuration
```bash
# Create UI package tsconfig.json
cat > packages/ui/tsconfig.json << 'EOF'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "composite": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts", "**/*.test.tsx"]
}
EOF

# Create UI package type definitions
cat > packages/ui/src/types/index.ts << 'EOF'
import { ViewStyle, TextStyle, ImageStyle } from 'react-native';

export type Style = ViewStyle | TextStyle | ImageStyle;

export interface Theme {
  colors: {
    primary: string;
    secondary: string;
    background: string;
    text: string;
    error: string;
  };
  spacing: {
    small: number;
    medium: number;
    large: number;
  };
  typography: {
    h1: TextStyle;
    h2: TextStyle;
    body: TextStyle;
  };
}
EOF
```

## Verification

### 1. TypeScript Configuration
```bash
# Create verification script
cat > verify-typescript.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Checking TypeScript Configuration${NC}"

# Check configuration files
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ File exists: $1${NC}"
        return 0
    else
        echo -e "${RED}❌ Missing file: $1${NC}"
        return 1
    }
}

check_file "tsconfig.json" || exit 1
check_file "apps/web/tsconfig.json" || exit 1
check_file "packages/ui/tsconfig.json" || exit 1
check_file "apps/web/types/global.d.ts" || exit 1
check_file "packages/ui/src/types/index.ts" || exit 1

# Type check web app
echo -e "\nType checking web app..."
cd apps/web
if yarn tsc --noEmit; then
    echo -e "${GREEN}✓ Web app types valid${NC}"
else
    echo -e "${RED}❌ Web app type errors${NC}"
    exit 1
fi

# Type check UI package
echo -e "\nType checking UI package..."
cd ../../packages/ui
if yarn tsc --noEmit; then
    echo -e "${GREEN}✓ UI package types valid${NC}"
else
    echo -e "${RED}❌ UI package type errors${NC}"
    exit 1
fi

echo -e "\n${GREEN}✓ All TypeScript checks passed${NC}"
EOF

# Make script executable
chmod +x verify-typescript.sh

# Run verification
./verify-typescript.sh
```

### 2. Path Resolution
```bash
# Create path verification script
cat > verify-paths.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Checking Path Resolution${NC}"

# Create test file
cat > apps/web/pages/test.tsx << 'EOT'
import { Theme } from '@jadugar/ui/types';
import { View } from 'react-native';
import styles from '@/styles/globals.css';

export default function Test() {
  return <View style={styles.container} />;
}
EOT

# Type check test file
cd apps/web
if yarn tsc pages/test.tsx --noEmit; then
    echo -e "${GREEN}✓ Path aliases working${NC}"
else
    echo -e "${RED}❌ Path alias errors${NC}"
    exit 1
fi

# Clean up
rm pages/test.tsx

echo -e "\n${GREEN}✓ All path resolution checks passed${NC}"
EOF

# Make script executable
chmod +x verify-paths.sh

# Run verification
./verify-paths.sh
```

## Common Issues

### 1. Type Errors
```bash
# Solution: Check TypeScript version
yarn why typescript

# Update TypeScript
yarn add -D typescript@latest
```

### 2. Path Resolution
```bash
# Solution: Clear TypeScript cache
rm -rf .next/cache
yarn dev
```

### 3. Missing Types
```bash
# Solution: Install missing types
yarn add -D @types/react-native
```

## Verification Checklist
- [ ] Root TypeScript config complete
- [ ] Web app TypeScript config working
- [ ] UI package TypeScript config valid
- [ ] Path aliases resolving
- [ ] Type definitions created
- [ ] All verification scripts pass

## Next Steps
1. Proceed to [Build Configuration](3-build.md)
2. Set up build process
3. Configure production optimization

## Resources
- [TypeScript Configuration](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html)
- [Next.js TypeScript](https://nextjs.org/docs/basic-features/typescript)
- [React Native Web Types](https://github.com/necolas/react-native-web)
