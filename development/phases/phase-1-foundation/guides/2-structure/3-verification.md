# 2.3 Structure Verification

## Overview
This guide provides comprehensive verification steps for the project structure, ensuring all components are properly set up and working together.

## Dependencies
- ✅ [Directory Setup](1-directories.md) completed
- ✅ [Monorepo Configuration](2-monorepo.md) completed
- ✅ All configuration files in place

## Steps

### 1. Directory Verification
```bash
# Create comprehensive verification script
cat > verify-project.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓ Directory exists: $1${NC}"
        return 0
    else
        echo -e "${RED}❌ Missing directory: $1${NC}"
        return 1
    }
}

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ File exists: $1${NC}"
        return 0
    else
        echo -e "${RED}❌ Missing file: $1${NC}"
        return 1
    }
}

echo -e "\n${YELLOW}Checking Project Structure${NC}"

# Check root structure
check_directory "apps" || exit 1
check_directory "packages" || exit 1
check_directory "docs" || exit 1
check_directory "scripts" || exit 1

# Check web application
check_directory "apps/web" || exit 1
check_directory "apps/web/pages" || exit 1
check_directory "apps/web/public" || exit 1
check_directory "apps/web/styles" || exit 1

# Check UI package
check_directory "packages/ui" || exit 1
check_directory "packages/ui/src" || exit 1

# Check configuration files
check_file "package.json" || exit 1
check_file "turbo.json" || exit 1
check_file "apps/web/package.json" || exit 1
check_file "packages/ui/package.json" || exit 1
check_file ".gitignore" || exit 1

echo -e "\n${GREEN}✓ All structure checks passed${NC}"
EOF

# Make script executable
chmod +x verify-project.sh

# Run verification
./verify-project.sh
```

### 2. Configuration Verification
```bash
# Create configuration verification script
cat > verify-config.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Checking Package Configurations${NC}"

# Check root package.json
if jq -e '.workspaces[]' package.json > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Workspaces configured in root package.json${NC}"
else
    echo -e "${RED}❌ Workspaces not configured in root package.json${NC}"
    exit 1
fi

# Check Turborepo config
if jq -e '.pipeline' turbo.json > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Turborepo pipeline configured${NC}"
else
    echo -e "${RED}❌ Turborepo pipeline not configured${NC}"
    exit 1
fi

# Check web app package.json
if jq -e '.dependencies["@jadugar/ui"]' apps/web/package.json > /dev/null 2>&1; then
    echo -e "${GREEN}✓ UI package dependency configured in web app${NC}"
else
    echo -e "${RED}❌ UI package dependency not configured in web app${NC}"
    exit 1
fi

echo -e "\n${GREEN}✓ All configuration checks passed${NC}"
EOF

# Make script executable
chmod +x verify-config.sh

# Run verification
./verify-config.sh
```

### 3. Dependency Verification
```bash
# Create dependency verification script
cat > verify-deps.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Checking Dependencies${NC}"

# Clean install dependencies
echo "Installing dependencies..."
yarn install

# Check node_modules
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓ Root node_modules installed${NC}"
else
    echo -e "${RED}❌ Root node_modules missing${NC}"
    exit 1
fi

# Check workspace node_modules
if [ -d "apps/web/node_modules" ]; then
    echo -e "${GREEN}✓ Web app node_modules installed${NC}"
else
    echo -e "${RED}❌ Web app node_modules missing${NC}"
    exit 1
fi

if [ -d "packages/ui/node_modules" ]; then
    echo -e "${GREEN}✓ UI package node_modules installed${NC}"
else
    echo -e "${RED}❌ UI package node_modules missing${NC}"
    exit 1
fi

# Test workspace resolution
if yarn workspaces info | grep -q "@jadugar/ui"; then
    echo -e "${GREEN}✓ Workspace resolution working${NC}"
else
    echo -e "${RED}❌ Workspace resolution failed${NC}"
    exit 1
fi

echo -e "\n${GREEN}✓ All dependency checks passed${NC}"
EOF

# Make script executable
chmod +x verify-deps.sh

# Run verification
./verify-deps.sh
```

## Common Issues

### 1. Missing Dependencies
```bash
# Solution: Reinstall dependencies
yarn cache clean
rm -rf node_modules
yarn install
```

### 2. Workspace Resolution
```bash
# Solution: Check workspace configuration
yarn workspaces info
```

### 3. File Permissions
```bash
# Solution: Fix permissions
chmod -R u+w .
```

## Verification Checklist
- [ ] All directories present and correct
- [ ] Configuration files properly set up
- [ ] Dependencies installed and resolved
- [ ] Workspace resolution working
- [ ] All verification scripts pass
- [ ] No permission issues
- [ ] Git properly initialized

## Next Steps
1. Proceed to [Basic Configuration](../3-configuration/index.md)
2. Review Next.js setup requirements
3. Prepare for TypeScript configuration

## Resources
- [Yarn Workspaces](https://classic.yarnpkg.com/lang/en/docs/workspaces/)
- [Turborepo Documentation](https://turbo.build/repo/docs)
- [Next.js Project Structure](https://nextjs.org/docs/getting-started/project-structure)
