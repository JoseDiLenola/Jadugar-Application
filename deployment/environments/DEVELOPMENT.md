# Jadugar Development Environment Guide

## Technology Stack

### Frontend Technologies
```yaml
core:
  framework: React 18
  language: TypeScript 5.3
  bundler: Vite 5.0
  styling: TailwindCSS 3.4

testing:
  unit: Vitest 1.0
  component: React Testing Library 14
  e2e: Playwright 1.40

development:
  state: Redux Toolkit 2.0
  forms: React Hook Form 7.0
  validation: Zod 3.0
  charts: Chart.js 4.0
  realtime: Socket.io-client 4.7
```

### Backend Technologies
```yaml
core:
  runtime: Node.js 20 LTS
  framework: Express 4.18
  language: TypeScript 5.3
  orm: Prisma 5.7

testing:
  unit: Jest 29
  integration: Supertest 6.0
  coverage: Istanbul 3.0

development:
  websocket: Socket.io 4.7
  validation: Zod 3.0
  logging: Winston 3.11
  metrics: Prometheus 5.0
```

### Database Technologies
```yaml
primary:
  type: PostgreSQL 15
  orm: Prisma
  migrations: Prisma Migrate
  
cache:
  type: Redis 7.2
  client: ioredis 5.0
```

### Development Tools
```yaml
ide:
  primary: VSCode 1.85+
  extensions:
    - ESLint
    - Prettier
    - TypeScript
    - Prisma
    - GitLens
    
version_control:
  system: Git 2.43+
  hosting: GitHub
  flow: GitHub Flow

containerization:
  engine: Docker 24+
  compose: Docker Compose v2
```

## Local Setup

### 1. Prerequisites Installation
```bash
# 1. Install Node.js (using nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20

# 2. Install PostgreSQL
brew install postgresql@15
brew services start postgresql@15

# 3. Install Redis
brew install redis
brew services start redis

# 4. Install Docker
brew install --cask docker
```

### 2. Repository Setup
```bash
# 1. Clone Repository
git clone https://github.com/your-org/jadugar.git
cd jadugar

# 2. Install Dependencies
npm install

# 3. Setup Git Hooks
npx husky install
```

### 3. Environment Configuration
```bash
# 1. Create Environment Files
cp .env.example .env.development

# 2. Configure Environment Variables
cat > .env.development << EOL
# Database
DATABASE_URL="postgresql://localhost:5432/jadugar_dev"
REDIS_URL="redis://localhost:6379/0"

# API
API_PORT=3000
API_URL="http://localhost:3000"

# Frontend
VITE_API_URL="http://localhost:3000"
VITE_WS_URL="ws://localhost:3000"
EOL
```

## Development Workflow

### 1. Starting Development Environment
```bash
# 1. Start Database
docker-compose up -d db redis

# 2. Run Migrations
npm run prisma:migrate

# 3. Start Backend
npm run dev:api

# 4. Start Frontend
npm run dev:web
```

### 2. Development Scripts
```json
{
  "scripts": {
    "dev": "turbo run dev",
    "dev:web": "turbo run dev --filter=@jadugar/web",
    "dev:api": "turbo run dev --filter=@jadugar/api",
    "test": "turbo run test",
    "lint": "turbo run lint",
    "type-check": "turbo run type-check"
  }
}
```

## Testing Environment

### 1. Unit Testing
```typescript
// Example Component Test
import { render, screen } from '@testing-library/react';
import { BuildCard } from './BuildCard';

describe('BuildCard', () => {
  it('displays build status correctly', () => {
    render(<BuildCard build={mockBuild} />);
    expect(screen.getByText('Build Success')).toBeInTheDocument();
  });
});

// Example Service Test
describe('BuildService', () => {
  it('creates new build', async () => {
    const service = new BuildService();
    const build = await service.createBuild(mockConfig);
    expect(build.status).toBe('pending');
  });
});
```

### 2. Integration Testing
```typescript
// API Integration Test
import request from 'supertest';
import { app } from './app';

describe('Build API', () => {
  it('creates new build', async () => {
    const response = await request(app)
      .post('/api/builds')
      .send(mockBuildConfig);
    
    expect(response.status).toBe(201);
    expect(response.body.build).toBeDefined();
  });
});
```

### 3. E2E Testing
```typescript
// Playwright E2E Test
import { test, expect } from '@playwright/test';

test('complete build workflow', async ({ page }) => {
  await page.goto('/');
  await page.click('[data-testid="new-build"]');
  await expect(page.locator('[data-testid="build-status"]'))
    .toHaveText('Running');
});
```

## Debug Configuration

