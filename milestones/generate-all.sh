#!/bin/bash

# Milestone 4: Authentication
cat > milestone-04-authentication.md <<'M4'
# Milestone 4: Authentication System (Hybrid)

**Duration:** 5-6 days  
**Status:** 🔴 Not Started  
**Dependencies:** M1, M2, M3

## Objective
Implement complete hybrid authentication system with both JWT (stateless) and session-based (stateful) approaches for maximum flexibility.

## Key Features
- User registration with email verification
- Login with JWT + Session creation
- Password reset workflow
- Token refresh mechanism
- Role-based access control
- Account lockout after failed attempts

## Routes to Implement

### Auth Routes (src/routes/auth.js)
```javascript
POST /api/auth/register          - User registration
POST /api/auth/login             - Login (creates JWT + session)
POST /api/auth/logout            - Logout (invalidate both)
POST /api/auth/refresh           - Refresh access token
POST /api/auth/forgot-password   - Request password reset
POST /api/auth/reset-password    - Reset password with token
POST /api/auth/verify-email      - Verify email address
POST /api/auth/resend-verification - Resend verification email
```

## File Structure
```
src/
├── routes/auth.js
├── controllers/authController.js
├── services/AuthService.js
├── middleware/
│   ├── auth.js (requireAuth, requireSession, authenticate)
│   ├── roleCheck.js (requireRole)
│   └── validators/authValidator.js
└── utils/
    ├── jwt.js (token generation/verification)
    └── bcrypt.js (password hashing)
```

## Core Implementation Files

### 1. Auth Routes (src/routes/auth.js)
- Define all authentication endpoints
- Apply input validation middleware
- Apply rate limiting for sensitive endpoints

### 2. Auth Controller (src/controllers/authController.js)
- registerHandler: validate email, hash password, send verification email
- loginHandler: verify credentials, generate JWT + session, set cookies
- logoutHandler: blacklist JWT, destroy session
- refreshHandler: validate refresh token, generate new access token
- forgotPasswordHandler: generate reset token, send email
- resetPasswordHandler: validate token, update password
- verifyEmailHandler: mark email as verified

### 3. Auth Service (src/services/AuthService.js)
Business logic for:
- User registration workflow
- Credential validation
- Token generation and validation
- Password reset workflow
- Email verification workflow

### 4. JWT Utilities (src/utils/jwt.js)
```javascript
generateAccessToken(userId, email, role)  // 15min expiry
generateRefreshToken(userId)              // 7 days expiry
verifyAccessToken(token)
verifyRefreshToken(token)
decodeToken(token)
```

### 5. Password Utilities (src/utils/bcrypt.js)
```javascript
hashPassword(password)                    // bcrypt cost factor 12
comparePassword(password, hash)
validatePasswordStrength(password)        // min 8 chars, uppercase, lowercase, number
```

### 6. Auth Middleware (src/middleware/auth.js)
```javascript
requireAuth         // Validate JWT from cookie or Authorization header
requireSession      // Validate session exists in Redis
authenticate        // Try JWT first, fallback to session
optionalAuth        // Add user if token present, don't fail if missing
```

### 7. Role Check Middleware (src/middleware/roleCheck.js)
```javascript
requireRole(['admin'])                    // Only admins
requireRole(['admin', 'author'])          // Admins or authors
requireOwnerOrAdmin(resourceUserId)       // Owner of resource or admin
```

### 8. Input Validators (src/middleware/validators/authValidator.js)
Using express-validator:
- registerValidator: email (valid, unique), password (strong)
- loginValidator: email, password required
- passwordResetValidator: token, new password
- emailValidator: valid email format

## Token Blacklist (Redis)

When user logs out, add JWT to blacklist:
```javascript
// src/services/TokenBlacklistService.js
addToBlacklist(token, expiresIn)  // TTL = token expiry
isBlacklisted(token)               // Check before validating
```

## Password Reset Flow
1. User requests password reset
2. Generate secure token (UUID), store in database with 1-hour expiry
3. Send email with reset link
4. User clicks link, submits new password
5. Validate token not expired/used
6. Hash new password, update database
7. Invalidate all user sessions
8. Mark token as used

## Email Verification Flow
1. On registration, generate verification token
2. Store token in database or encode in JWT
3. Send verification email with link
4. User clicks link
5. Mark user.email_verified = true
6. Delete verification token

## Security Considerations
- Rate limit login attempts (5 per 15 min)
- Rate limit registration (3 per 15 min)
- Account lockout after 5 failed logins (15 min duration)
- Store only password hashes (bcrypt cost 12)
- JWT in httpOnly cookies (prevent XSS)
- Refresh tokens stored in database
- CSRF protection for session-based routes

## Success Criteria
- ✅ Users can register with valid email/password
- ✅ Duplicate emails rejected
- ✅ Weak passwords rejected  
- ✅ Login with correct credentials succeeds
- ✅ Login with incorrect credentials fails
- ✅ JWT tokens generated with correct expiry
- ✅ Refresh token flow works
- ✅ Both JWT and session auth work independently
- ✅ Protected routes reject unauthenticated requests
- ✅ Logout invalidates both JWT and session
- ✅ Password reset flow completes successfully
- ✅ Email verification marks user as verified
- ✅ Role-based access control works
- ✅ Account lockout prevents brute force
- ✅ Passwords stored as bcrypt hashes only

**Status:** 🔴 Not Started
M4

# Milestone 5-18 - Create concise versions from the main milestones.md
# These will be extracted and expanded from the existing content

for i in {5..18}; do
  NUM=$(printf "%02d" $i)
  
  # Extract milestone title from main milestones.md
  TITLE=$(sed -n "/^## Milestone $i:/p" ../milestones.md | sed 's/## Milestone [0-9]*: //')
  
  if [ -z "$TITLE" ]; then
    echo "⚠️  Could not find Milestone $i in milestones.md"
    continue
  fi
  
  # Create placeholder file with extracted content from milestones.md
  {
    echo "# Milestone $i: $TITLE"
    echo ""
    echo "**Duration:** See main specification"
    echo "**Status:** 🔴 Not Started  "
    echo "**Dependencies:** See milestone dependency chart"
    echo ""
    echo "---"
    echo ""
    echo "## Full Specification"
    echo ""
    echo "This milestone has been extracted from the main milestones.md file."
    echo "Refer to ../milestones.md for complete details on:"
    echo ""
    # Extract the section for this milestone from milestones.md
    sed -n "/^## Milestone $i:/,/^---$/p" ../milestones.md | tail -n +2
  } > "milestone-$NUM-$(echo "$TITLE" | tr '[:upper:] ' '[:lower:]-' | tr -cd '[:alnum:]-').md"
  
  echo "✅ Created milestone-$NUM-*.md"
done

echo ""
echo "🎉 All milestone files created!"
echo "📁 Location: milestones/"
