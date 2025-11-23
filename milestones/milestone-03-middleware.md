# Milestone 3: Core Application & Middleware Pipeline

**Duration:** 3-4 days  
**Status:** 🔴 Not Started  
**Dependencies:** Milestone 1, 2

---

## Objective

Build the Express server with complete middleware pipeline, security headers, logging infrastructure, error handling, and health check endpoints.

---

## Detailed Deliverables

### 1. Main Server Setup (src/server.js)

```javascript
require('dotenv').config();
const express = require('express');
const { prisma, testConnection, disconnect } = require('./config/database');
const { redisClient, testRedisConnection } = require('./config/redis');
const logger = require('./config/logger');
const app = require('./app');

const PORT = process.env.PORT || 3000;

let server;

async function startServer() {
  try {
    // Test database connection
    await testConnection();
    
    // Test Redis connection
    await testRedisConnection();
    
    // Start server
    server = app.listen(PORT, () => {
      logger.info(`🚀 Server running on port ${PORT}`);
      logger.info(`📝 Environment: ${process.env.NODE_ENV}`);
    });
  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
}

// Graceful shutdown
const shutdown = async (signal) => {
  logger.info(`${signal} received. Starting graceful shutdown...`);
  
  // Stop accepting new requests
  server.close(async () => {
    logger.info('HTTP server closed');
    
    // Close database connection
    await disconnect();
    
    // Close Redis connection
    await redisClient.quit();
    logger.info('Redis disconnected');
    
    logger.info('Graceful shutdown complete');
    process.exit(0);
  });
  
  // Force shutdown after 10 seconds
  setTimeout(() => {
    logger.error('Forced shutdown after timeout');
    process.exit(1);
  }, 10000);
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
  logger.error('Uncaught Exception:', error);
  process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
  logger.error('Unhandled Rejection at:', promise, 'reason:', reason);
  process.exit(1);
});

startServer();
```

### 2. Express App Configuration (src/app.js)

```javascript
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const compression = require('compression');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const RedisStore = require('connect-redis').default;
const morgan = require('morgan');

const logger = require('./config/logger');
const { redisClient } = require('./config/redis');
const corsConfig = require('./config/cors');
const rateLimiter = require('./middleware/rateLimiter');
const errorHandler = require('./middleware/errorHandler');
const notFoundHandler = require('./middleware/notFoundHandler');

const app = express();

// Security headers
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"]
    }
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));

// CORS
app.use(cors(corsConfig));

// Logging
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined', {
    stream: {
      write: (message) => logger.info(message.trim())
    }
  }));
}

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Cookie parsing
app.use(cookieParser(process.env.SESSION_SECRET));

// Session
app.use(session({
  store: new RedisStore({ client: redisClient }),
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: parseInt(process.env.SESSION_MAX_AGE) || 604800000 // 7 days
  },
  name: 'sessionId'
}));

// Compression
app.use(compression());

// Rate limiting
app.use(rateLimiter.global);

// Health check endpoints
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

app.get('/health/db', async (req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.json({ status: 'connected' });
  } catch (error) {
    res.status(500).json({ status: 'disconnected', error: error.message });
  }
});

app.get('/health/redis', async (req, res) => {
  try {
    await redisClient.ping();
    res.json({ status: 'connected' });
  } catch (error) {
    res.status(500).json({ status: 'disconnected', error: error.message });
  }
});

// Routes will be added in later milestones
// app.use('/api/auth', authRoutes);
// app.use('/api/posts', postRoutes);
// etc.

// 404 handler
app.use(notFoundHandler);

// Error handler (must be last)
app.use(errorHandler);

module.exports = app;
```

### 3. Custom Error Classes (src/utils/errors.js)

```javascript
class AppError extends Error {
  constructor(message, statusCode, isOperational = true) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    Error.captureStackTrace(this, this.constructor);
  }
}

class ValidationError extends AppError {
  constructor(message = 'Validation failed') {
    super(message, 400);
  }
}

class AuthenticationError extends AppError {
  constructor(message = 'Authentication required') {
    super(message, 401);
  }
}

class AuthorizationError extends AppError {
  constructor(message = 'Insufficient permissions') {
    super(message, 403);
  }
}

class NotFoundError extends AppError {
  constructor(resource = 'Resource') {
    super(`${resource} not found`, 404);
  }
}

class ConflictError extends AppError {
  constructor(message = 'Resource already exists') {
    super(message, 409);
  }
}

class RateLimitError extends AppError {
  constructor(message = 'Too many requests') {
    super(message, 429);
  }
}

module.exports = {
  AppError,
  ValidationError,
  AuthenticationError,
  AuthorizationError,
  NotFoundError,
  ConflictError,
  RateLimitError
};
```

### 4. Error Handler Middleware (src/middleware/errorHandler.js)

