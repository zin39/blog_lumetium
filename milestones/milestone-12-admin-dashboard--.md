# Milestone 12: Admin Dashboard  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 5-6 days

### Objective
Comprehensive admin panel for content and user management.

### Deliverables
1. **Admin Dashboard Routes:**
   - GET `/api/admin/dashboard` - Overview stats
   - GET `/api/admin/dashboard/activity` - Recent activity feed
   - GET `/api/admin/dashboard/stats` - Detailed statistics

2. **Admin Content Routes:**
   - GET `/api/admin/posts` - All posts with filters
   - DELETE `/api/admin/posts/:id` - Delete any post
   - GET `/api/admin/comments` - All comments
   - PATCH `/api/admin/comments/bulk-approve` - Bulk approve
   - PATCH `/api/admin/comments/bulk-reject` - Bulk reject

3. **Admin Dashboard Stats:**
   - Total users (with growth %)
   - Total posts (published vs drafts)
   - Total comments (approved vs pending)
   - New users this week
   - Active users (last 7 days)
   - Popular posts (top 10 by views)
   - Flagged content count

4. **Activity Feed:**
   - Recent registrations
   - Recent posts published
   - Pending comments
   - Flagged comments
   - Role changes
   - User bans

5. **Admin Service:**
   - getDashboardStats()
   - getActivityFeed()
   - getUserGrowthData()
   - Aggregate queries optimized

6. **Activity Logging:**
   - AdminLog model (track all admin actions)
   - Log: delete_post, ban_user, approve_comment, etc.
   - Auto-log middleware for admin routes

### Success Criteria
- ✅ Only admins can access dashboard  
- ✅ Statistics accurate  
- ✅ Activity feed shows recent actions  
- ✅ Admins can view/delete all content  
- ✅ Bulk operations work  
- ✅ All actions logged  

---
