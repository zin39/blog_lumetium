# Milestone 8: User Management & Profiles  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 3-4 days

### Objective
User profile management and role-based access control.

### Deliverables
1. **User Routes:**
   - GET `/api/users/me` - Get profile (auth)
   - PUT `/api/users/me` - Update profile (auth)
   - PATCH `/api/users/me/password` - Change password (auth)
   - DELETE `/api/users/me` - Delete account (auth)
   - GET `/api/users/:id/posts` - Get user's posts (public)
   - GET `/api/users/:id/profile` - Get public profile (public)

2. **Admin User Routes:**
   - GET `/api/admin/users` - List all users (admin, paginated)
   - PATCH `/api/admin/users/:id/role` - Change role (admin)
   - PATCH `/api/admin/users/:id/ban` - Ban/unban (admin)
   - DELETE `/api/admin/users/:id` - Delete user (admin)

3. **User Service:**
   - Profile update with email verification on email change
   - Password change (require old password)
   - Account deletion (soft delete, anonymize data)
   - User statistics (post count, comment count)
   - Ban user with reason logging

4. **Middleware:**
   - requireRole middleware
   - requireOwnerOrAdmin middleware
   - checkBan middleware (prevent banned users from actions)

### Success Criteria
- ✅ Users can view/update profiles  
- ✅ Password change requires old password  
- ✅ Account deletion works correctly  
- ✅ Admins can manage users  
- ✅ Role-based access enforced  
- ✅ Banned users cannot login  
- ✅ GDPR-compliant data deletion  

---
