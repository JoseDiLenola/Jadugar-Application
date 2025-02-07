# Development Setup Guide

## Prerequisites

### Required Software
- Node.js (v18 or later)
- Docker Desktop
- Git
- Visual Studio Code (recommended)
- PostgreSQL (v14 or later)
- Redis (v6 or later)

### Recommended VS Code Extensions
- ESLint
- Prettier
- Docker
- GitLens
- PostgreSQL

## Initial Setup

### 1. Clone Repository
```bash
git clone https://github.com/your-org/jadugar.git
cd jadugar
```

### 2. Install Dependencies
```bash
# Install global tools
npm install -g turbo

# Install project dependencies
yarn install
```

### 3. Environment Setup
```bash
# Copy environment files
cp .env.example .env
cp apps/web/.env.example apps/web/.env
cp apps/api/.env.example apps/api/.env
```

### 4. Database Setup
```bash
# Start PostgreSQL and Redis
docker-compose up -d db redis

# Run migrations
yarn workspace @jadugar/db migrate
```

### 5. Development Server
```bash
# Start all services
yarn dev

# Or start specific services
yarn workspace @jadugar/web dev
yarn workspace @jadugar/api dev
```

## Development Workflow

### 1. Branch Management
- Main branch: `main`
- Development branch: `develop`
- Feature branches: `feature/*`
- Bug fixes: `fix/*`

### 2. Code Style
- ESLint for linting
- Prettier for formatting
- TypeScript strict mode enabled
- Husky for pre-commit hooks

### 3. Testing
```bash
# Run all tests
yarn test

# Run specific package tests
yarn workspace @jadugar/auth test
```

### 4. Building
```bash
# Build all packages
yarn build

# Build specific package
yarn workspace @jadugar/web build
```

## Common Tasks

### Package Management
```bash
# Create new package
yarn turbo gen package

# Add dependency to package
yarn workspace @jadugar/web add react
```

### Database Management
```bash
# Create migration
yarn workspace @jadugar/db migrate:create

# Run migrations
yarn workspace @jadugar/db migrate:up

# Rollback migration
yarn workspace @jadugar/db migrate:down
```

### Docker Commands
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Troubleshooting

### Common Issues

1. **Port Conflicts**
   - Check if ports 3000, 4000, 5432, 6379 are available
   - Modify ports in docker-compose.yml if needed

2. **Database Connection**
   - Verify PostgreSQL is running
   - Check connection string in .env
   - Ensure migrations are up to date

3. **Node Modules**
   - Clear node_modules: `yarn clean`
   - Reinstall: `yarn install`

4. **Build Issues**
   - Clear build cache: `yarn clean:build`
   - Rebuild: `yarn build`

## Development Resources

### Documentation
- [Architecture Overview](../ARCHITECTURE.md)
- [API Documentation](./api/README.md)
- [Package Structure](./packages/README.md)

### Tools
- [Turbo Repo](https://turbo.build/repo)
- [Next.js](https://nextjs.org/docs)
- [TypeScript](https://www.typescriptlang.org/docs)

## Support

### Getting Help
- Check existing issues on GitHub
- Join team Discord channel
- Review documentation
- Ask in team meetings
