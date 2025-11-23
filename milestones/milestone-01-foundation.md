# Milestone 1: Project Foundation & Setup

**Duration:** 2-3 days  
**Status:** 🔴 Not Started  
**Dependencies:** None

---

## Objective

Initialize the blog CMS project with all necessary configurations, dependencies, and directory structure to establish a solid foundation for development.

---

## Technical Stack

- **Runtime:** Node.js >= 18.x
- **Framework:** Express.js
- **Database:** PostgreSQL with Prisma ORM
- **Session Store:** Redis
- **Language:** JavaScript (ES6+)
- **Package Manager:** npm

---

## Detailed Deliverables

### 1. Project Initialization

#### 1.1 Initialize Node.js Project
```bash
npm init -y
```

#### 1.2 Configure package.json
```json
{
  "name": "blog-cms",
  "version": "1.0.0",
  "description": "Dynamic blog CMS with authentication, comments, and full-text search",
  "main": "src/server.js",
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "scripts": {
    "start": "node src/server.js",
    "dev": "nodemon src/server.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src/**/*.js",
    "lint:fix": "eslint src/**/*.js --fix",
    "format": "prettier --write \"src/**/*.js\"",
    "db:migrate": "npx prisma migrate dev",
    "db:seed": "node prisma/seed.js",
    "db:reset": "npx prisma migrate reset",
    "db:studio": "npx prisma studio"
  },
  "keywords": ["blog", "cms", "express", "prisma", "postgresql"],
  "author": "Your Name",
  "license": "MIT"
}
```

---

### 2. Dependencies Installation

#### 2.1 Core Dependencies
```bash
npm install express prisma @prisma/client pg dotenv cors helmet express-session ioredis bcrypt jsonwebtoken express-validator winston morgan nodemailer socket.io multer sharp compression cookie-parser express-rate-limit sanitize-html bull
```

**Package Breakdown:**
- `express` - Web application framework
- `prisma` `@prisma/client` `pg` - Database ORM and PostgreSQL driver
- `dotenv` - Environment variables management
- `cors` - Cross-Origin Resource Sharing
- `helmet` - Security headers middleware
- `express-session` - Session management
- `ioredis` - Redis client for caching/sessions
- `bcrypt` - Password hashing
- `jsonwebtoken` - JWT token generation/validation
- `express-validator` - Input validation
- `winston` `morgan` - Logging
- `nodemailer` - Email sending
- `socket.io` - Real-time WebSocket connections
- `multer` `sharp` - File upload and image processing
- `compression` - Response compression
- `cookie-parser` - Parse cookies
- `express-rate-limit` - Rate limiting
- `sanitize-html` - HTML sanitization (XSS prevention)
- `bull` - Job queue for background tasks

#### 2.2 Development Dependencies
```bash
npm install --save-dev nodemon eslint prettier jest supertest @types/jest
```

**Package Breakdown:**
- `nodemon` - Auto-restart server on file changes
- `eslint` - JavaScript linter
- `prettier` - Code formatter
- `jest` `supertest` `@types/jest` - Testing framework

---

### 3. Directory Structure

Create the following directory structure:

```bash
mkdir -p src/{routes,controllers,services,middleware,utils,config,sockets}
mkdir -p prisma/migrations
mkdir -p tests/{unit,integration,fixtures}
mkdir -p uploads logs
mkdir -p docs
```

