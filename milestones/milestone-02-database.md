# Milestone 2: Database Layer & Prisma Setup

**Duration:** 3-4 days  
**Status:** 🔴 Not Started  
**Dependencies:** Milestone 1 (Foundation)

---

## Objective

Establish complete database layer with Prisma ORM, define all schemas, create migrations, and seed initial data for development and testing.

---

## Prerequisites

- ✅ Milestone 1 completed
- PostgreSQL 13+ installed and running
- Database created (`blog_cms`)
- Database user with proper permissions

---

## Detailed Deliverables

### 1. Prisma Initialization

#### 1.1 Initialize Prisma
```bash
npx prisma init
```

This creates:
- `prisma/schema.prisma` - Database schema file
- `.env` - Adds DATABASE_URL (if not exists)

#### 1.2 Update DATABASE_URL in .env
```
DATABASE_URL="postgresql://username:password@localhost:5432/blog_cms"
```

---

### 2. Complete Prisma Schema Definition

Create the full schema in `prisma/schema.prisma`:

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// ============================================
// USER MODELS
// ============================================

model User {
  id             String   @id @default(uuid())
  email          String   @unique
  password_hash  String
  role           Role     @default(READER)
  email_verified Boolean  @default(false)
  banned         Boolean  @default(false)
  ban_reason     String?
  created_at     DateTime @default(now())
  updated_at     DateTime @updatedAt

  // Relations
  posts           Post[]
  comments        Comment[]
  sessions        Session[]
  refresh_tokens  RefreshToken[]
  password_resets PasswordReset[]
  email_preferences EmailPreference?
  admin_logs      AdminLog[]

  @@index([email])
  @@index([role])
  @@index([created_at])
}

enum Role {
  ADMIN
  AUTHOR
  READER
}

// ============================================
// AUTHENTICATION MODELS
// ============================================

model Session {
  id         String   @id @default(uuid())
  user_id    String
  sid        String   @unique
  data       String   @db.Text
  expires_at DateTime
  created_at DateTime @default(now())

  user User @relation(fields: [user_id], references: [id], onDelete: Cascade)

  @@index([user_id])
  @@index([expires_at])
  @@index([sid])
}

model RefreshToken {
  id         String   @id @default(uuid())
  user_id    String
  token      String   @unique
  expires_at DateTime
  revoked    Boolean  @default(false)
  created_at DateTime @default(now())

  user User @relation(fields: [user_id], references: [id], onDelete: Cascade)

  @@index([user_id])
  @@index([token])
  @@index([expires_at])
}

model PasswordReset {
  id         String   @id @default(uuid())
  user_id    String
  token      String   @unique
  expires_at DateTime
  used       Boolean  @default(false)
  used_at    DateTime?
  created_at DateTime @default(now())

  user User @relation(fields: [user_id], references: [id], onDelete: Cascade)

  @@index([user_id])
  @@index([token])
  @@index([expires_at])
}

// ============================================
// CONTENT MODELS
// ============================================

model Post {
  id           String     @id @default(uuid())
  title        String
  slug         String     @unique
  content      String     @db.Text
  excerpt      String?    @db.Text
  author_id    String
  status       PostStatus @default(DRAFT)
  view_count   Int        @default(0)
  published_at DateTime?
  created_at   DateTime   @default(now())
  updated_at   DateTime   @updatedAt

  // Full-text search
  search_vector String? @db.Text

  // Relations
  author   User        @relation(fields: [author_id], references: [id], onDelete: Cascade)
  comments Comment[]
  images   PostImage[]
  views    PostView[]

  @@index([author_id])
  @@index([slug])
  @@index([status])
  @@index([published_at])
  @@index([created_at])
  @@index([view_count])
}

enum PostStatus {
  DRAFT
  PUBLISHED
  ARCHIVED
}

