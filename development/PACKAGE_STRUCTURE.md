# Package Structure

## Overview

Jadugar follows a monorepo structure using Turborepo. The codebase is organized into apps and packages:

```
jadugar/
├── apps/                  # Application packages
├── packages/             # Shared packages
├── tools/                # Development tools
└── docs/                 # Documentation
```

## Applications (apps/)

### Web Application (@jadugar/web)
```
apps/web/
├── src/
│   ├── components/       # React components
│   ├── pages/           # Next.js pages
│   ├── styles/          # CSS styles
│   ├── hooks/           # React hooks
│   ├── utils/           # Utilities
│   └── types/           # TypeScript types
├── public/              # Static assets
├── tests/               # Test files
└── package.json
```

### API Server (@jadugar/api)
```
apps/api/
├── src/
│   ├── controllers/     # Route controllers
│   ├── services/        # Business logic
│   ├── middleware/      # Express middleware
│   ├── routes/          # API routes
│   ├── utils/           # Utilities
│   └── types/           # TypeScript types
├── tests/               # Test files
└── package.json
```

## Shared Packages (packages/)

### Authentication (@jadugar/auth)
```
packages/auth/
├── src/
│   ├── lib/            # Core functionality
│   ├── utils/          # Utilities
│   ├── types/          # TypeScript types
│   └── index.ts        # Package entry
├── tests/              # Test files
└── package.json
```

### Service Registry (@jadugar/registry)
```
packages/registry/
├── src/
│   ├── lib/            # Core functionality
│   ├── utils/          # Utilities
│   ├── types/          # TypeScript types
│   └── index.ts        # Package entry
├── tests/              # Test files
└── package.json
```

### Progress Tracking (@jadugar/tracking)
```
packages/tracking/
├── src/
│   ├── lib/            # Core functionality
│   ├── utils/          # Utilities
│   ├── types/          # TypeScript types
│   └── index.ts        # Package entry
├── tests/              # Test files
└── package.json
```

### API Gateway (@jadugar/gateway)
```
packages/gateway/
├── src/
│   ├── lib/            # Core functionality
│   ├── utils/          # Utilities
│   ├── types/          # TypeScript types
│   └── index.ts        # Package entry
├── tests/              # Test files
└── package.json
```

### UI Components (@jadugar/ui)
```
packages/ui/
├── src/
│   ├── components/     # React components
│   ├── hooks/          # React hooks
│   ├── styles/         # CSS styles
│   ├── utils/          # Utilities
│   └── index.ts        # Package entry
├── tests/              # Test files
└── package.json
```

### Core Utilities (@jadugar/core)
```
packages/core/
├── src/
│   ├── lib/            # Core functionality
│   ├── utils/          # Utilities
│   ├── types/          # TypeScript types
│   └── index.ts        # Package entry
├── tests/              # Test files
└── package.json
```

### TypeScript Types (@jadugar/types)
```
packages/types/
├── src/
│   ├── auth/           # Auth types
│   ├── registry/       # Registry types
│   ├── tracking/       # Tracking types
│   ├── gateway/        # Gateway types
│   └── index.ts        # Package entry
└── package.json
```

## Development Tools (tools/)

### Scripts
```
tools/scripts/
├── build/              # Build scripts
├── test/               # Test scripts
├── lint/               # Lint scripts
└── deploy/             # Deploy scripts
```

### Config Files
```
tools/config/
├── eslint/             # ESLint configs
├── typescript/         # TS configs
├── jest/               # Jest configs
└── prettier/           # Prettier configs
```

## Package Dependencies

### Core Dependencies
- All packages depend on @jadugar/types
- All packages depend on @jadugar/core
- Web app depends on @jadugar/ui

### Service Dependencies
- API depends on all service packages
- Gateway depends on all service packages
- Services are independent of each other

## Version Management

### Package Versions
- All packages use semantic versioning
- Versions are managed by Changesets
- Major version changes require team review

### Dependencies
- External dependencies are hoisted
- Package dependencies are explicit
- Dev dependencies are shared