**Complete Structure:**
```
blog_lumetiumv1/
├── src/
│   ├── routes/              # API route definitions
│   ├── controllers/         # Request/response handlers
│   ├── services/            # Business logic layer
│   ├── middleware/          # Custom middleware
│   ├── utils/               # Helper functions
│   ├── config/              # Configuration files
│   ├── sockets/             # WebSocket handlers
│   └── server.js            # Application entry point
├── prisma/
│   ├── schema.prisma        # Database schema
│   ├── migrations/          # Database migrations
│   └── seed.js              # Seed data script
├── tests/
│   ├── unit/                # Unit tests
│   ├── integration/         # Integration tests
│   └── fixtures/            # Test data factories
├── docs/                    # Documentation
├── uploads/                 # Local file storage (development)
├── logs/                    # Application logs
├── milestones/              # Project milestones
├── .env                     # Environment variables (not committed)
├── .env.example             # Environment template
├── .gitignore               # Git ignore rules
├── .eslintrc.json           # ESLint configuration
├── .prettierrc              # Prettier configuration
├── jest.config.js           # Jest configuration
├── nodemon.json             # Nodemon configuration
├── package.json             # NPM dependencies
├── README.md                # Project documentation
└── CLAUDE.md                # AI assistant instructions
```

---

### 4. Configuration Files

#### 4.1 .env.example
```bash
# Environment
NODE_ENV=development
PORT=3000

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/blog_cms

# Redis
REDIS_URL=redis://localhost:6379

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_REFRESH_SECRET=your-refresh-secret-key-change-this-in-production
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# Session
SESSION_SECRET=your-session-secret-change-this-in-production
SESSION_MAX_AGE=604800000

# Email (SMTP)
SMTP_HOST=smtp.mailtrap.io
SMTP_PORT=2525
SMTP_USER=your-smtp-username
SMTP_PASSWORD=your-smtp-password
SMTP_FROM_EMAIL=noreply@blog-cms.com
SMTP_FROM_NAME=Blog CMS

# AWS S3 (Optional - for production image uploads)
AWS_S3_BUCKET=your-bucket-name
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1

# Application
APP_URL=http://localhost:3000
APP_NAME=Blog CMS

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# File Upload
MAX_FILE_SIZE=5242880
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/webp,image/gif
```

#### 4.2 .gitignore
```
# Dependencies
node_modules/
package-lock.json

# Environment variables
.env
.env.local
.env.*.local

# Logs
logs/
*.log
npm-debug.log*

# Uploads
uploads/

# Testing
coverage/
.nyc_output/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Build
dist/
build/

# Prisma
prisma/*.db
prisma/*.db-journal

# Misc
.cache/
tmp/
temp/
```

#### 4.3 .eslintrc.json
```json
{
  "env": {
    "node": true,
    "es2021": true,
    "jest": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": 2021,
    "sourceType": "module"
  },
  "rules": {
    "no-console": "warn",
    "no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "no-var": "error",
    "prefer-const": "error",
    "eqeqeq": ["error", "always"],
    "curly": "error",
    "brace-style": ["error", "1tbs"],
    "quotes": ["error", "single", { "avoidEscape": true }],
    "semi": ["error", "always"],
    "indent": ["error", 2],
    "comma-dangle": ["error", "never"],
    "arrow-parens": ["error", "always"]
  }
}
```

#### 4.4 .prettierrc
```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "none",
  "printWidth": 100,
  "arrowParens": "always"
}
```

#### 4.5 nodemon.json
```json
{
  "watch": ["src"],
  "ext": "js,json",
  "ignore": ["src/**/*.test.js", "node_modules"],
  "exec": "node src/server.js",
  "env": {
    "NODE_ENV": "development"
  }
}
```

#### 4.6 jest.config.js
```javascript
module.exports = {
  testEnvironment: 'node',
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/**/*.test.js',
    '!src/server.js'
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },
  testMatch: [
    '**/tests/**/*.test.js',
    '**/__tests__/**/*.js'
  ],
  setupFilesAfterEnv: ['<rootDir>/tests/setup.js'],
  verbose: true
};
```

---

### 5. Git Repository Setup

#### 5.1 Initialize Git
```bash
git init
```

#### 5.2 Initial Commit
```bash
git add .
git commit -m "Initial commit: Project foundation and structure"
```

#### 5.3 Create .gitattributes (optional)
```
* text=auto
*.js text eol=lf
*.json text eol=lf
*.md text eol=lf
```

---

### 6. Basic README.md