model Comment {
  id                String   @id @default(uuid())
  post_id           String
  user_id           String
  parent_comment_id String?
  content           String   @db.Text
  is_approved       Boolean  @default(false)
  is_flagged        Boolean  @default(false)
  flag_count        Int      @default(0)
  created_at        DateTime @default(now())
  updated_at        DateTime @updatedAt

  // Relations
  post    Post      @relation(fields: [post_id], references: [id], onDelete: Cascade)
  user    User      @relation(fields: [user_id], references: [id], onDelete: Cascade)
  parent  Comment?  @relation("CommentReplies", fields: [parent_comment_id], references: [id], onDelete: Cascade)
  replies Comment[] @relation("CommentReplies")

  @@index([post_id])
  @@index([user_id])
  @@index([parent_comment_id])
  @@index([is_approved])
  @@index([is_flagged])
  @@index([created_at])
}

// ============================================
// MEDIA MODELS
// ============================================

model PostImage {
  id         String   @id @default(uuid())
  post_id    String
  filename   String
  url        String
  size       Int
  mime_type  String
  width      Int?
  height     Int?
  variant    ImageVariant @default(ORIGINAL)
  created_at DateTime @default(now())

  post Post @relation(fields: [post_id], references: [id], onDelete: Cascade)

  @@index([post_id])
  @@index([variant])
}

enum ImageVariant {
  ORIGINAL
  LARGE
  MEDIUM
  THUMBNAIL
}

// ============================================
// ANALYTICS MODELS
// ============================================

model PostView {
  id         String   @id @default(uuid())
  post_id    String
  user_id    String?
  ip_hash    String?
  user_agent String?
  referrer   String?
  viewed_at  DateTime @default(now())

  post Post  @relation(fields: [post_id], references: [id], onDelete: Cascade)

  @@index([post_id])
  @@index([viewed_at])
  @@index([ip_hash])
}

model SearchQuery {
  id           String   @id @default(uuid())
  query        String
  user_id      String?
  result_count Int
  created_at   DateTime @default(now())

  @@index([query])
  @@index([created_at])
  @@index([user_id])
}

// ============================================
// EMAIL MODELS
// ============================================

model EmailPreference {
  id                    String  @id @default(uuid())
  user_id               String  @unique
  comment_notifications Boolean @default(true)
  reply_notifications   Boolean @default(true)
  weekly_digest         Boolean @default(true)
  marketing_emails      Boolean @default(false)

  user User @relation(fields: [user_id], references: [id], onDelete: Cascade)
}

model EmailLog {
  id         String      @id @default(uuid())
  user_id    String?
  to         String
  subject    String
  type       String
  status     EmailStatus @default(QUEUED)
  sent_at    DateTime?
  error      String?     @db.Text
  created_at DateTime    @default(now())

  @@index([user_id])
  @@index([status])
  @@index([created_at])
  @@index([type])
}

enum EmailStatus {
  QUEUED
  SENT
  FAILED
  BOUNCED
}

// ============================================
// ADMIN MODELS
// ============================================

