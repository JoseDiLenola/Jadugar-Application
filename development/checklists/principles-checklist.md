# Development Principles Checklist

Use this checklist when developing new features or reviewing code.

## 1. YAGNI (You Aren't Gonna Need It)
- [ ] Is this feature needed right now?
- [ ] Can we solve the problem with existing code?
- [ ] Are we adding unnecessary abstraction?
- [ ] Is the implementation focused on current requirements?
- [ ] Are we over-engineering any part?

## 2. Type Safety
- [ ] Are all types explicitly defined?
- [ ] Is strict mode enabled and followed?
- [ ] Are we using type inference appropriately?
- [ ] Are there any unsafe type assertions?
- [ ] Are generics used where appropriate?
- [ ] Are union types properly narrowed?
- [ ] Are API responses properly typed?

## 3. Single Responsibility
- [ ] Does each class/function do one thing well?
- [ ] Are concerns properly separated?
- [ ] Is the code organized by feature/domain?
- [ ] Are file names descriptive of their purpose?
- [ ] Is related code colocated?
- [ ] Are dependencies minimized?

## 4. Testing
- [ ] Are tests written before implementation?
- [ ] Is there sufficient test coverage?
- [ ] Are edge cases tested?
- [ ] Are error conditions tested?
- [ ] Are tests readable and well-described?
- [ ] Are tests independent and idempotent?
- [ ] Is test data clearly separated?
- [ ] Are mocks used appropriately?

## 5. Immutability
- [ ] Are objects immutable after creation?
- [ ] Are arrays handled immutably?
- [ ] Are readonly properties used where appropriate?
- [ ] Is state modification centralized?
- [ ] Are pure functions preferred?

## 6. Error Handling
- [ ] Are errors properly typed?
- [ ] Are error messages clear and helpful?
- [ ] Are all edge cases handled?
- [ ] Is error recovery graceful?
- [ ] Are errors logged appropriately?
- [ ] Are async errors caught properly?

## 7. Documentation
- [ ] Is the public API documented?
- [ ] Are complex algorithms explained?
- [ ] Are examples provided?
- [ ] Is the README up to date?
- [ ] Are architectural decisions documented?
- [ ] Are dependencies listed and explained?

## 8. Performance
- [ ] Are data structures appropriate?
- [ ] Are there any unnecessary computations?
- [ ] Is memory managed properly?
- [ ] Are resources cleaned up?
- [ ] Are expensive operations optimized?
- [ ] Is caching used where appropriate?

## 9. Security
- [ ] Is user input sanitized?
- [ ] Are secrets properly handled?
- [ ] Is authentication implemented securely?
- [ ] Are permissions checked?
- [ ] Is sensitive data protected?

## 10. Code Style
- [ ] Does code follow project conventions?
- [ ] Is naming clear and consistent?
- [ ] Is code properly formatted?
- [ ] Are comments helpful and necessary?
- [ ] Is the code DRY (Don't Repeat Yourself)?

## 11. Bottom-Up Problem Solving
- [ ] Are we fixing root causes rather than symptoms?
- [ ] Have we tested foundational components in isolation?
- [ ] Are error handlers placed at the appropriate level?
- [ ] Is error recovery handled at the source?
- [ ] Are we logging errors with proper context?
- [ ] Do we have proper error boundaries?

## 12. Dependency Hierarchy
- [ ] Are dependencies unidirectional?
- [ ] Can each module exist independently of higher-level modules?
- [ ] Are core modules free of external dependencies?
- [ ] Is the dependency graph clear and documented?
- [ ] Are circular dependencies prevented?
- [ ] Do feature modules only depend on infrastructure/core?

## Project-Specific Checks
- [ ] Does it follow our environment configuration pattern?
- [ ] Are types colocated with implementations?
- [ ] Is configuration immutable?
- [ ] Are tests following our established patterns?
- [ ] Is documentation in the right location?
