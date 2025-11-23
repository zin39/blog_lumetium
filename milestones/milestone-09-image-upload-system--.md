# Milestone 9: Image Upload System  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 4-5 days

### Objective
Allow image uploads for blog posts with cloud storage.

### Deliverables
1. **Upload Configuration:**
   - Multer middleware (5MB limit)
   - Allowed types: JPEG, PNG, WebP, GIF
   - Unique filenames (UUID + extension)
   - Local storage (dev) or S3/Cloudinary (production)

2. **Image Routes:**
   - POST `/api/posts/:id/images` - Upload image (auth, owner/admin)
   - DELETE `/api/images/:id` - Delete image (auth, owner/admin)
   - GET `/api/images/:filename` - Serve image (public, if local)

3. **Image Processing (Sharp):**
   - Resize to multiple variants: thumbnail (150x150), medium (800x600), full (1920x1080 max)
   - Optimize compression
   - Preserve aspect ratio
   - Strip EXIF data (privacy)

4. **File Validation:**
   - Magic number verification (check file header)
   - File size limits
   - MIME type validation
   - Sanitize filenames

5. **S3 Integration (optional):**
   - Configure AWS SDK
   - Upload to S3 bucket
   - Generate public URLs

6. **Cleanup Job:**
   - Delete orphaned images (not associated with posts)
   - Run daily

### Success Criteria
- ✅ Images upload successfully  
- ✅ File size and type limits enforced  
- ✅ Magic number validation works  
- ✅ Images resized and optimized  
- ✅ Multiple variants generated  
- ✅ Deleted posts remove images  
- ✅ EXIF data stripped  

---