```javascript
const logger = require('../config/logger');

const errorHandler = (err, req, res, next) => {
  logger.error('Error:', {
    message: err.message,
    stack: err.stack,
    url: req.originalUrl,
    method: req.method,
    ip: req.ip,
    statusCode: err.statusCode
  });

  // Prisma errors
  if (err.code === 'P2002') {
    return res.status(409).json({
      error: 'Conflict',
      message: 'Resource already exists'
    });
  }

  if (err.code === 'P2025') {
    return res.status(404).json({
      error: 'Not Found',
      message: 'Resource not found'
    });
  }

  // Validation errors
  if (err.name === 'ValidationError') {
    return res.status(400).json({
      error: 'Validation Error',
      message: err.message,
      details: err.errors
    });
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json({
      error: 'Authentication Error',
      message: 'Invalid token'
    });
  }

  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({
      error: 'Authentication Error',
      message: 'Token expired'
    });
  }

  // Default error response
  const statusCode = err.statusCode || 500;
  const message = err.isOperational ? err.message : 'Internal server error';

  res.status(statusCode).json({
    error: statusCode === 500 ? 'Internal Server Error' : err.name,
    message,
    ...(process.env.NODE_ENV === 'development' && {
      stack: err.stack
    })
  });
};

module.exports = errorHandler;
```

### 5. Async Wrapper Utility (src/utils/asyncWrapper.js)

```javascript
const asyncWrapper = (fn) => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

module.exports = asyncWrapper;
```

### 6. Winston Logger (src/config/logger.js)

```javascript
const winston = require('winston');
const path = require('path');

const logLevel = process.env.NODE_ENV === 'production' ? 'info' : 'debug';

const logger = winston.createLogger({
  level: logLevel,
  format: winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    winston.format.errors({ stack: true }),
    winston.format.splat(),
    winston.format.json()
  ),
  defaultMeta: { service: 'blog-cms' },
  transports: [
    // Error logs
    new winston.transports.File({
      filename: path.join('logs', 'error.log'),
      level: 'error',
      maxsize: 5242880, // 5MB
      maxFiles: 5
    }),
    // Combined logs
    new winston.transports.File({
      filename: path.join('logs', 'combined.log'),
      maxsize: 5242880,
      maxFiles: 5
    })
  ]
});

// Console logging in development
if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.combine(
      winston.format.colorize(),
      winston.format.printf(
        ({ level, message, timestamp, ...meta }) => {
          return `${timestamp} [${level}]: ${message} ${
            Object.keys(meta).length ? JSON.stringify(meta, null, 2) : ''
          }`;
        }
      )
    )
  }));
}

module.exports = logger;
```

### 7. Redis Configuration (src/config/redis.js)

```javascript
const Redis = require('ioredis');
const logger = require('./logger');

const redisClient = new Redis(process.env.REDIS_URL, {
  maxRetriesPerRequest: 3,
  enableReadyCheck: true,
  retryStrategy(times) {
    const delay = Math.min(times * 50, 2000);
    return delay;
  }
});

redisClient.on('connect', () => {
  logger.info('✅ Redis connected');
});

redisClient.on('error', (err) => {
  logger.error('❌ Redis error:', err);
});

redisClient.on('reconnecting', () => {
  logger.warn('⚠️  Redis reconnecting...');
});

const testRedisConnection = async () => {
  try {
    await redisClient.ping();
    logger.info('✅ Redis connection test passed');
  } catch (error) {
    logger.error('❌ Redis connection test failed:', error);
    throw error;
  }
};

module.exports = {
  redisClient,
  testRedisConnection
};
```

### 8. CORS Configuration (src/config/cors.js)

```javascript
const corsConfig = {
  origin: process.env.NODE_ENV === 'production'
    ? process.env.ALLOWED_ORIGINS?.split(',') || []
    : ['http://localhost:3000', 'http://localhost:3001'],
  credentials: true,
  optionsSuccessStatus: 200
};

module.exports = corsConfig;
```

### 9. Rate Limiting (src/middleware/rateLimiter.js)

```javascript
const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');
const { redisClient } = require('../config/redis');

const createLimiter = (windowMs, max, message) => {
  return rateLimit({
    store: new RedisStore({
      client: redisClient,
      prefix: 'rl:'
    }),
    windowMs,
    max,
    message: { error: 'Too Many Requests', message },
    standardHeaders: true,
    legacyHeaders: false
  });
};

module.exports = {
  global: createLimiter(
    15 * 60 * 1000, // 15 minutes
    100,
    'Too many requests from this IP, please try again later'
  ),
  
  auth: createLimiter(
    15 * 60 * 1000,
    5,
    'Too many authentication attempts, please try again later'
  ),
  
  api: createLimiter(
    15 * 60 * 1000,
    50,
    'API rate limit exceeded'
  )
};
```

### 10. 404 Handler (src/middleware/notFoundHandler.js)

```javascript
const { NotFoundError } = require('../utils/errors');

const notFoundHandler = (req, res, next) => {
  next(new NotFoundError('Route'));
};

module.exports = notFoundHandler;
```

---

## Success Criteria

- ✅ Server starts successfully on configured port
- ✅ Middleware loads in correct order
- ✅ Security headers present in all responses
- ✅ Errors caught by centralized error handler
- ✅ Errors logged with Winston
- ✅ Health check endpoints return correct status
- ✅ Database health check works
- ✅ Redis health check works
- ✅ Rate limiting prevents excessive requests
- ✅ Graceful shutdown works (SIGTERM/SIGINT)
- ✅ No stack traces in production mode
- ✅ Sessions stored in Redis
- ✅ CORS configured correctly

---

**Estimated Time:** 3-4 days  
**Status:** 🔴 Not Started