```markdown
# Blog CMS

A dynamic blog Content Management System built with Node.js, Express, PostgreSQL, and Prisma.

## Features

- 🔐 User authentication (JWT + Sessions)
- 📝 Post management (create, edit, publish, delete)
- 💬 Threaded comments with moderation
- 🔍 Full-text search
- 📧 Email notifications
- 🖼️ Image uploads
- 📊 Analytics and SEO
- ⚡ Real-time updates via WebSockets
- 👑 Admin dashboard

## Tech Stack

- **Backend:** Node.js, Express.js
- **Database:** PostgreSQL with Prisma ORM
- **Caching:** Redis
- **Real-time:** Socket.io
- **Authentication:** JWT + Sessions (hybrid)
- **Testing:** Jest, Supertest

## Prerequisites

- Node.js >= 18.x
- PostgreSQL >= 13
- Redis >= 6.x
- npm >= 8.x

## Quick Start

### 1. Install Dependencies
\`\`\`bash
npm install
\`\`\`

### 2. Setup Environment
\`\`\`bash
cp .env.example .env
# Edit .env with your configuration
\`\`\`

### 3. Setup Database
\`\`\`bash
npm run db:migrate
npm run db:seed
\`\`\`

### 4. Run Development Server
\`\`\`bash
npm run dev
\`\`\`

Server will start at http://localhost:3000

## Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm start` - Start production server
- `npm test` - Run tests
- `npm run test:watch` - Run tests in watch mode
- `npm run test:coverage` - Generate coverage report
- `npm run lint` - Run ESLint
- `npm run lint:fix` - Fix linting issues
- `npm run db:migrate` - Run database migrations
- `npm run db:seed` - Seed database with sample data
- `npm run db:reset` - Reset database

## Project Structure

See [ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed architecture documentation.

## API Documentation

See [API.md](docs/API.md) for complete API reference.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License

MIT
```

---

## Verification Steps

### 1. Test Installation
```bash
npm install
```
- Should complete without errors
- node_modules/ created
- package-lock.json generated

### 2. Test Linting
```bash
npm run lint
```
- Should run without errors (no files yet to lint)

### 3. Verify Directory Structure
```bash
ls -R src/ prisma/ tests/
```
- All directories should exist

### 4. Test Environment Variables
```bash
cat .env.example
```
- All variables documented

### 5. Git Status
```bash
git status
```
- Should show clean working tree (after initial commit)

---

## Success Criteria

- ✅ `npm install` runs without errors
- ✅ All dependencies installed successfully
- ✅ Directory structure matches specification
- ✅ ESLint configured and runs successfully
- ✅ Prettier configured
- ✅ Jest configured
- ✅ Environment variables documented in .env.example
- ✅ Git repository initialized
- ✅ README.md provides clear project overview
- ✅ .gitignore prevents committing sensitive files

---

## Common Issues & Solutions

### Issue: npm install fails
**Solution:** 
- Ensure Node.js >= 18.x is installed
- Clear npm cache: `npm cache clean --force`
- Delete node_modules and package-lock.json, then retry

### Issue: ESLint not working
**Solution:**
- Install ESLint extension in your editor
- Run `npx eslint --init` if needed

### Issue: Permission errors on Linux/Mac
**Solution:**
- Don't use `sudo` with npm
- Fix npm permissions: `sudo chown -R $USER ~/.npm`

---

## Next Steps

Once this milestone is complete, proceed to:
- **Milestone 2:** Database Layer & Prisma Setup

---

## Checklist

- [ ] Node.js >= 18.x installed
- [ ] PostgreSQL installed and running
- [ ] Redis installed and running
- [ ] npm install completed successfully
- [ ] All directories created
- [ ] All configuration files created
- [ ] .env file created from .env.example
- [ ] Git repository initialized
- [ ] Initial commit made
- [ ] README.md created
- [ ] Linting works
- [ ] Verified all success criteria

---

**Estimated Time:** 2-3 days  
**Status:** 🔴 Not Started

Update status to:
- 🟡 In Progress - when you start working
- 🟢 Complete - when all criteria met
