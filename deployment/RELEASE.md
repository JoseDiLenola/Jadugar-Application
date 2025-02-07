# Release Management Guide

## 1. Release Philosophy

### 1.1 Core Principles
1. Package-First Releases
   - Types drives versions
   - Utils follows types
   - Core follows utils
   - UI follows core

2. Version Strategy
   - Semantic versioning
   - Breaking changes clear
   - Migration paths
   - Backward compatibility

3. Release Types
   - Major: Breaking changes
   - Minor: New features
   - Patch: Bug fixes
   - Pre-release: Alpha/Beta

### 1.2 Release Schedule
1. Regular Releases
   - Major: Quarterly
   - Minor: Monthly
   - Patch: Weekly
   - Emergency: As needed

## 2. Version Management

### 2.1 Semantic Versioning
```typescript
interface Version {
    major: number; // Breaking changes
    minor: number; // New features
    patch: number; // Bug fixes
    pre?: string;  // Alpha/beta/rc
}

// Example versions
const versions = {
    stable: '1.0.0',
    feature: '1.1.0',
    bugfix: '1.0.1',
    beta: '2.0.0-beta.1'
};
```

### 2.2 Version Bumping
```json
{
    "scripts": {
        "version:major": "yarn workspaces run version major",
        "version:minor": "yarn workspaces run version minor",
        "version:patch": "yarn workspaces run version patch",
        "version:beta": "yarn workspaces run version prerelease --preid beta"
    }
}
```

## 3. Changelog Management

### 3.1 Changelog Structure
```markdown
# Changelog

## [2.0.0] - 2025-02-07

### Breaking Changes
- Complete rewrite of type system
- New validation API
- Updated event system

### Added
- New type utilities
- Enhanced validation
- Better error handling

### Fixed
- Type inference issues
- Performance bottlenecks
- Memory leaks

### Security
- Updated dependencies
- Fixed vulnerabilities
- Enhanced type safety
```

### 3.2 Changelog Generation
```yaml
name: Generate Changelog

on:
  push:
    tags:
      - 'v*'

jobs:
  changelog:
    runs-on: ubuntu-latest
    steps:
      - name: Generate
        uses: conventional-changelog/action@v1
        
      - name: Commit
        run: |
          git add CHANGELOG.md
          git commit -m "chore: update changelog"
```

## 4. Release Process

### 4.1 Pre-Release Checklist
1. Version Check
   ```bash
   # Check current versions
   yarn workspaces list --json
   
   # Check dependencies
   yarn why @jadugar/types
   ```

2. Quality Gates
   ```bash
   # Run all checks
   yarn pre-release
   
   # Includes
   yarn type-check
   yarn test
   yarn build
   yarn docs
   ```

### 4.2 Release Steps
1. @jadugar/types
   ```bash
   cd packages/types
   yarn version
   yarn test
   yarn build
   yarn publish
   ```

2. Dependent Packages
   ```bash
   # Update dependencies
   yarn up @jadugar/types
   
   # Verify
   yarn test
   
   # Release
   yarn publish
   ```

## 5. Migration Management

### 5.1 Migration Guide
```markdown
# Migration Guide

## Migrating to v2.0.0

### Breaking Changes
1. Type System
   - Before: `type Old = string`
   - After: `type New = String`

2. Validation API
   - Before: `validate(data)`
   - After: `validateWithOptions(data, options)`

### Migration Steps
1. Update Dependencies
2. Run Migration Script
3. Update Code
4. Verify Types
```

### 5.2 Migration Scripts
```typescript
// migration.ts
async function migrate() {
    // 1. Backup
    await backup();
    
    // 2. Update
    await updateTypes();
    
    // 3. Validate
    await validateMigration();
    
    // 4. Report
    await generateReport();
}
```

## 6. Release Validation

### 6.1 Package Validation
```typescript
// validate-release.ts
async function validateRelease() {
    // 1. Version Check
    await checkVersions();
    
    // 2. Dependency Check
    await checkDependencies();
    
    // 3. Type Check
    await checkTypes();
    
    // 4. Integration Check
    await checkIntegration();
}
```

### 6.2 Integration Tests
```typescript
describe('Release Integration', () => {
    test('cross-package compatibility', async () => {
        // Test types with utils
        const types = await import('@jadugar/types');
        const utils = await import('@jadugar/utils');
        
        // Verify compatibility
        expect(
            utils.process(types.create())
        ).toBeDefined();
    });
});
```

## 7. Release Artifacts

### 7.1 Package Artifacts
1. Distribution Files
   ```
   dist/
   ├── index.js
   ├── index.d.ts
   ├── index.js.map
   └── package.json
   ```

2. Documentation
   ```
   docs/
   ├── api/
   ├── guides/
   ├── examples/
   └── changelog.md
   ```

### 7.2 Release Tags
```bash
# Create tag
git tag -a v2.0.0 -m "Release v2.0.0"

# Push tag
git push origin v2.0.0

# Create release
gh release create v2.0.0 \
    --title "v2.0.0" \
    --notes "Release notes..."
```

## 8. Rollback Procedures

### 8.1 Package Rollback
```bash
# 1. Unpublish
npm unpublish @jadugar/types@2.0.0

# 2. Revert Tag
git tag -d v2.0.0
git push origin :v2.0.0

# 3. Restore Previous
npm publish @jadugar/types@1.0.0
```

### 8.2 System Rollback
```bash
# 1. Revert Commit
git revert HEAD

# 2. Update Dependencies
yarn up @jadugar/types@1.0.0

# 3. Rebuild
yarn build

# 4. Verify
yarn test
```

## 9. Release Communication

### 9.1 Release Notes
```markdown
# Release Notes v2.0.0

## Highlights
- New type system
- Enhanced performance
- Better developer experience

## Breaking Changes
- See migration guide

## Installation
\`\`\`bash
yarn add @jadugar/types@2.0.0
\`\`\`

## Documentation
- [API Reference](./api)
- [Migration Guide](./migration)
- [Examples](./examples)
```

### 9.2 Release Announcement
```markdown
# Jadugar v2.0.0 Released!

We're excited to announce Jadugar v2.0.0!

## What's New
- Complete type system rewrite
- 50% performance improvement
- Enhanced developer tools

## Get Started
\`\`\`bash
yarn add @jadugar/types@2.0.0
\`\`\`

## Resources
- [Documentation](./docs)
- [Migration](./migration)
- [Examples](./examples)
```

## 10. Release Maintenance

### 10.1 Post-Release Tasks
1. Monitor
   - Usage metrics
   - Error rates
   - Performance
   - Feedback

2. Support
   - Issue triage
   - Bug fixes
   - Documentation
   - Examples

### 10.2 Long-term Tasks
1. Clean up
   - Old versions
   - Legacy code
   - Documentation
   - Examples

2. Planning
   - Next release
   - Feature roadmap
   - Breaking changes
   - Migration path
