# Milestone 14: Caching Layer with Redis  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 3-4 days

### Objective
Implement comprehensive caching for performance.

### Deliverables
1. **Cache Service:**
   - get(key), set(key, value, ttl), del(key), delPattern(pattern)
   - cachePost(postId, data, ttl), getPost(postId)
   - cacheSearchResults(queryHash, results)
   - invalidatePost(postId), invalidateAllPosts()

2. **Caching Strategy:**
   - Post detail: 5-min TTL, invalidate on update
   - Post lists: 2-min TTL
   - Search results: 15-min TTL
   - View counts: write-through cache, batch to DB hourly

3. **Cache Middleware:**
   - Route-level caching
   - Generate cache key from request
   - Override res.json to cache response
   - Usage: `router.get('/posts/:slug', cacheMiddleware(300), handler)`

4. **Cache Invalidation:**
   - On post update: invalidate post, lists, search, sitemap
   - On comment approved: invalidate post (comment count changed)
   - On new user: invalidate admin stats

5. **HTTP Cache Headers:**
   - Cache-Control headers
   - ETags for conditional requests
   - Last-Modified headers

6. **Cache Warming:**
   - Pre-cache popular posts on startup
   - Background job to refresh hot content

7. **View Count Aggregation (background job):**
   - Cron every hour
   - Read counts from Redis
   - Batch update database
   - Clear Redis counters

8. **Cache Monitoring:**
   - Track hit/miss ratio
   - Expose metrics: GET `/api/admin/cache/stats`

### Success Criteria
- ✅ Cache hit rate >70%  
- ✅ Response times improve >50%  
- ✅ Cache invalidates correctly  
- ✅ View counts aggregate without data loss  
- ✅ ETags work for 304 responses  
- ✅ No memory leaks  

---