### 1. VSCode Debug Configuration
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug API",
      "skipFiles": ["<node_internals>/**"],
      "program": "${workspaceFolder}/packages/api/src/index.ts",
      "outFiles": ["${workspaceFolder}/packages/api/dist/**/*.js"],
      "env": {
        "NODE_ENV": "development"
      }
    },
    {
      "type": "chrome",
      "request": "launch",
      "name": "Debug Web",
      "url": "http://localhost:3000",
      "webRoot": "${workspaceFolder}/packages/web"
    }
  ]
}
```

### 2. Browser DevTools Configuration
```typescript
// Redux DevTools Configuration
const store = configureStore({
  reducer: rootReducer,
  devTools: process.env.NODE_ENV === 'development',
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(logger)
});

// React DevTools Configuration
if (process.env.NODE_ENV === 'development') {
  const { whyDidYouUpdate } = require('why-did-you-update');
  whyDidYouUpdate(React);
}
```

## Development Database

### 1. Database Setup
```sql
-- Create Development Database
CREATE DATABASE jadugar_dev;
CREATE USER jadugar_dev WITH PASSWORD 'development';
GRANT ALL PRIVILEGES ON DATABASE jadugar_dev TO jadugar_dev;

-- Enable Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
```

### 2. Prisma Configuration
```prisma
// schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

// Development-specific configuration
generator dbml {
  provider = "prisma-dbml-generator"
  output   = "../dbml"
}
```

## Local Services

### 1. Docker Compose Configuration
```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: jadugar_dev
      POSTGRES_USER: jadugar_dev
      POSTGRES_PASSWORD: development
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7.2
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  mailhog:
    image: mailhog/mailhog
    ports:
      - "1025:1025"
      - "8025:8025"

volumes:
  postgres_data:
  redis_data:
```

### 2. Service Configuration
```typescript
// Email Service Configuration
const emailConfig = {
  development: {
    host: 'localhost',
    port: 1025,
    secure: false,
    ignoreTLS: true
  }
};

// Redis Configuration
const redisConfig = {
  development: {
    host: 'localhost',
    port: 6379,
    db: 0
  }
};
```

## Development Utilities

### 1. Data Seeding
```typescript
// seed.ts
import { PrismaClient } from '@prisma/client';
import { faker } from '@faker-js/faker';

const prisma = new PrismaClient();

async function seed() {
  // Create test projects
  const projects = await Promise.all(
    Array.from({ length: 5 }).map(() =>
      prisma.project.create({
        data: {
          name: faker.company.name(),
          description: faker.company.catchPhrase()
        }
      })
    )
  );

  // Create test builds
  await Promise.all(
    projects.flatMap((project) =>
      Array.from({ length: 10 }).map(() =>
        prisma.build.create({
          data: {
            projectId: project.id,
            status: faker.helpers.arrayElement([
              'pending',
              'running',
              'complete',
              'failed'
            ]),
            progress: faker.number.int({ min: 0, max: 100 })
          }
        })
      )
    )
  );
}

seed();
```

### 2. Development CLI
```typescript
// cli.ts
import { Command } from 'commander';
import { PrismaClient } from '@prisma/client';

const program = new Command();
const prisma = new PrismaClient();

program
  .command('create-build')
  .description('Create a test build')
  .option('-p, --project <id>', 'Project ID')
  .action(async (options) => {
    const build = await prisma.build.create({
      data: {
        projectId: options.project,
        status: 'pending',
        progress: 0
      }
    });
    console.log('Created build:', build);
  });

program.parse(process.argv);
```

## Development Monitoring

### 1. Logging Configuration
```typescript
// winston.config.ts
import winston from 'winston';

export const logger = winston.createLogger({
  level: 'debug',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({
      filename: 'logs/development.log'
    })
  ]
});
```

### 2. Metrics Configuration
```typescript
// prometheus.config.ts
import { Registry, Counter, Histogram } from 'prom-client';

export const registry = new Registry();

export const buildDuration = new Histogram({
  name: 'build_duration_seconds',
  help: 'Build duration in seconds',
  labelNames: ['project', 'status'],
  buckets: [30, 60, 120, 300, 600]
});

registry.registerMetric(buildDuration);
```

## Development Security

### 1. Authentication Configuration
```typescript
// auth.config.ts
export const authConfig = {
  development: {
    jwt: {
      secret: 'development-secret',
      expiresIn: '1d'
    },
    cors: {
      origin: 'http://localhost:3000',
      credentials: true
    }
  }
};
```

### 2. Authorization Configuration
```typescript
// rbac.config.ts
export const rbacConfig = {
  development: {
    roles: {
      admin: {
        can: ['manage', 'read', 'write']
      },
      developer: {
        can: ['read', 'write']
      },
      viewer: {
        can: ['read']
      }
    }
  }
};
```
