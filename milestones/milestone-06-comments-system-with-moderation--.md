# Milestone 6: Comments System with Moderation  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 4-5 days

### Objective
Threaded comments with moderation queue and spam prevention.

### Deliverables
1. **Comment Routes:**
   - GET `/api/posts/:postId/comments` - Get approved comments (public, threaded)
   - POST `/api/posts/:postId/comments` - Create comment (auth)
   - POST `/api/comments/:id/reply` - Reply to comment (auth)
   - PUT `/api/comments/:id` - Edit own comment (auth)
   - DELETE `/api/comments/:id` - Delete own comment (auth)
   - PATCH `/api/admin/comments/:id/approve` - Approve (admin)
   - PATCH `/api/admin/comments/:id/reject` - Reject (admin)
   - PATCH `/api/comments/:id/flag` - Flag spam (auth)
   - GET `/api/admin/comments/pending` - Moderation queue (admin)

2. **Comment Controller & Service:**
   - Threaded structure (parent -> replies)
   - Auto-approval for trusted users (admins, verified authors)
   - Manual approval for new users
   - Content sanitization (limited HTML)
   - Ownership verification for edits/deletes
   - Build comment tree utility

3. **Spam Prevention:**
   - Rate limiting: 20 comments/hour per user
   - Keyword blacklist filter
   - Link spam detection (max 2 links)
   - Duplicate comment detection

4. **Validators:**
   - Content: 1-2000 chars
   - Sanitize HTML (very limited tags)

### Success Criteria
- ✅ Comments display in threaded format  
- ✅ New user comments enter moderation  
- ✅ Trusted user comments auto-approved  
- ✅ Only owners can edit/delete comments  
- ✅ Admins can approve/reject any comment  
- ✅ Rate limiting prevents spam  
- ✅ HTML sanitized  

---
