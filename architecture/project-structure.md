# Project Structure

## Overview
This document outlines Jadugar's project structure, designed to support our phased development approach while maintaining clarity, scalability, and maintainability.

## Root Structure

```
jadugar/
├── apps/                      # Application implementations
├── packages/                  # Shared packages
├── docs/                      # Documentation
├── config/                    # Configuration files
├── scripts/                   # Build and utility scripts
├── tests/                     # Test suites
└── tools/                     # Development tools
```

## Detailed Structure

### 1. Applications (`apps/`)
Contains deployable applications:
```
apps/
├── web/                      # Web application
│   ├── src/                 # Application source
│   ├── public/             # Static assets
│   └── config/             # App-specific config
└── mobile/                  # Mobile application (future)
    ├── src/                # Mobile source
    └── assets/             # Mobile assets
```

### 2. Packages (`packages/`)
Shared code and functionality:
```
packages/
├── core/                    # Core functionality
│   ├── config/             # Configuration system
│   ├── error/              # Error handling
│   └── utils/              # Core utilities
├── ui/                      # UI components
│   ├── components/         # Base components
│   ├── hooks/              # React hooks
│   └── styles/             # Shared styles
└── utils/                  # Shared utilities
    ├── validation/         # Validation utils
    ├── formatting/         # Formatting utils
    └── testing/           # Test utilities
```

### 3. Configuration (`config/`)
Project configuration files:
```
config/
├── development/            # Development configs
│   ├── eslint/            # ESLint configuration
│   ├── prettier/          # Prettier configuration
│   ├── editor/            # Editor configuration
│   ├── env/              # Environment variables
│   └── tsconfig/         # TypeScript configuration
├── testing/               # Testing configs
│   ├── jest/             # Jest configuration
│   └── env/              # Test environment
├── docker/               # Docker configs
│   ├── Dockerfile       # Main Dockerfile
│   └── compose/         # Docker compose files
└── monitoring/          # Monitoring configs
    └── otel/            # OpenTelemetry configs
```

### 4. Scripts (`scripts/`)
Build and utility scripts:
```
scripts/
├── build/                # Build scripts
├── dev/                  # Development scripts
├── test/                # Test scripts
├── tools/               # Utility scripts
└── validation/          # Verification scripts
```

### 5. Tools (`tools/`)
Development tools:
```
tools/
├── dev/                  # Development tools
│   ├── husky/           # Git hooks
│   └── vscode/          # VSCode configuration
├── build/               # Build tools
└── analysis/            # Analysis tools
```

### 6. Tests (`tests/`)
Test suites:
```
tests/
├── unit/                # Unit tests
├── integration/         # Integration tests
└── e2e/                # End-to-end tests
```

## Configuration Files

### TypeScript Configuration
- Base configuration: `config/development/tsconfig.base.json`
- Workspace configuration: `config/development/tsconfig.workspace.json`
- Project configuration: `config/development/tsconfig.json`

### Code Style
- ESLint: `config/development/eslint/.eslintrc.js`
- Prettier: `config/development/prettier/.prettierrc`
- EditorConfig: `config/development/editor/.editorconfig`

### Testing
- Jest configuration: `config/testing/jest.config.js`
- Test setup: `config/testing/jest.setup.js`

## Scripts

### Build Scripts
- `scripts/build/build.sh`: Main build script
- `scripts/build/build-prod.sh`: Production build

### Development Scripts
- `scripts/dev/start-dev.sh`: Start development server
- `scripts/dev/watch.sh`: Watch mode for development

### Validation Scripts
- `scripts/validation/verify-env.sh`: Environment validation
- `scripts/validation/verify-docs.sh`: Documentation validation
- `scripts/validation/verify-typescript.sh`: TypeScript validation

### Utility Scripts
- `scripts/tools/clean.sh`: Clean build artifacts
- `scripts/tools/update-imports.sh`: Update import statements

## Purpose and Benefits

### 1. Clear Separation of Concerns
- Applications are isolated from shared code
- Each package has a specific responsibility
- Configuration is environment-specific
- Tests are organized by type and scope

### 2. Scalability
- New applications can be added to `apps/`
- Shared code can be added as new packages
- Documentation structure supports growth
- Test organization scales with codebase

### 3. Development Workflow
- Clear path for new features
- Consistent testing structure
- Environment-specific configurations
- Automated tooling support

### 4. Maintainability
- Logical grouping of related code
- Clear documentation structure
- Centralized configuration
- Automated testing organization

## Implementation Guidelines

### 1. File Naming
- Use kebab-case for directories
- Use camelCase for JavaScript/TypeScript files
- Use PascalCase for React components
- Use `.config.js` suffix for config files

### 2. Code Organization
- Group related functionality
- Keep files focused and small
- Use index files for exports
- Maintain clear dependencies

### 3. Documentation
- Keep docs close to code
- Use consistent formatting
- Include examples
- Keep READMEs updated

### 4. Testing
- Co-locate unit tests with code
- Group integration tests by feature
- Organize E2E tests by flow
- Maintain test utilities separately
