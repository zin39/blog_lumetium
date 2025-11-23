# Milestone 5: Posts Management System  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 4-5 days

### Objective
Full CRUD operations for blog posts with SEO features.

### Deliverables
1. **Post Routes:**
   - GET `/api/posts` - List published posts (paginated, public)
   - GET `/api/posts/:slug` - Get single post (public)
   - POST `/api/posts` - Create post (auth, author/admin)
   - PUT `/api/posts/:id` - Update post (auth, owner/admin)
   - DELETE `/api/posts/:id` - Delete post (auth, owner/admin)
   - PATCH `/api/posts/:id/publish` - Publish draft (auth, owner/admin)
   - GET `/api/posts/drafts` - List user's drafts (auth)
   - GET `/api/posts/user/:userId` - Get user's published posts (public)

2. **Post Controller & Service:**
   - Pagination (default 10 per page)
   - Filter by status (published/draft)
   - Sort by date, view_count
   - Slug generation (unique, URL-safe)
   - HTML content sanitization (XSS prevention)
   - View count increment (async)
   - Author info inclusion
   - Ownership verification for updates/deletes

3. **Utilities:**
   - Slugify function with uniqueness check
   - HTML sanitizer (allow safe tags: p, br, strong, em, ul, ol, li, a, h1-h6, code, pre)

4. **Validators:**
   - Title: 5-200 chars
   - Content: min 50 chars
   - Sanitize HTML inputs

### Success Criteria
- ✅ All CRUD operations work  
- ✅ Only authors/admins can create posts  
- ✅ Only owners/admins can edit/delete  
- ✅ Slugs are unique and SEO-friendly  
- ✅ Drafts only visible to owner/admin  
- ✅ HTML sanitized against XSS  
- ✅ View count increments correctly  

---
