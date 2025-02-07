# Quick Start Guide

## Overview
This guide will help you get started with Jadugar quickly. Follow these steps to set up your development environment and run your first application.

## Prerequisites
- Node.js 20.x
- npm 9.x
- Git
- VS Code (recommended)

## Initial Setup

1. Clone the Repository:
```bash
git clone https://github.com/your-org/jadugar.git
cd jadugar
```

2. Install Dependencies:
```bash
npm install
```

3. Build Packages (in order):
```bash
# Build types first
npm run build -w @jadugar/types

# Build utils
npm run build -w @jadugar/utils

# Build core
npm run build -w @jadugar/core

# Build UI
npm run build -w @jadugar/ui

# Build API
npm run build -w @jadugar/api
```

## Development Workflow

### 1. Package Development
Always follow the package hierarchy:
1. Start with `@jadugar/types`
2. Move to `@jadugar/utils`
3. Implement `@jadugar/core`
4. Create `@jadugar/ui` components
5. Build `@jadugar/api` endpoints

### 2. Running Tests
```bash
# Run all tests
npm test

# Test specific package
npm test -w @jadugar/[package-name]

# Watch mode
npm run test:watch -w @jadugar/[package-name]
```

### 3. Development Server
```bash
# Start all services
npm run dev

# Start specific package
npm run dev -w @jadugar/[package-name]
```

## Validation Gates

### 1. Type Safety
```bash
# Check types
npm run type-check

# Generate type documentation
npm run types:docs
```

### 2. Testing
```bash
# Run tests with coverage
npm run test:coverage

# Update snapshots
npm run test:update
```

### 3. Linting
```bash
# Lint all packages
npm run lint

# Fix linting issues
npm run lint:fix
```

## Common Commands

### Package Development
```bash
# Create new package
npm create @jadugar/[package-name]

# Add dependency
npm add @jadugar/[package-name] -w @jadugar/[target-package]

# Build package
npm run build -w @jadugar/[package-name]
```

### Testing
```bash
# Run specific tests
npm test -- -t "test name"

# Debug tests
npm run test:debug
```

### Documentation
```bash
# Generate docs
npm run docs:generate

# Validate docs
npm run docs:validate
```

## Getting Help

### 1. Documentation
- [Package Development Guide](./development/PACKAGE_GUIDE.md)
- [API Documentation](./api/API_DOCUMENTATION.md)
- [Troubleshooting Guide](./troubleshooting/TROUBLESHOOTING_GUIDE.md)

### 2. Development Support
- Create GitHub issue
- Check existing issues
- Join Discord channel

### 3. Common Issues
- Clear build cache: `npm run clean`
- Reset dependencies: `npm ci`
- Update packages: `npm update`

## Next Steps
1. Review [Package Development Guide](./development/PACKAGE_GUIDE.md)
2. Set up your [Development Environment](./deployment/environments/DEVELOPMENT.md)
3. Start with [@jadugar/types](./packages/types/README.md)
