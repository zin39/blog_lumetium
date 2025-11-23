# Milestone 13: Analytics & SEO  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 4-5 days

### Objective
Track user behavior and optimize for search engines.

### Deliverables
1. **Analytics Tracking Middleware:**
   - Track page views (post_id, user_id, IP, user_agent, referrer)
   - Respect DNT header
   - Hash IP addresses (privacy)
   - Async tracking (don't slow response)

2. **Analytics Service:**
   - trackPageView()
   - getPostViews(postId, dateRange)
   - getPopularPosts(limit, dateRange)
   - getUniqueVisitors(postId)
   - getTrafficSources()
   - aggregateViewCounts() - batch update post.view_count

3. **Analytics Routes:**
   - GET `/api/analytics/posts/:id/views` - View stats
   - GET `/api/analytics/popular` - Popular posts
   - GET `/api/admin/analytics/dashboard` - Full analytics (admin)

4. **SEO Meta Tags Middleware:**
   - Dynamic meta tags per post
   - Open Graph tags for social sharing
   - Twitter Card tags
   - Canonical URLs
   - Structured data (JSON-LD Article schema)

5. **Sitemap Generation:**
   - GET `/sitemap.xml` - XML sitemap
   - Include all published posts
   - Cache (24-hour TTL, regenerate daily)
   - Invalidate on new post

6. **Robots.txt:**
   - GET `/robots.txt`
   - Allow/disallow paths
   - Sitemap reference

7. **RSS Feed:**
   - GET `/feed.rss` - RSS 2.0 feed
   - Latest 20 posts
   - Cache (1-hour TTL)

8. **Analytics Cleanup:**
   - Delete data older than 1 year (monthly job)

### Success Criteria
- ✅ Page views tracked accurately  
- ✅ DNT respected  
- ✅ IP addresses hashed  
- ✅ View counts aggregate correctly  
- ✅ Meta tags generate correctly  
- ✅ Sitemap validates  
- ✅ RSS feed validates  
- ✅ Structured data validates  
- ✅ GDPR-compliant  

---
