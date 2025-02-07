# 2.1 Directory Setup

## Overview
This guide covers the creation and organization of the project's directory structure, ensuring a clean and maintainable codebase.

## Dependencies
- ✅ [Environment Setup](../1-environment/index.md) completed
- ✅ Git installed and configured
- ✅ Development tools ready

## Steps

### 1. Project Initialization
```bash
# Create project directory
mkdir -p jadugar
cd jadugar

# Initialize Git
git init
git checkout -b main

# Create base .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnp/
.pnp.js

# Testing
coverage/

# Production
build/
dist/
.next/
out/

# Misc
.DS_Store
*.pem
.env*
!.env.example

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# IDE
.idea/
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json

# Turbo
.turbo
EOF

# Initial commit
git add .gitignore
git commit -m "Initial commit: Add .gitignore"
```

### 2. Create Directory Structure
```bash
# Create main directories
mkdir -p apps/web/{pages,public,styles,components}
mkdir -p packages/ui/{src,test}
mkdir -p docs/development/{guides,reference}
mkdir -p scripts

# Create placeholder files
touch apps/web/pages/index.tsx
touch apps/web/styles/globals.css
touch packages/ui/src/index.ts
touch docs/development/README.md
touch scripts/build.sh

# Make scripts executable
chmod +x scripts/build.sh
```

### 3. Initialize Documentation
```bash
# Create main README
cat > README.md << 'EOF'
# Jadugar

## Overview
Jadugar is a modern web application built with Next.js and React Native Web.

## Getting Started
1. Install dependencies: `yarn install`
2. Start development: `yarn dev`
3. Build project: `yarn build`

## Documentation
See [Development Documentation](docs/development/README.md)

## License
MIT
EOF

# Create development README
cat > docs/development/README.md << 'EOF'
# Development Documentation

See [Phase 1 Guide](phases/phase-1-foundation/index.md) for setup instructions.
EOF
```

## Verification

### 1. Directory Structure
```bash
# Create verification script
cat > verify-structure.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
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

# Check main directories
check_directory "apps" || exit 1
check_directory "apps/web" || exit 1
check_directory "packages" || exit 1
check_directory "packages/ui" || exit 1
check_directory "docs" || exit 1
check_directory "scripts" || exit 1

echo -e "\n${GREEN}✓ All directory checks passed${NC}"
EOF

# Make script executable
chmod +x verify-structure.sh

# Run verification
./verify-structure.sh
```

### 2. Git Status
```bash
# Verify Git setup
git status
git log --oneline
```

## Common Issues

### 1. Permission Issues
```bash
# Solution: Fix permissions
chmod -R u+w .
```

### 2. Git Problems
```bash
# Solution: Reinitialize Git
rm -rf .git
git init
```

### 3. Missing Directories
```bash
# Solution: Create missing directories
mkdir -p path/to/missing/directory
```

## Verification Checklist
- [ ] All directories created
- [ ] Git initialized
- [ ] .gitignore configured
- [ ] Placeholder files created
- [ ] Documentation started
- [ ] All verification scripts pass

## Next Steps
1. Proceed to [Monorepo Configuration](2-monorepo.md)
2. Review workspace setup
3. Prepare package configurations

## Resources
- [Git Documentation](https://git-scm.com/doc)
- [Next.js Directory Structure](https://nextjs.org/docs/getting-started/project-structure)
- [Monorepo Best Practices](https://turbo.build/repo/docs/handbook)
