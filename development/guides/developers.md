# Developer's Guide to Jadugar

## Overview
This guide will help you set up your development environment and understand the key concepts of Jadugar's monorepo development approach.

## Prerequisites
- Node.js (v18 or higher)
- Yarn (v1.22 or higher)
- TypeScript (v5.0 or higher)
- Git
- VS Code (recommended)

## Development Environment Setup

### 1. Clone the Repository
```bash
git clone https://github.com/username/jadugar.git
cd jadugar
```

### 2. Install Dependencies
```bash
# Install all workspace dependencies
yarn install
```

### 3. Configure Environment
```bash
# Copy environment files for each workspace
cp apps/web/.env.example apps/web/.env
cp packages/core/.env.example packages/core/.env
# Edit .env files with your settings
```

### 4. Development Tools
- Install recommended VS Code extensions
- Set up linting and formatting
- Configure test runners
- Install Turborepo CLI globally (optional)
  ```bash
  yarn global add turbo
  ```

## Project Structure
```
jadugar/
├── apps/                      # Application implementations
│   ├── web/                  # Next.js web application
│   └── mobile/              # React Native application
├── packages/                  # Shared packages
│   ├── core/                # Core business logic
│   ├── ui/                  # Shared UI components
│   └── utils/              # Utility functions
├── docs/                      # Documentation
├── config/                    # Shared configurations
│   ├── eslint/              # ESLint configurations
│   └── typescript/          # TypeScript configurations
└── tools/                     # Development tools and scripts
```

## Development Workflow

### 1. Package Development
```bash
# Create a new package
cd packages
mkdir my-package
cd my-package
yarn init

# Link package in workspace
# Update package.json:
{
  "name": "@jadugar/my-package",
  "version": "0.1.0"
}
```

### 2. Application Development
```bash
# Start web application
yarn workspace @jadugar/web dev

# Start mobile application
yarn workspace @jadugar/mobile start
```

### 3. Testing
```bash
# Run tests for all packages
yarn test

# Run tests for specific package
yarn workspace @jadugar/core test

# Run tests in watch mode
yarn test:watch
```

### 4. Building
```bash
# Build all packages
yarn build

# Build specific package
yarn workspace @jadugar/web build
```

## Common Tasks

### Adding Dependencies
```bash
# Add dependency to specific package
yarn workspace @jadugar/web add react

# Add dependency to all packages
yarn add -W typescript

# Add internal package dependency
yarn workspace @jadugar/web add @jadugar/core@*
```

### Running Scripts
```bash
# Run script in all packages
yarn turbo run lint

# Run script in specific package
yarn workspace @jadugar/core lint
```

### Type Checking
```bash
# Check types across all packages
yarn typecheck

# Check types for specific package
yarn workspace @jadugar/core typecheck
```

## Best Practices

### 1. Package Development
- Keep packages focused and minimal
- Use clear, semantic versioning
- Document all public APIs
- Write comprehensive tests

### 2. Dependency Management
- Prefer internal packages over external ones
- Keep dependency trees shallow
- Use workspace protocol for internal dependencies
- Regularly update dependencies

### 3. Code Organization
- Group related functionality
- Use feature-based organization
- Keep components independent
- Follow monorepo style guide

### 4. Testing Strategy
- Write tests before implementation
- Use shared test utilities
- Test cross-package integration
- Maintain high coverage

## Troubleshooting

### Common Issues
1. **Workspace not found**
   ```bash
   # Refresh yarn's workspace list
   yarn
   ```

2. **Build cache issues**
   ```bash
   # Clear Turborepo cache
   yarn turbo clean
   ```

3. **Type errors across packages**
   ```bash
   # Rebuild all TypeScript packages
   yarn clean && yarn build
   ```

## Additional Resources
- [Turborepo Documentation](https://turborepo.org/docs)
- [Yarn Workspaces Guide](https://yarnpkg.com/features/workspaces)
- [TypeScript Project References](https://www.typescriptlang.org/docs/handbook/project-references.html)