model AdminLog {
  id          String   @id @default(uuid())
  admin_id    String
  action      String
  target_type String
  target_id   String
  details     Json?
  ip_address  String?
  created_at  DateTime @default(now())

  admin User @relation(fields: [admin_id], references: [id], onDelete: Cascade)

  @@index([admin_id])
  @@index([action])
  @@index([target_type])
  @@index([created_at])
}
```

---

### 3. Create Initial Migration

#### 3.1 Generate Migration
```bash
npx prisma migrate dev --name init
```

This will:
- Create migration files in `prisma/migrations/`
- Apply migration to database
- Generate Prisma Client

#### 3.2 Verify Migration
```bash
npx prisma migrate status
```

---

### 4. Create Seed Script

Create `prisma/seed.js`:

```javascript
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed...');

  // Hash password for users
  const hashedPassword = await bcrypt.hash('Password123!', 12);

  // Create Admin User
  const admin = await prisma.user.create({
    data: {
      email: 'admin@blog-cms.com',
      password_hash: hashedPassword,
      role: 'ADMIN',
      email_verified: true
    }
  });
  console.log('✅ Created admin user:', admin.email);

  // Create Author Users
  const authors = [];
  for (let i = 1; i <= 3; i++) {
    const author = await prisma.user.create({
      data: {
        email: `author${i}@blog-cms.com`,
        password_hash: hashedPassword,
        role: 'AUTHOR',
        email_verified: true
      }
    });
    authors.push(author);
    console.log(`✅ Created author user: ${author.email}`);
  }

  // Create Reader Users
  for (let i = 1; i <= 5; i++) {
    await prisma.user.create({
      data: {
        email: `reader${i}@blog-cms.com`,
        password_hash: hashedPassword,
        role: 'READER',
        email_verified: i <= 3 // First 3 verified
      }
    });
  }
  console.log('✅ Created 5 reader users');

  // Create Sample Posts
  const postTitles = [
    'Getting Started with Node.js',
    'Introduction to PostgreSQL',
    'Building RESTful APIs with Express',
    'Understanding JWT Authentication',
    'Prisma ORM Best Practices',
    'Full-Text Search in PostgreSQL',
    'Real-time Applications with Socket.io',
    'Image Upload and Processing',
    'Email Notifications with Nodemailer',
    'Caching Strategies with Redis'
  ];

  const posts = [];
  for (let i = 0; i < postTitles.length; i++) {
    const author = authors[i % authors.length];
    const post = await prisma.post.create({
      data: {
        title: postTitles[i],
        slug: postTitles[i].toLowerCase().replace(/\s+/g, '-'),
        content: `<p>This is the content for "${postTitles[i]}". Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p><p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>`,
        excerpt: `Learn about ${postTitles[i]} in this comprehensive guide.`,
        author_id: author.id,
        status: i < 7 ? 'PUBLISHED' : 'DRAFT', // First 7 published
        published_at: i < 7 ? new Date() : null,
        view_count: Math.floor(Math.random() * 100)
      }
    });
    posts.push(post);
  }
  console.log(`✅ Created ${posts.length} posts`);

  // Create Comments
  const readers = await prisma.user.findMany({
    where: { role: 'READER' }
  });

  for (const post of posts.slice(0, 5)) { // Add comments to first 5 posts
    // Top-level comments
    for (let i = 0; i < 3; i++) {
      const reader = readers[i % readers.length];
      const comment = await prisma.comment.create({
        data: {
          post_id: post.id,
          user_id: reader.id,
          content: `Great article about ${post.title}! Very informative.`,
          is_approved: true
        }
      });

      // Reply to comment
      if (i === 0) {
        await prisma.comment.create({
          data: {
            post_id: post.id,
            user_id: authors[0].id,
            parent_comment_id: comment.id,
            content: 'Thank you for reading!',
            is_approved: true
          }
        });
      }
    }
  }
  console.log('✅ Created sample comments');

  // Create Email Preferences
  const allUsers = await prisma.user.findMany();
  for (const user of allUsers) {
    await prisma.emailPreference.create({
      data: {
        user_id: user.id,
        comment_notifications: true,
        reply_notifications: true,
        weekly_digest: user.role !== 'READER'
      }
    });
  }
  console.log('✅ Created email preferences');

  console.log('🎉 Seed completed successfully!');
  console.log('\n📊 Summary:');
  console.log(`  - Users: ${allUsers.length}`);
  console.log(`  - Posts: ${posts.length}`);
  console.log(`  - Admin: admin@blog-cms.com / Password123!`);
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

#### 4.2 Add Seed Command to package.json
Already configured in Milestone 1:
```json
"db:seed": "node prisma/seed.js"
```

#### 4.3 Run Seed Script
```bash
npm run db:seed
```

---

### 5. Database Connection Utility

Create `src/config/database.js`:

