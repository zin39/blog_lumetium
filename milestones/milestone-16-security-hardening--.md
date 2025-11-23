# Milestone 16: Security Hardening  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 4-5 days

### Objective
Ensure production-ready security posture.

### Deliverables
1. **Input Validation (express-validator):**
   - Validate all request bodies, params, queries
   - Type checking, length limits, patterns
   - Sanitize inputs (trim, escape, normalize)

2. **HTML Sanitization (sanitize-html):**
   - Allowlist safe tags for posts
   - Strip all HTML except basic formatting for comments
   - Remove scripts, event handlers

3. **XSS Prevention:**
   - Sanitize all user content before storage
   - Content Security Policy headers
   - X-XSS-Protection header

4. **CSRF Protection (csurf):**
   - CSRF tokens for session-based routes
   - SameSite cookie attribute

5. **Rate Limiting:**
   - Global: 100 req/15min per IP
   - Login: 5 attempts/15min per IP
   - Register: 3 attempts/15min per IP
   - Password reset: 3/hour per IP
   - Posts: 10 creates/hour per user
   - Comments: 20 creates/hour per user
   - API: 50 req/15min per authenticated user

6. **Security Headers (Helmet):**
   - HSTS, X-Frame-Options, X-Content-Type-Options, CSP, Referrer-Policy

7. **HTTP Parameter Pollution (hpp):**
   - Prevent duplicate parameters

8. **Secure Cookies:**
   - httpOnly, secure (production), sameSite, signed

9. **Password Security:**
   - Min 8 chars, require uppercase, lowercase, number
   - Bcrypt cost factor 12
   - Check against common passwords

10. **Account Lockout:**
    - Lock after 5 failed login attempts (15-min duration)
    - Notify user via email
    - Track in Redis

11. **File Upload Security:**
    - MIME validation
    - Magic number verification
    - File size limits
    - Sanitize filenames
    - Virus scanning (optional)

12. **Dependency Security:**
    - `npm audit` regularly
    - Fix vulnerabilities
    - Keep dependencies updated

13. **Error Handling Security:**
    - Never expose stack traces in production
    - Generic error messages to users
    - Detailed errors logged server-side

### Success Criteria
- ✅ `npm audit` shows 0 vulnerabilities  
- ✅ All inputs validated and sanitized  
- ✅ Rate limiting prevents abuse  
- ✅ Security headers pass scan  
- ✅ No XSS, SQLi, CSRF vulnerabilities  
- ✅ Account lockout works  
- ✅ Stack traces hidden in production  

---
