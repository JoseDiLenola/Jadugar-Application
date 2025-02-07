# Jadugar Code Style Guide

## TypeScript Guidelines

### 1. File Organization
- One class/interface per file
- Files should be named in kebab-case
- Class names should be in PascalCase
- Interface names should start with 'I'
- Type names should be in PascalCase

### 2. Code Structure
```typescript
// Imports ordered by: external, internal, types
import { external } from 'external-lib';
import { internal } from '@/internal';
import type { IType } from '@/types';

// Interface definition
interface IExample {
  property: string;
  method(): void;
}

// Class implementation
export class Example implements IExample {
  private readonly property: string;

  constructor(property: string) {
    this.property = property;
  }

  public method(): void {
    // Implementation
  }
}
```

### 3. Naming Conventions
- Variables: camelCase
- Constants: UPPER_SNAKE_CASE
- Private properties: prefix with _
- Boolean variables: prefix with is/has/should
- Async methods: suffix with Async

### 4. Comments and Documentation
- Use JSDoc for public APIs
- Keep comments focused on why, not what
- Document complex algorithms
- Use TODO comments for temporary solutions

### 5. Error Handling
- Use typed errors
- Always include error context
- Prefer early returns
- Use async/await with try/catch

### 6. Testing Standards
- Test file names: *.test.ts
- Describe blocks for classes/functions
- Test edge cases and error conditions
- Mock external dependencies
- Maintain 80% coverage minimum

### 7. Best Practices
- Prefer immutability
- Use strong typing
- Avoid any type
- Use null coalescing and optional chaining
- Keep functions small and focused

## Code Review Guidelines

### 1. Review Checklist
- Code follows style guide
- Tests are comprehensive
- Documentation is complete
- Error handling is robust
- Performance considerations addressed

### 2. Pull Request Process
- Clear description of changes
- Link to related issues
- Screenshots for UI changes
- List of testing steps
- Migration notes if needed

## Version Control

### 1. Git Commits
- Use conventional commits
- Keep commits focused
- Write clear commit messages
- Reference issues in commits

### 2. Branching Strategy
- main: production code
- develop: integration branch
- feature/*: new features
- bugfix/*: bug fixes
- release/*: release preparation

### 3. Version Management
- Follow semantic versioning (MAJOR.MINOR.PATCH)
- Document all breaking changes
- Update CHANGELOG.md for each release
- Tag all releases
- Keep dependencies up to date

### 4. Version Tracking
- Check versions according to schedule:
  - Security-critical: Weekly
  - Core dependencies: Bi-weekly
  - Development tools: Bi-weekly
  - Documentation: Monthly
- Document all version checks
- Test updates in development
- Update tracking spreadsheets
- Monitor for breaking changes

### 5. Update Process
1. Regular Checks
   - Run npm audit
   - Check GitHub security alerts
   - Review dependency updates
   - Monitor breaking changes

2. Update Evaluation
   - Review changelogs
   - Check compatibility
   - Test in development
   - Document impacts

3. Update Implementation
   - Schedule updates
   - Test thoroughly
   - Update documentation
   - Monitor deployment

4. Post-Update Tasks
   - Update tracking sheets
   - Document changes
   - Notify stakeholders
   - Monitor for issues

## Tools and Configuration

### 1. Required Extensions
- ESLint
- Prettier
- TypeScript
- Jest Runner

### 2. Editor Configuration
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```