```javascript
const { PrismaClient } = require('@prisma/client');
const logger = require('./logger');

const prisma = new PrismaClient({
  log: [
    {
      emit: 'event',
      level: 'query'
    },
    {
      emit: 'event',
      level: 'error'
    },
    {
      emit: 'event',
      level: 'warn'
    }
  ]
});

// Log queries in development
if (process.env.NODE_ENV === 'development') {
  prisma.$on('query', (e) => {
    logger.debug(`Query: ${e.query}`);
    logger.debug(`Duration: ${e.duration}ms`);
  });
}

prisma.$on('error', (e) => {
  logger.error('Database error:', e);
});

prisma.$on('warn', (e) => {
  logger.warn('Database warning:', e);
});

// Test connection
const testConnection = async () => {
  try {
    await prisma.$connect();
    logger.info('✅ Database connected successfully');
  } catch (error) {
    logger.error('❌ Database connection failed:', error);
    process.exit(1);
  }
};

// Graceful shutdown
const disconnect = async () => {
  await prisma.$disconnect();
  logger.info('Database disconnected');
};

module.exports = {
  prisma,
  testConnection,
  disconnect
};
```

---

## Verification Steps

### 1. Verify Prisma Installation
```bash
npx prisma --version
```

### 2. Verify Database Connection
```bash
npx prisma db pull
```
- Should connect without errors

### 3. Generate Prisma Client
```bash
npx prisma generate
```
- Should generate without errors
- Creates `node_modules/.prisma/client`

### 4. Open Prisma Studio (Database GUI)
```bash
npx prisma studio
```
- Opens at http://localhost:5555
- Verify tables exist
- Verify seed data present

### 5. Run Simple Query Test
Create `test-db.js`:
```javascript
const { prisma } = require('./src/config/database');

async function test() {
  const users = await prisma.user.findMany();
  console.log(`Found ${users.length} users`);
  console.log(users);
  await prisma.$disconnect();
}

test();
```

Run:
```bash
node test-db.js
```

---

## Success Criteria

- ✅ Prisma installed and initialized
- ✅ schema.prisma contains all 13 models
- ✅ Initial migration created successfully
- ✅ Database tables created with correct schema
- ✅ Indexes created on all foreign keys and queried columns
- ✅ Seed script runs without errors
- ✅ Sample data populated (1 admin, 3 authors, 5 readers, 10 posts, comments)
- ✅ Prisma Client generates successfully
- ✅ Database connection utility works
- ✅ Can query database using Prisma Client
- ✅ Prisma Studio opens and shows data

---

## Database Schema Overview

**Total Models:** 13

### User & Auth (5)
- User
- Session
- RefreshToken
- PasswordReset
- EmailPreference

### Content (2)
- Post
- Comment

### Media (1)
- PostImage

### Analytics (2)
- PostView
- SearchQuery

### Email (1)
- EmailLog

### Admin (1)
- AdminLog

**Total Enums:** 4 (Role, PostStatus, ImageVariant, EmailStatus)

---

## Common Issues & Solutions

### Issue: Migration fails
**Solution:**
- Ensure PostgreSQL is running
- Verify DATABASE_URL is correct
- Check database user has CREATE permissions
- Drop database and recreate: `npx prisma migrate reset`

### Issue: Prisma Client not found
**Solution:**
- Run `npx prisma generate`
- Restart your editor/IDE

### Issue: Seed script fails
**Solution:**
- Ensure migrations ran first
- Check bcrypt is installed
- Verify no unique constraint violations

---

## Next Steps

Once this milestone is complete, proceed to:
- **Milestone 3:** Core Application & Middleware Pipeline

---

## Checklist

- [ ] Prisma initialized
- [ ] schema.prisma created with all models
- [ ] All enums defined
- [ ] Indexes added to schema
- [ ] Initial migration created
- [ ] Migration applied to database
- [ ] Seed script created
- [ ] Seed script executed successfully
- [ ] Database connection utility created
- [ ] Prisma Client generated
- [ ] Verified data in Prisma Studio
- [ ] Test query successful
- [ ] Verified all success criteria

---

**Estimated Time:** 3-4 days  
**Status:** 🔴 Not Started

Update status to:
- 🟡 In Progress
- 🟢 Complete
