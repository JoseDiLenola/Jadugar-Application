# 2.2 Monorepo Configuration

## Overview
This guide covers the setup and configuration of the monorepo workspace using Yarn workspaces and Turborepo.

## Dependencies
- ✅ [Directory Setup](1-directories.md) completed
- ✅ Yarn installed and configured
- ✅ Project structure verified

## Steps

### 1. Root Configuration
```bash
# Initialize root package.json
cat > package.json << 'EOF'
{
  "name": "jadugar",
  "version": "0.1.0",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "turbo run dev",
    "build": "turbo run build",
    "test": "turbo run test",
    "lint": "turbo run lint",
    "clean": "turbo run clean && rm -rf node_modules"
  },
  "devDependencies": {
    "turbo": "^1.10.0"
  },
  "packageManager": "yarn@1.22.22"
}
EOF

# Initialize Turborepo
cat > turbo.json << 'EOF'
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": [".env"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "build/**"]
    },
    "test": {
      "dependsOn": ["^build"],
      "outputs": ["coverage/**"]
    },
    "lint": {},
    "dev": {
      "cache": false,
      "persistent": true
    },
    "clean": {
      "cache": false
    }
  }
}
EOF
```

### 2. Web Application Setup
```bash
# Create web app package.json
cat > apps/web/package.json << 'EOF'
{
  "name": "@jadugar/web",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "clean": "rm -rf .next out node_modules"
  },
  "dependencies": {
    "@jadugar/ui": "workspace:*",
    "next": "^13.4.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-native-web": "^0.19.13"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "typescript": "^5.0.0"
  }
}
EOF
```

### 3. UI Package Setup
```bash
# Create UI package.json
cat > packages/ui/package.json << 'EOF'
{
  "name": "@jadugar/ui",
  "version": "0.1.0",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "scripts": {
    "build": "tsc",
    "test": "jest",
    "lint": "eslint src",
    "clean": "rm -rf dist node_modules"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-native-web": "^0.19.13"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "typescript": "^5.0.0",
    "jest": "^29.0.0"
  }
}
EOF
```

## Verification

### 1. Workspace Setup
```bash
# Create verification script
cat > verify-workspace.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ File exists: $1${NC}"
        return 0
    else
        echo -e "${RED}❌ Missing file: $1${NC}"
        return 1
    }
}

# Check configuration files
check_file "package.json" || exit 1
check_file "turbo.json" || exit 1
check_file "apps/web/package.json" || exit 1
check_file "packages/ui/package.json" || exit 1

# Install dependencies
echo -e "\nInstalling dependencies..."
yarn install

# Verify installation
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Dependencies installed successfully${NC}"
else
    echo -e "${RED}❌ Dependency installation failed${NC}"
    exit 1
fi

echo -e "\n${GREEN}✓ All workspace checks passed${NC}"
EOF

# Make script executable
chmod +x verify-workspace.sh

# Run verification
./verify-workspace.sh
```

### 2. Package Resolution
```bash
# Test workspace resolution
yarn why @jadugar/ui
```

## Common Issues

### 1. Dependency Resolution
```bash
# Solution: Clear yarn cache
yarn cache clean
yarn install
```

### 2. Workspace Issues
```bash
# Solution: Verify workspace config
yarn workspaces info
```

### 3. Build Problems
```bash
# Solution: Clean and rebuild
yarn clean
yarn install
yarn build
```

## Verification Checklist
- [ ] Root package.json configured
- [ ] Turborepo configured
- [ ] Web application setup
- [ ] UI package setup
- [ ] Dependencies installed
- [ ] Workspace resolution working
- [ ] All verification scripts pass

## Next Steps
1. Proceed to [Verification](3-verification.md)
2. Review build configuration
3. Prepare for Next.js setup

## Resources
- [Yarn Workspaces](https://classic.yarnpkg.com/lang/en/docs/workspaces/)
- [Turborepo Documentation](https://turbo.build/repo/docs)
- [Next.js Setup](https://nextjs.org/docs/getting-started)
