# 3.3 Build Configuration

## Overview
This guide covers the build system configuration using Turborepo, including development and production builds.

## Dependencies
- ✅ [Next.js Setup](1-next-setup.md) completed
- ✅ [TypeScript Configuration](2-typescript.md) completed
- ✅ All previous verifications passed

## Steps

### 1. Turborepo Configuration
```bash
# Update root turbo.json
cat > turbo.json << 'EOF'
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": [".env"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "out/**"],
      "env": ["NEXT_PUBLIC_*"]
    },
    "test": {
      "dependsOn": ["^build"],
      "outputs": ["coverage/**"]
    },
    "lint": {
      "outputs": []
    },
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

### 2. Build Scripts
```bash
# Create build script
cat > scripts/build.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
yarn clean

# Install dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
yarn install

# Build packages
echo -e "${YELLOW}Building packages...${NC}"
yarn build

# Check build status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build completed successfully${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi
EOF

# Create clean script
cat > scripts/clean.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Cleaning project...${NC}"

# Clean root
rm -rf node_modules
rm -rf .turbo

# Clean web app
cd apps/web
rm -rf node_modules .next out
cd ../..

# Clean UI package
cd packages/ui
rm -rf node_modules dist
cd ../..

echo -e "${GREEN}✓ Project cleaned${NC}"
EOF

# Make scripts executable
chmod +x scripts/build.sh scripts/clean.sh
```

### 3. Production Optimization
```bash
# Create production build script
cat > scripts/build-prod.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Set production environment
export NODE_ENV=production

# Clean and install
echo -e "${YELLOW}Preparing production build...${NC}"
yarn clean
yarn install --production

# Build with production optimizations
echo -e "${YELLOW}Building for production...${NC}"
yarn build

# Check build status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Production build completed${NC}"
    
    # Report build sizes
    echo -e "\n${YELLOW}Build sizes:${NC}"
    du -sh apps/web/out/
    du -sh packages/ui/dist/
else
    echo -e "${RED}❌ Production build failed${NC}"
    exit 1
fi
EOF

# Make script executable
chmod +x scripts/build-prod.sh
```

## Verification

### 1. Build System
```bash
# Create build verification script
cat > verify-build.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Verifying Build System${NC}"

# Check configuration
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ File exists: $1${NC}"
        return 0
    else
        echo -e "${RED}❌ Missing file: $1${NC}"
        return 1
    }
}

check_file "turbo.json" || exit 1
check_file "scripts/build.sh" || exit 1
check_file "scripts/clean.sh" || exit 1
check_file "scripts/build-prod.sh" || exit 1

# Test clean
echo -e "\nTesting clean..."
yarn clean
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Clean successful${NC}"
else
    echo -e "${RED}❌ Clean failed${NC}"
    exit 1
fi

# Test development build
echo -e "\nTesting development build..."
yarn build
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Development build successful${NC}"
else
    echo -e "${RED}❌ Development build failed${NC}"
    exit 1
fi

# Test production build
echo -e "\nTesting production build..."
NODE_ENV=production yarn build
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Production build successful${NC}"
else
    echo -e "${RED}❌ Production build failed${NC}"
    exit 1
fi

echo -e "\n${GREEN}✓ All build system checks passed${NC}"
EOF

# Make script executable
chmod +x verify-build.sh

# Run verification
./verify-build.sh
```

### 2. Cache Management
```bash
# Create cache verification script
cat > verify-cache.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Verifying Cache Management${NC}"

# Check Turbo cache
if [ -d ".turbo" ]; then
    echo -e "${GREEN}✓ Turbo cache exists${NC}"
else
    echo -e "${YELLOW}! Turbo cache not yet created${NC}"
fi

# Test cache invalidation
echo -e "\nTesting cache invalidation..."
yarn clean
yarn build
yarn build

# Check second build time
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Cache working correctly${NC}"
else
    echo -e "${RED}❌ Cache verification failed${NC}"
    exit 1
fi

echo -e "\n${GREEN}✓ All cache checks passed${NC}"
EOF

# Make script executable
chmod +x verify-cache.sh

# Run verification
./verify-cache.sh
```

## Common Issues

### 1. Build Failures
```bash
# Solution: Clean and rebuild
yarn clean
yarn install
yarn build
```

### 2. Cache Issues
```bash
# Solution: Clear Turbo cache
rm -rf .turbo
yarn build
```

### 3. Production Optimization
```bash
# Solution: Verify environment
echo $NODE_ENV
export NODE_ENV=production
```

## Verification Checklist
- [ ] Turborepo configured
- [ ] Build scripts created
- [ ] Clean scripts working
- [ ] Development build passing
- [ ] Production build optimized
- [ ] Cache management working
- [ ] All verification scripts pass

## Next Steps
1. Review [Architecture Documentation](../../architecture/overview.md)
2. Set up continuous integration
3. Configure deployment process

## Resources
- [Turborepo Documentation](https://turbo.build/repo/docs)
- [Next.js Production Build](https://nextjs.org/docs/deployment)
- [Build Optimization](https://turbo.build/repo/docs/core-concepts/caching)
