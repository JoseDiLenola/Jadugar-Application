# Release Verification

## Overview
This document outlines the verification process for each release.

## Package Verification
### Installation Tests 🔲
- [ ] Fresh install
- [ ] Upgrade install
- [ ] Peer dependency check
- [ ] Bundle size verification

### Type Verification 🔲
- [ ] Type exports correct
- [ ] Type imports working
- [ ] Generic constraints valid
- [ ] No type errors

### Integration Verification 🔲
- [ ] Cross-package imports
- [ ] API compatibility
- [ ] Event handling
- [ ] Error propagation

## Environment Matrix
| Environment | Node | TypeScript | React | Status |
|-------------|------|------------|-------|--------|
| Minimum     | 16.x | 4.8.x     | 17.x  | 🔲 |
| Current     | 18.x | 5.0.x     | 18.x  | 🔲 |
| Latest      | 20.x | 5.3.x     | 18.x  | 🔲 |

## Verification Steps

### Step 1: Package Installation
```bash
# Fresh install
npm create vite@latest test-app -- --template react-ts
cd test-app
npm install @jadugar/types @jadugar/utils @jadugar/core @jadugar/ui
```

### Step 2: Type Checking
```bash
# Should show no errors
tsc --noEmit
```

### Step 3: Build Verification
```bash
# Should build successfully
npm run build
```

### Step 4: Runtime Tests
- [ ] Import all packages
- [ ] Use main features
- [ ] Test error handling
- [ ] Verify performance

## Common Issues
### Known Issues
- List known issues and workarounds

### Resolution Steps
1. Clear node_modules
2. Clear build cache
3. Update dependencies
4. Rebuild project

## Sign-off Requirements
Each release requires:
- [ ] All verification steps passed
- [ ] Environment matrix checked
- [ ] Documentation verified
- [ ] Examples working
